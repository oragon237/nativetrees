import { Router } from 'express';
import { z } from 'zod';
import { pool } from '../db/pool';
import { authRequired } from '../middleware/auth';
import { requireRole, writeAudit } from '../middleware/requireRole';
import { moderate, notify } from '../utils/moderation';
import { awardBadges } from '../utils/reputation';

export const communityRouter = Router();
// NOTE: auth is applied per-route (not router-wide) so unauthenticated
// requests to other /api/v1/* routers fall through instead of 401ing here.

// ---------- comments ----------
const commentSchema = z.object({
  entity_type: z.enum(['identification_request', 'observation']),
  entity_id: z.string().uuid(),
  content: z.string().min(1).max(3000),
  parent_id: z.string().uuid().nullable().optional(),
});

// GET /api/v1/comments?entity_type=&entity_id=
communityRouter.get('/comments', authRequired, async (req, res, next) => {
  try {
    const q = z.object({ entity_type: z.enum(['identification_request', 'observation']), entity_id: z.string().uuid() }).parse(req.query);
    const { rows } = await pool.query(
      `SELECT c.*, u.display_name FROM comments c JOIN users u ON u.id = c.user_id
       WHERE c.entity_type = $1 AND c.entity_id = $2 AND c.status = 'visible' ORDER BY c.created_at`,
      [q.entity_type, q.entity_id],
    );
    res.json({ comments: rows });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// POST /api/v1/comments
communityRouter.post('/comments', authRequired, async (req, res, next) => {
  try {
    const body = commentSchema.parse(req.body);
    const table = body.entity_type === 'identification_request' ? 'identification_requests' : 'observations';
    const target = (await pool.query(`SELECT user_id FROM ${table} WHERE id = $1`, [body.entity_id])).rows[0];
    if (!target) {
      res.status(404).json({ error: 'Target not found' });
      return;
    }
    const { rows } = await pool.query(
      `INSERT INTO comments (user_id, entity_type, entity_id, parent_id, content)
       VALUES ($1,$2,$3,$4,$5) RETURNING *`,
      [req.user!.id, body.entity_type, body.entity_id, body.parent_id ?? null, body.content.trim()],
    );
    if (target.user_id !== req.user!.id) {
      await notify(target.user_id, 'comment.received', 'New comment 💬',
        'Someone commented on your post.', body.entity_type, body.entity_id);
    }
    res.status(201).json({ comment: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// POST /api/v1/comments/:id/hide (moderator+)
communityRouter.post('/comments/:id/hide', authRequired, requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const { rowCount } = await pool.query(`UPDATE comments SET status = 'hidden' WHERE id = $1`, [req.params.id]);
    if (!rowCount) {
      res.status(404).json({ error: 'Comment not found' });
      return;
    }
    await moderate(req.user!.id, 'comment', req.params.id, 'hidden');
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

// ---------- corrections ----------
const EDITABLE_FIELDS = [
  'description', 'leaf_description', 'bark_description', 'flower_description',
  'fruit_description', 'seed_description', 'family',
];

const correctionSchema = z.object({
  species_id: z.string().uuid(),
  field_name: z.string().min(1).max(100),
  current_value: z.string().max(20000).nullable().optional(),
  proposed_value: z.string().min(1).max(20000),
  explanation: z.string().min(1).max(5000),
  source_url: z.string().url().max(2000).nullable().optional(),
});

// POST /api/v1/corrections
communityRouter.post('/corrections', authRequired, async (req, res, next) => {
  try {
    const body = correctionSchema.parse(req.body);
    if (!EDITABLE_FIELDS.includes(body.field_name)) {
      res.status(400).json({ error: `Field must be one of: ${EDITABLE_FIELDS.join(', ')}` });
      return;
    }
    const sp = (await pool.query(`SELECT id FROM species WHERE id = $1 AND deleted_at IS NULL`, [body.species_id])).rows[0];
    if (!sp) {
      res.status(404).json({ error: 'Species not found' });
      return;
    }
    const { rows } = await pool.query(
      `INSERT INTO correction_requests (species_id, submitted_by, field_name, current_value, proposed_value, explanation, source_url)
       VALUES ($1,$2,$3,$4,$5,$6,$7) RETURNING *`,
      [body.species_id, req.user!.id, body.field_name, body.current_value ?? null,
        body.proposed_value, body.explanation, body.source_url ?? null],
    );
    res.status(201).json({ correction: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// GET /api/v1/corrections/mine + GET /api/v1/corrections/pending (mod+)
communityRouter.get('/corrections/mine', authRequired, async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT * FROM correction_requests WHERE submitted_by = $1 ORDER BY created_at DESC`, [req.user!.id]);
    res.json({ corrections: rows });
  } catch (err) {
    next(err);
  }
});

communityRouter.get('/corrections/pending', authRequired, requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT c.*, s.scientific_name FROM correction_requests c JOIN species s ON s.id = c.species_id
       WHERE c.status = 'pending' ORDER BY c.created_at`);
    res.json({ corrections: rows });
  } catch (err) {
    next(err);
  }
});

// POST /api/v1/corrections/:id/approve (admin: applies + audits + notifies)
communityRouter.post('/corrections/:id/approve', authRequired, requireRole('admin'), async (req, res, next) => {
  try {
    const c = (await pool.query(`SELECT * FROM correction_requests WHERE id = $1`, [req.params.id])).rows[0];
    if (!c || c.status !== 'pending') {
      res.status(404).json({ error: 'Pending correction not found' });
      return;
    }
    if (!EDITABLE_FIELDS.includes(c.field_name)) {
      res.status(400).json({ error: 'Field no longer editable' });
      return;
    }
    const before = (await pool.query(`SELECT * FROM species WHERE id = $1`, [c.species_id])).rows[0];
    await pool.query(`UPDATE species SET ${c.field_name} = $1 WHERE id = $2`, [c.proposed_value, c.species_id]);
    await pool.query(`UPDATE correction_requests SET status = 'approved', reviewed_by = $1, reviewed_at = now() WHERE id = $2`,
      [req.user!.id, c.id]);
    await writeAudit(pool.query.bind(pool), {
      userId: req.user!.id, action: 'species.correction.applied', entityType: 'species', entityId: c.species_id,
      oldValues: { [c.field_name]: before?.[c.field_name] }, newValues: { [c.field_name]: c.proposed_value }, ip: req.ip,
    });
    await moderate(req.user!.id, 'correction_request', c.id, 'approved');
    await notify(c.submitted_by, 'correction.approved', 'Correction approved ✓',
      `Your suggested correction for ${c.field_name} was applied.`, 'species', c.species_id);
    await awardBadges(c.submitted_by);
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

// POST /api/v1/corrections/:id/reject (mod+)
communityRouter.post('/corrections/:id/reject', authRequired, requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const schema = z.object({ reason: z.string().max(2000).optional() });
    const body = schema.parse(req.body);
    const c = (await pool.query(`SELECT * FROM correction_requests WHERE id = $1 AND status = 'pending'`, [req.params.id])).rows[0];
    if (!c) {
      res.status(404).json({ error: 'Pending correction not found' });
      return;
    }
    await pool.query(`UPDATE correction_requests SET status = 'rejected', reviewed_by = $1, reviewed_at = now() WHERE id = $2`,
      [req.user!.id, c.id]);
    await moderate(req.user!.id, 'correction_request', c.id, 'rejected', body.reason);
    res.json({ ok: true });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});
