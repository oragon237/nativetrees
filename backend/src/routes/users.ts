import { Router } from 'express';
import { z } from 'zod';
import { pool } from '../db/pool';
import { authRequired } from '../middleware/auth';

export const usersRouter = Router();

usersRouter.use(authRequired);

// GET /api/v1/users/me/stats — contribution statistics for My Trees / profile.
usersRouter.get('/me/stats', async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT
        (SELECT count(*)::int FROM observations WHERE user_id = $1 AND deleted_at IS NULL) AS observations,
        (SELECT count(*)::int FROM identification_requests WHERE user_id = $1 AND deleted_at IS NULL) AS identification_requests,
        (SELECT count(*)::int FROM marketplace_listings WHERE seller_id = $1 AND deleted_at IS NULL) AS listings,
        (SELECT count(*)::int FROM favorites WHERE user_id = $1) AS saved_trees`,
      [req.user!.id],
    );
    res.json({ stats: rows[0] });
  } catch (err) {
    next(err);
  }
});

const updateSchema = z.object({
  display_name: z.string().min(2).max(120).optional(),
  bio: z.string().max(2000).nullable().optional(),
  region: z.string().max(120).nullable().optional(),
  province: z.string().max(120).nullable().optional(),
  municipality: z.string().max(120).nullable().optional(),
});

// PATCH /api/v1/users/me
usersRouter.patch('/me', async (req, res, next) => {
  try {
    const body = updateSchema.parse(req.body);
    const fields: string[] = [];
    const values: unknown[] = [];
    let i = 1;
    for (const [k, v] of Object.entries(body)) {
      if (v !== undefined) {
        fields.push(`${k} = $${i++}`);
        values.push(typeof v === 'string' ? v.trim() : v);
      }
    }
    if (fields.length === 0) {
      res.status(400).json({ error: 'No fields to update' });
      return;
    }
    values.push(req.user!.id);
    const { rows } = await pool.query(
      `UPDATE users SET ${fields.join(', ')} WHERE id = $${i} AND deleted_at IS NULL RETURNING *`,
      values,
    );
    if (!rows[0]) {
      res.status(404).json({ error: 'User not found' });
      return;
    }
    const u = rows[0];
    res.json({
      user: {
        id: u.id,
        email: u.email,
        display_name: u.display_name,
        bio: u.bio,
        region: u.region,
        province: u.province,
        municipality: u.municipality,
      },
    });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});
