import { Router } from 'express';
import { z } from 'zod';
import { pool } from '../db/pool';
import { authRequired } from '../middleware/auth';

/** User library — saved/favorite trees. All routes require auth. */

export const favoritesRouter = Router();
favoritesRouter.use(authRequired);

// GET /api/v1/favorites — saved trees as cards (verified species only)
favoritesRouter.get('/', async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT s.id, s.scientific_name, s.growth_form, s.native_status,
        (SELECT n.name FROM species_names n WHERE n.species_id = s.id
          AND n.is_primary AND n.name_type = 'common' LIMIT 1) AS primary_name,
        (SELECT p.file_url FROM species_photos p WHERE p.species_id = s.id
          AND p.verification_status = 'verified' ORDER BY p.created_at LIMIT 1) AS primary_photo,
        f.created_at AS saved_at
       FROM favorites f JOIN species s ON s.id = f.species_id
       WHERE f.user_id = $1 AND s.verification_status = 'verified' AND s.deleted_at IS NULL
       ORDER BY f.created_at DESC`,
      [req.user!.id],
    );
    res.json({ favorites: rows });
  } catch (err) {
    next(err);
  }
});

// POST /api/v1/favorites { species_id }
favoritesRouter.post('/', async (req, res, next) => {
  try {
    const schema = z.object({ species_id: z.string().uuid() });
    const { species_id } = schema.parse(req.body);
    const species = (
      await pool.query(
        `SELECT id FROM species WHERE id = $1 AND verification_status = 'verified' AND deleted_at IS NULL`,
        [species_id],
      )
    ).rows[0];
    if (!species) {
      res.status(404).json({ error: 'Species not found' });
      return;
    }
    await pool.query(
      `INSERT INTO favorites (user_id, species_id) VALUES ($1, $2) ON CONFLICT DO NOTHING`,
      [req.user!.id, species_id],
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

// DELETE /api/v1/favorites/:speciesId
favoritesRouter.delete('/:speciesId', async (req, res, next) => {
  try {
    await pool.query(`DELETE FROM favorites WHERE user_id = $1 AND species_id = $2`, [
      req.user!.id,
      req.params.speciesId,
    ]);
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});
