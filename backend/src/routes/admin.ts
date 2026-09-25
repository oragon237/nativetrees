import { Router } from 'express';
import { z } from 'zod';
import { pool } from '../db/pool';
import { authRequired } from '../middleware/auth';
import { requireRole, writeAudit } from '../middleware/requireRole';

export const adminRouter = Router();

adminRouter.use(authRequired);

// GET /api/v1/admin/review-queue — unified moderator queue (mod+).
adminRouter.get('/review-queue', requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const limit = Math.min(parseInt((req.query.limit as string) ?? '20', 10) || 20, 100);
    const [observations, identifications, listings, corrections, reports] = await Promise.all([
      pool.query(
        `SELECT o.id, o.status, o.province, o.created_at, u.display_name AS contributor
         FROM observations o JOIN users u ON u.id = o.user_id
         WHERE o.status IN ('pending','needs_information') AND o.deleted_at IS NULL
         ORDER BY o.created_at LIMIT $1`, [limit]),
      pool.query(
        `SELECT r.id, r.status, r.province, r.created_at,
          (SELECT count(*)::int FROM identification_suggestions s WHERE s.request_id = r.id) AS suggestion_count
         FROM identification_requests r
         WHERE r.status IN ('open','possible_identification','moderator_review') AND r.deleted_at IS NULL
         ORDER BY r.created_at LIMIT $1`, [limit]),
      pool.query(
        `SELECT l.id, l.title, l.material_type, l.province, l.created_at, u.display_name AS seller_name
         FROM marketplace_listings l JOIN users u ON u.id = l.seller_id
         WHERE l.status = 'pending' AND l.deleted_at IS NULL ORDER BY l.created_at LIMIT $1`, [limit]),
      pool.query(
        `SELECT c.id, c.field_name, c.created_at, s.scientific_name, u.display_name AS submitted_by
         FROM correction_requests c JOIN species s ON s.id = c.species_id JOIN users u ON u.id = c.submitted_by
         WHERE c.status = 'pending' ORDER BY c.created_at LIMIT $1`, [limit]),
      pool.query(
        `SELECT r.id, r.entity_type, r.reason, r.created_at FROM reports r
         WHERE r.status = 'open' ORDER BY r.created_at LIMIT $1`, [limit]),
    ]);
    res.json({
      observations: observations.rows,
      identifications: identifications.rows,
      listings: listings.rows,
      corrections: corrections.rows,
      reports: reports.rows,
    });
  } catch (err) {
    next(err);
  }
});

// GET /api/v1/admin/users/:id — profile + roles + contribution & moderation history.
adminRouter.get('/users/:id', requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const u = (await pool.query(
      `SELECT u.id, u.email, u.display_name, u.profile_photo_url, u.bio, u.region, u.province,
        u.municipality, u.email_verified_at, u.account_status, u.last_login_at, u.created_at,
        COALESCE(array_agg(r.name) FILTER (WHERE r.name IS NOT NULL), '{}') AS roles
       FROM users u LEFT JOIN user_roles ur ON ur.user_id = u.id LEFT JOIN roles r ON r.id = ur.role_id
       WHERE u.id = $1 AND u.deleted_at IS NULL GROUP BY u.id`,
      [req.params.id],
    )).rows[0];
    if (!u) {
      res.status(404).json({ error: 'User not found' });
      return;
    }
    const counts = (await pool.query(
      `SELECT
        (SELECT count(*)::int FROM observations WHERE user_id = $1 AND deleted_at IS NULL) AS observations,
        (SELECT count(*)::int FROM identification_requests WHERE user_id = $1 AND deleted_at IS NULL) AS identification_requests,
        (SELECT count(*)::int FROM identification_suggestions WHERE suggested_by = $1) AS identification_suggestions,
        (SELECT count(*)::int FROM marketplace_listings WHERE seller_id = $1 AND deleted_at IS NULL) AS listings,
        (SELECT count(*)::int FROM favorites WHERE user_id = $1) AS favorites,
        (SELECT count(*)::int FROM correction_requests WHERE submitted_by = $1) AS corrections`,
      [u.id],
    )).rows[0];
    const moderation = (await pool.query(
      `SELECT entity_type, action, created_at FROM moderation_actions
       WHERE moderator_id = $1 ORDER BY created_at DESC LIMIT 20`, [u.id])).rows;
    res.json({ user: u, contributions: counts, moderationHistory: moderation });
  } catch (err) {
    next(err);
  }
});
adminRouter.get('/users', requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const search = (req.query.search as string | undefined)?.trim() ?? '';
    const status = req.query.status as string | undefined;
    const limit = Math.min(parseInt((req.query.limit as string) ?? '20', 10) || 20, 100);
    const offset = parseInt((req.query.offset as string) ?? '0', 10) || 0;
    const conditions: string[] = ['u.deleted_at IS NULL'];
    const values: unknown[] = [];
    if (search) {
      values.push(`%${search}%`);
      conditions.push(`(u.email ILIKE $${values.length} OR u.display_name ILIKE $${values.length})`);
    }
    if (status && ['active', 'suspended', 'banned'].includes(status)) {
      values.push(status);
      conditions.push(`u.account_status = $${values.length}`);
    }
    values.push(limit, offset);
    const { rows } = await pool.query(
      `SELECT u.id, u.email, u.display_name, u.province, u.account_status, u.created_at,
              COALESCE(array_agg(r.name) FILTER (WHERE r.name IS NOT NULL), '{}') AS roles
       FROM users u LEFT JOIN user_roles ur ON ur.user_id = u.id LEFT JOIN roles r ON r.id = ur.role_id
       WHERE ${conditions.join(' AND ')}
       GROUP BY u.id ORDER BY u.created_at DESC, u.id LIMIT $${values.length - 1} OFFSET $${values.length}`,
      values,
    );
    res.json({ users: rows });
  } catch (err) {
    next(err);
  }
});

const statusSchema = z.object({ status: z.enum(['active', 'suspended', 'banned']) });

// PATCH /api/v1/admin/users/:id/status — admin only, audited.
adminRouter.patch('/users/:id/status', requireRole('admin'), async (req, res, next) => {
  try {
    const { status } = statusSchema.parse(req.body);
    const { rows } = await pool.query(`SELECT * FROM users WHERE id = $1 AND deleted_at IS NULL`, [
      req.params.id,
    ]);
    const target = rows[0];
    if (!target) {
      res.status(404).json({ error: 'User not found' });
      return;
    }
    if (target.id === req.user!.id && status !== 'active') {
      res.status(400).json({ error: 'You cannot suspend your own admin account' });
      return;
    }
    await pool.query(`UPDATE users SET account_status = $1 WHERE id = $2`, [status, target.id]);
    await writeAudit(pool.query.bind(pool), {
      userId: req.user!.id,
      action: `user.status -> ${status}`,
      entityType: 'user',
      entityId: target.id,
      oldValues: { account_status: target.account_status },
      newValues: { account_status: status },
      ip: req.ip,
    });
    res.json({ ok: true });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

const roleSchema = z.object({ role: z.enum(['user', 'moderator', 'admin']) });

// POST /api/v1/admin/users/:id/roles — admin only, audited.
adminRouter.post('/users/:id/roles', requireRole('admin'), async (req, res, next) => {
  try {
    const { role } = roleSchema.parse(req.body);
    const target = (
      await pool.query(`SELECT id FROM users WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])
    ).rows[0];
    if (!target) {
      res.status(404).json({ error: 'User not found' });
      return;
    }
    await pool.query(
      `INSERT INTO user_roles (user_id, role_id, assigned_by)
       SELECT $1, id, $2 FROM roles WHERE name = $3 ON CONFLICT DO NOTHING`,
      [req.params.id, req.user!.id, role],
    );
    await writeAudit(pool.query.bind(pool), {
      userId: req.user!.id,
      action: `role.grant ${role}`,
      entityType: 'user',
      entityId: req.params.id,
      newValues: { role },
      ip: req.ip,
    });
    res.json({ ok: true });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// DELETE /api/v1/admin/users/:id/roles/:role — admin only, audited.
adminRouter.delete('/users/:id/roles/:role', requireRole('admin'), async (req, res, next) => {
  try {
    const { role } = roleSchema.parse({ role: req.params.role });
    if (req.params.id === req.user!.id && role === 'admin') {
      res.status(400).json({ error: 'You cannot remove your own admin role' });
      return;
    }
    await pool.query(
      `DELETE FROM user_roles WHERE user_id = $1 AND role_id = (SELECT id FROM roles WHERE name = $2)`,
      [req.params.id, role],
    );
    await writeAudit(pool.query.bind(pool), {
      userId: req.user!.id,
      action: `role.revoke ${role}`,
      entityType: 'user',
      entityId: req.params.id,
      oldValues: { role },
      ip: req.ip,
    });
    res.json({ ok: true });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// GET /api/v1/admin/audit-logs — admin full, moderator read-only.
adminRouter.get('/audit-logs', requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const limit = Math.min(parseInt((req.query.limit as string) ?? '50', 10) || 50, 200);
    const offset = parseInt((req.query.offset as string) ?? '0', 10) || 0;
    const { rows } = await pool.query(
      `SELECT * FROM audit_logs ORDER BY created_at DESC, id LIMIT $1 OFFSET $2`,
      [limit, offset],
    );
    res.json({ logs: rows });
  } catch (err) {
    next(err);
  }
});
