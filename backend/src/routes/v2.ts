import { Router } from 'express';
import { z } from 'zod';
import { pool } from '../db/pool';
import { authRequired } from '../middleware/auth';
import { requireRole } from '../middleware/requireRole';
import { moderate, notify } from '../utils/moderation';
import { awardBadges, reputationFor } from '../utils/reputation';
import { sendPush } from '../utils/push';

export const v2Router = Router();

/**
 * V2: AI-assisted identification — heuristic possible-matches engine.
 * Presented as POSSIBLE matches with confidence + verification disclaimer
 * (prd §52). Never a guaranteed identification.
 */
v2Router.post('/identifications/:id/ai-suggest', authRequired, async (req, res, next) => {
  try {
    const r = (await pool.query(`SELECT * FROM identification_requests WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!r) {
      res.status(404).json({ error: 'Request not found' });
      return;
    }
    const { rows: species } = await pool.query(
      `SELECT s.id, s.scientific_name, s.flowering AS sp_flowering, s.fruit_bearing AS sp_fruit,
        s.min_height_m, s.max_height_m, s.description, s.leaf_description, s.flower_description,
        s.fruit_description, s.bark_description,
        (SELECT n.name FROM species_names n WHERE n.species_id = s.id AND n.is_primary AND n.name_type = 'common' LIMIT 1) AS primary_name,
        COALESCE(array_agg(DISTINCT d.province) FILTER (WHERE d.province IS NOT NULL), '{}') AS provinces
       FROM species s LEFT JOIN species_distribution d ON d.species_id = s.id
       WHERE s.verification_status = 'verified' AND s.deleted_at IS NULL
       GROUP BY s.id`,
    );
    const tokens = (t: unknown) =>
      String(t ?? '').toLowerCase().replace(/[^a-z\s]/g, ' ').split(/\s+/).filter((w) => w.length > 3);
    const reqWords = new Set(tokens(`${r.description ?? ''} ${r.habitat ?? ''}`));
    const scored = species.map((s) => {
      let score = 0;
      const reasons: string[] = [];
      if (r.flowering !== null && r.flowering !== undefined && s.sp_flowering === r.flowering) {
        score += 2;
        reasons.push(r.flowering ? 'Flowering matches this species' : 'Non-flowering matches this species');
      }
      if (r.fruiting !== null && r.fruiting !== undefined && s.sp_fruit === r.fruiting) {
        score += 2;
        reasons.push('Fruiting state matches');
      }
      if (r.province && (s.provinces as string[]).some((p) => p.toLowerCase() === String(r.province).toLowerCase())) {
        score += 1;
        reasons.push(`Documented in ${r.province}`);
      }
      if (r.estimated_height_m && s.min_height_m && s.max_height_m &&
        Number(r.estimated_height_m) >= Number(s.min_height_m) - 3 &&
        Number(r.estimated_height_m) <= Number(s.max_height_m) + 3) {
        score += 1;
        reasons.push('Estimated height fits mature size range');
      }
      const overlap = tokens(`${s.description} ${s.leaf_description} ${s.flower_description} ${s.fruit_description} ${s.bark_description}`)
        .filter((w) => reqWords.has(w)).length;
      const textPts = Math.min(2, Math.floor(overlap / 3));
      if (textPts > 0) {
        score += textPts;
        reasons.push(`${overlap} descriptive terms overlap`);
      }
      return {
        species_id: s.id as string,
        scientific_name: s.scientific_name as string,
        primary_name: s.primary_name as string | null,
        confidence: (score >= 5 ? 'high' : score >= 3 ? 'medium' : 'low') as 'high' | 'medium' | 'low',
        reasons,
        score,
      };
    })
      .filter((m) => m.score > 0)
      .sort((a, b) => b.score - a.score)
      .slice(0, 3)
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      .map(({ score, ...rest }) => rest);
    res.json({
      matches: scored,
      disclaimer: 'Possible matches only — not a guaranteed identification. Community or moderator verification is recommended.',
    });
  } catch (err) {
    next(err);
  }
});

// V2: public map feed — approved observations with safe (rounded) locations.
// NOTE: lives under /map/* (not /observations/*) so the auth-guarded
// observations router mounted earlier can never shadow it.
v2Router.get('/map/observations', async (req, res, next) => {
  try {
    const limit = Math.min(parseInt((req.query.limit as string) ?? '200', 10) || 200, 500);
    const { rows } = await pool.query(
      `SELECT o.id, o.species_id, o.province,
        ROUND(o.latitude::numeric, 2) AS lat, ROUND(o.longitude::numeric, 2) AS lng,
        (SELECT n.name FROM species_names n WHERE n.species_id = o.species_id
          AND n.is_primary AND n.name_type = 'common' LIMIT 1) AS species_name
       FROM observations o
       WHERE o.status = 'approved' AND o.deleted_at IS NULL
         AND o.location_precision = 'approximate'
         AND o.latitude IS NOT NULL AND o.longitude IS NOT NULL
       ORDER BY o.created_at DESC LIMIT $1`,
      [limit],
    );
    res.json({ points: rows });
  } catch (err) {
    next(err);
  }
});

// V2: nursery verification — request + own status (auth), review queue (admin).
v2Router.post('/nurseries/verify-request', authRequired, async (req, res, next) => {
  try {
    const schema = z.object({
      business_name: z.string().min(2).max(255),
      province: z.string().max(120).nullable().optional(),
      notes: z.string().max(2000).nullable().optional(),
    });
    const body = schema.parse(req.body);
    const { rows } = await pool.query(
      `INSERT INTO nursery_verifications (user_id, business_name, province, notes)
       VALUES ($1,$2,$3,$4)
       ON CONFLICT (user_id) DO UPDATE SET business_name = EXCLUDED.business_name,
         province = EXCLUDED.province, notes = EXCLUDED.notes, status = 'pending',
         reviewed_by = NULL, reviewed_at = NULL
       RETURNING *`,
      [req.user!.id, body.business_name.trim(), body.province ?? null, body.notes ?? null],
    );
    res.status(201).json({ verification: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

v2Router.get('/nurseries/mine', authRequired, async (req, res, next) => {
  try {
    const { rows } = await pool.query(`SELECT * FROM nursery_verifications WHERE user_id = $1`, [req.user!.id]);
    res.json({ verification: rows[0] ?? null });
  } catch (err) {
    next(err);
  }
});

v2Router.get('/admin/nurseries', authRequired, requireRole('admin'), async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT n.*, u.display_name, u.email FROM nursery_verifications n
       JOIN users u ON u.id = n.user_id WHERE n.status = 'pending' ORDER BY n.created_at`);
    res.json({ pending: rows });
  } catch (err) {
    next(err);
  }
});

v2Router.post('/admin/nurseries/:id/:decision', authRequired, requireRole('admin'), async (req, res, next) => {
  try {
    if (!['approve', 'reject'].includes(req.params.decision)) {
      res.status(400).json({ error: 'Decision must be approve or reject' });
      return;
    }
    const status = req.params.decision === 'approve' ? 'verified' : 'rejected';
    const { rows } = await pool.query(
      `UPDATE nursery_verifications SET status = $1, reviewed_by = $2, reviewed_at = now()
       WHERE id = $3 RETURNING *`,
      [status, req.user!.id, req.params.id],
    );
    if (!rows[0]) {
      res.status(404).json({ error: 'Verification request not found' });
      return;
    }
    await moderate(req.user!.id, 'nursery_verification', rows[0].id, status);
    await notify(rows[0].user_id, 'nursery.verified', status === 'verified' ? 'Nursery verified ✓' : 'Nursery verification update',
      status === 'verified' ? 'Your nursery is now a Verified Seller.' : 'Your nursery verification was not approved.',
      'nursery_verification', rows[0].id);
    await sendPush(rows[0].user_id, 'Nursery verification update',
      status === 'verified' ? 'Your nursery is now a Verified Seller.' : 'Your verification was reviewed.').catch(() => null);
    res.json({ verification: rows[0] });
  } catch (err) {
    next(err);
  }
});

// V2: reputation + badges.
v2Router.get('/users/me/reputation', authRequired, async (req, res, next) => {
  try {
    await awardBadges(req.user!.id);
    res.json(await reputationFor(req.user!.id));
  } catch (err) {
    next(err);
  }
});

// V2: availability alerts — "notify me when seedlings appear".
v2Router.post('/alerts', authRequired, async (req, res, next) => {
  try {
    const schema = z.object({ species_id: z.string().uuid(), province: z.string().max(120).optional().default('') });
    const body = schema.parse(req.body);
    const sp = (await pool.query(`SELECT id FROM species WHERE id = $1 AND deleted_at IS NULL`, [body.species_id])).rows[0];
    if (!sp) {
      res.status(404).json({ error: 'Species not found' });
      return;
    }
    const { rows } = await pool.query(
      `INSERT INTO availability_alerts (user_id, species_id, province) VALUES ($1,$2,$3)
       ON CONFLICT DO NOTHING RETURNING *`,
      [req.user!.id, body.species_id, body.province.trim()],
    );
    res.status(201).json({ alert: rows[0] ?? null });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

v2Router.get('/alerts/mine', authRequired, async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT a.*, s.scientific_name FROM availability_alerts a
       JOIN species s ON s.id = a.species_id WHERE a.user_id = $1 ORDER BY a.created_at DESC`,
      [req.user!.id],
    );
    res.json({ alerts: rows });
  } catch (err) {
    next(err);
  }
});

v2Router.delete('/alerts/:id', authRequired, async (req, res, next) => {
  try {
    await pool.query(`DELETE FROM availability_alerts WHERE id = $1 AND user_id = $2`, [req.params.id, req.user!.id]);
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

// V2: device tokens for push.
v2Router.post('/devices', authRequired, async (req, res, next) => {
  try {
    const schema = z.object({
      platform: z.enum(['web', 'android', 'ios']).default('web'),
      token: z.string().min(10).max(512),
    });
    const body = schema.parse(req.body);
    await pool.query(
      `INSERT INTO device_tokens (user_id, platform, token) VALUES ($1,$2,$3)
       ON CONFLICT (token) DO UPDATE SET user_id = EXCLUDED.user_id, platform = EXCLUDED.platform`,
      [req.user!.id, body.platform, body.token],
    );
    res.status(201).json({ ok: true });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

export { awardBadges };
