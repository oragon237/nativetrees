import { Router } from 'express';
import { z } from 'zod';
import { pool } from '../db/pool';
import { authRequired } from '../middleware/auth';
import { requireRole } from '../middleware/requireRole';
import { moderate, notify } from '../utils/moderation';

/** Phase 6: reports, in-app notifications, privacy-conscious analytics. */

export const reportsRouter = Router();
reportsRouter.use(authRequired);

const reportSchema = z.object({
  entity_type: z.enum(['species', 'observation', 'identification_request', 'marketplace_listing', 'comment', 'user']),
  entity_id: z.string().uuid(),
  reason: z.enum(['incorrect_information', 'incorrect_identification', 'suspicious_listing', 'spam',
    'inappropriate_content', 'misleading_seller', 'other']),
  description: z.string().max(3000).nullable().optional(),
});

// POST /api/v1/reports
reportsRouter.post('/', async (req, res, next) => {
  try {
    const body = reportSchema.parse(req.body);
    const { rows } = await pool.query(
      `INSERT INTO reports (reporter_id, entity_type, entity_id, reason, description)
       VALUES ($1,$2,$3,$4,$5) RETURNING *`,
      [req.user!.id, body.entity_type, body.entity_id, body.reason, body.description ?? null],
    );
    res.status(201).json({ report: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// GET /api/v1/reports/mine
reportsRouter.get('/mine', async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT * FROM reports WHERE reporter_id = $1 ORDER BY created_at DESC`, [req.user!.id]);
    res.json({ reports: rows });
  } catch (err) {
    next(err);
  }
});

export const notificationsRouter = Router();
notificationsRouter.use(authRequired);

// GET /api/v1/notifications
notificationsRouter.get('/', async (req, res, next) => {
  try {
    const limit = Math.min(parseInt((req.query.limit as string) ?? '30', 10) || 30, 100);
    const { rows } = await pool.query(
      `SELECT * FROM notifications WHERE user_id = $1 ORDER BY created_at DESC LIMIT $2`, [req.user!.id, limit]);
    const unread = (await pool.query(
      `SELECT count(*)::int AS c FROM notifications WHERE user_id = $1 AND read_at IS NULL`, [req.user!.id])).rows[0].c;
    res.json({ notifications: rows, unread });
  } catch (err) {
    next(err);
  }
});

// PATCH /api/v1/notifications/:id/read
notificationsRouter.patch('/:id/read', async (req, res, next) => {
  try {
    const { rowCount } = await pool.query(
      `UPDATE notifications SET read_at = now() WHERE id = $1 AND user_id = $2 AND read_at IS NULL`,
      [req.params.id, req.user!.id]);
    if (!rowCount) {
      res.status(404).json({ error: 'Notification not found' });
      return;
    }
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

export const safetyAdminRouter = Router();
safetyAdminRouter.use(authRequired);

// GET /api/v1/admin/reports
safetyAdminRouter.get('/reports', requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const status = req.query.status as string | undefined;
    const limit = Math.min(parseInt((req.query.limit as string) ?? '30', 10) || 30, 100);
    const values: unknown[] = [];
    let where = '';
    if (status && ['open', 'in_review', 'resolved', 'dismissed'].includes(status)) {
      values.push(status);
      where = `WHERE r.status = $1`;
    }
    values.push(limit);
    const { rows } = await pool.query(
      `SELECT r.*, u.display_name AS reporter_name FROM reports r
       JOIN users u ON u.id = r.reporter_id ${where}
       ORDER BY r.created_at DESC LIMIT $${values.length}`, values);
    res.json({ reports: rows });
  } catch (err) {
    next(err);
  }
});

// POST /api/v1/admin/reports/:id/resolve
safetyAdminRouter.post('/reports/:id/resolve', requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const schema = z.object({
      status: z.enum(['in_review', 'resolved', 'dismissed']),
      resolution: z.string().max(2000).nullable().optional(),
    });
    const body = schema.parse(req.body);
    const r = (await pool.query(`SELECT * FROM reports WHERE id = $1`, [req.params.id])).rows[0];
    if (!r) {
      res.status(404).json({ error: 'Report not found' });
      return;
    }
    const terminal = body.status === 'resolved' || body.status === 'dismissed';
    await pool.query(
      `UPDATE reports SET status = $1, resolution = $2, assigned_to = $3,
        resolved_at = CASE WHEN $4 THEN now() ELSE resolved_at END
       WHERE id = $5`,
      [body.status, body.resolution ?? null, req.user!.id, terminal, r.id]);
    await moderate(req.user!.id, 'report', r.id, body.status, body.resolution);
    if (['resolved', 'dismissed'].includes(body.status)) {
      await notify(r.reporter_id, 'report.resolved', 'Your report was reviewed ✓',
        body.resolution ?? `Your report is now: ${body.status}.`, 'report', r.id);
    }
    res.json({ ok: true });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// GET /api/v1/admin/analytics — aggregate counts only, no PII.
safetyAdminRouter.get('/analytics', requireRole('admin'), async (req, res, next) => {
  try {
    const q = async (sql: string) => (await pool.query(sql)).rows;
    const [usersQ, speciesQ, obsQ, identQ, listingsQ, reportsQ, correctionsQ, modQ, favsQ] = await Promise.all([
      q(`SELECT count(*)::int AS total, count(*) FILTER (WHERE created_at > now() - interval '30 days')::int AS new_30d FROM users WHERE deleted_at IS NULL`),
      q(`SELECT verification_status AS status, count(*)::int AS n FROM species WHERE deleted_at IS NULL GROUP BY 1`),
      q(`SELECT status, count(*)::int AS n FROM observations WHERE deleted_at IS NULL GROUP BY 1`),
      q(`SELECT status, count(*)::int AS n FROM identification_requests WHERE deleted_at IS NULL GROUP BY 1`),
      q(`SELECT status, count(*)::int AS n FROM marketplace_listings WHERE deleted_at IS NULL GROUP BY 1`),
      q(`SELECT status, count(*)::int AS n FROM reports GROUP BY 1`),
      q(`SELECT count(*)::int AS pending FROM correction_requests WHERE status = 'pending'`),
      q(`SELECT count(*)::int AS total FROM moderation_actions`),
      q(`SELECT count(*)::int AS total FROM favorites`),
    ]);
    const topPurposes = await q(
      `SELECT p.name, p.slug, count(*)::int AS species_count FROM species_purposes sp
       JOIN purposes p ON p.id = sp.purpose_id GROUP BY p.name, p.slug ORDER BY 3 DESC LIMIT 10`);
    const recentModeration = (await pool.query(
      `SELECT m.action, m.entity_type, m.created_at, u.display_name AS moderator
       FROM moderation_actions m LEFT JOIN users u ON u.id = m.moderator_id
       ORDER BY m.created_at DESC LIMIT 10`)).rows;
    res.json({
      users: usersQ[0] ?? { total: 0, new_30d: 0 },
      species: speciesQ,
      observations: obsQ,
      identifications: identQ,
      listings: listingsQ,
      reports: reportsQ,
      corrections: correctionsQ[0] ?? { pending: 0 },
      moderationActions: modQ[0] ?? { total: 0 },
      favorites: favsQ[0] ?? { total: 0 },
      topPurposes, recentModeration,
    });
  } catch (err) {
    next(err);
  }
});
