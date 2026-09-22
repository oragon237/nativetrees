import { Router } from 'express';
import { z } from 'zod';
import multer from 'multer';
import { pool } from '../db/pool';
import { authRequired } from '../middleware/auth';
import { requireRole } from '../middleware/requireRole';
import { saveBuffer } from '../utils/storage';
import { moderate, notify, sanitizeLocation } from '../utils/moderation';
import { awardBadges } from '../utils/reputation';

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 8 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => (file.mimetype.startsWith('image/') ? cb(null, true) : cb(new Error('Only images'))),
});

const precision = z.enum(['hidden', 'municipality', 'approximate', 'exact_private']).default('municipality');

const createSchema = z.object({
  description: z.string().max(5000).nullable().optional(),
  habitat: z.string().max(255).nullable().optional(),
  region: z.string().max(120).nullable().optional(),
  province: z.string().max(120).nullable().optional(),
  municipality: z.string().max(120).nullable().optional(),
  latitude: z.number().min(-90).max(90).nullable().optional(),
  longitude: z.number().min(-180).max(180).nullable().optional(),
  location_precision: precision,
  estimated_height_m: z.number().positive().max(200).nullable().optional(),
  flowering: z.boolean().nullable().optional(),
  fruiting: z.boolean().nullable().optional(),
});

export const identificationsRouter = Router();
identificationsRouter.use(authRequired);

// POST /api/v1/identifications
identificationsRouter.post('/', async (req, res, next) => {
  try {
    const b = createSchema.parse(req.body);
    const { rows } = await pool.query(
      `INSERT INTO identification_requests (user_id, description, habitat, region, province, municipality,
        latitude, longitude, location_precision, estimated_height_m, flowering, fruiting)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12) RETURNING *`,
      [req.user!.id, b.description ?? null, b.habitat ?? null, b.region ?? null, b.province ?? null,
        b.municipality ?? null, b.latitude ?? null, b.longitude ?? null, b.location_precision,
        b.estimated_height_m ?? null, b.flowering ?? null, b.fruiting ?? null],
    );
    res.status(201).json({ request: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// POST /api/v1/identifications/:id/photos
identificationsRouter.post('/:id/photos', upload.single('photo'), async (req, res, next) => {
  try {
    const r = (await pool.query(`SELECT * FROM identification_requests WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!r) {
      res.status(404).json({ error: 'Request not found' });
      return;
    }
    const isMod = req.user!.roles.includes('moderator') || req.user!.roles.includes('admin');
    if (r.user_id !== req.user!.id && !isMod) {
      res.status(403).json({ error: 'Not your request' });
      return;
    }
    const schema = z.object({
      photo_type: z.enum(['whole_tree', 'leaf', 'bark', 'flower', 'fruit', 'seed', 'seedling']).default('whole_tree'),
    });
    const body = schema.parse(req.body);
    if (!req.file) {
      res.status(400).json({ error: 'Missing image file field "photo"' });
      return;
    }
    const stored = await saveBuffer(req.file.buffer, { prefix: `identifications/${r.id}`, filename: req.file.originalname || 'photo.jpg' });
    const { rows } = await pool.query(
      `INSERT INTO identification_photos (request_id, file_url, photo_type) VALUES ($1,$2,$3) RETURNING *`,
      [r.id, stored.url, body.photo_type],
    );
    res.status(201).json({ photo: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// GET /api/v1/identifications/mine + GET / (community queue)
identificationsRouter.get('/mine', async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT * FROM identification_requests WHERE user_id = $1 AND deleted_at IS NULL ORDER BY created_at DESC`,
      [req.user!.id],
    );
    res.json({ requests: rows.map((r) => sanitizeLocation(r, req.user ?? null, r.user_id)) });
  } catch (err) {
    next(err);
  }
});

identificationsRouter.get('/', async (req, res, next) => {
  try {
    const status = req.query.status as string | undefined;
    const limit = Math.min(parseInt((req.query.limit as string) ?? '20', 10) || 20, 100);
    const offset = parseInt((req.query.offset as string) ?? '0', 10) || 0;
    const conds = ['deleted_at IS NULL'];
    const values: unknown[] = [];
    if (status && ['open', 'possible_identification', 'moderator_review', 'verified', 'unresolved'].includes(status)) {
      values.push(status);
      conds.push(`status = $${values.length}`);
    }
    values.push(limit, offset);
    const { rows } = await pool.query(
      `SELECT r.*, (SELECT count(*)::int FROM identification_photos p WHERE p.request_id = r.id) AS photo_count,
        (SELECT count(*)::int FROM identification_suggestions s WHERE s.request_id = r.id) AS suggestion_count
       FROM identification_requests r WHERE ${conds.join(' AND ')}
       ORDER BY r.created_at DESC LIMIT $${values.length - 1} OFFSET $${values.length}`,
      values,
    );
    res.json({ requests: rows.map((r) => sanitizeLocation(r, req.user ?? null, r.user_id)) });
  } catch (err) {
    next(err);
  }
});

// GET /api/v1/identifications/:id (photos + suggestions + verified species)
identificationsRouter.get('/:id', async (req, res, next) => {
  try {
    const r = (await pool.query(`SELECT * FROM identification_requests WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!r) {
      res.status(404).json({ error: 'Request not found' });
      return;
    }
    const [photos, suggestions] = await Promise.all([
      pool.query(`SELECT * FROM identification_photos WHERE request_id = $1 ORDER BY created_at`, [r.id]),
      pool.query(
        `SELECT s.*, u.display_name AS suggested_by_name,
          (SELECT n.name FROM species_names n WHERE n.species_id = s.species_id AND n.is_primary AND n.name_type = 'common' LIMIT 1) AS species_name,
          sp.scientific_name
         FROM identification_suggestions s JOIN users u ON u.id = s.suggested_by
         JOIN species sp ON sp.id = s.species_id WHERE s.request_id = $1 ORDER BY s.created_at`,
        [r.id],
      ),
    ]);
    let verifiedSpecies = null;
    if (r.verified_species_id) {
      verifiedSpecies = (await pool.query(`SELECT id, scientific_name FROM species WHERE id = $1`, [r.verified_species_id])).rows[0] ?? null;
    }
    res.json({
      request: sanitizeLocation(r, req.user ?? null, r.user_id),
      photos: photos.rows,
      suggestions: suggestions.rows,
      verifiedSpecies,
    });
  } catch (err) {
    next(err);
  }
});

// POST /api/v1/identifications/:id/suggestions
identificationsRouter.post('/:id/suggestions', async (req, res, next) => {
  try {
    const schema = z.object({ species_id: z.string().uuid(), reasoning: z.string().max(2000).nullable().optional() });
    const body = schema.parse(req.body);
    const r = (await pool.query(`SELECT * FROM identification_requests WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!r) {
      res.status(404).json({ error: 'Request not found' });
      return;
    }
    if (['verified', 'unresolved'].includes(r.status)) {
      res.status(400).json({ error: `Request is already ${r.status}` });
      return;
    }
    const sp = (await pool.query(`SELECT id FROM species WHERE id = $1 AND verification_status = 'verified' AND deleted_at IS NULL`, [body.species_id])).rows[0];
    if (!sp) {
      res.status(404).json({ error: 'Species not found' });
      return;
    }
    const { rows } = await pool.query(
      `INSERT INTO identification_suggestions (request_id, suggested_by, species_id, reasoning)
       VALUES ($1,$2,$3,$4) RETURNING *`,
      [r.id, req.user!.id, body.species_id, body.reasoning ?? null],
    );
    if (r.status === 'open') {
      await pool.query(`UPDATE identification_requests SET status = 'possible_identification' WHERE id = $1`, [r.id]);
    }
    if (r.user_id !== req.user!.id) {
      await notify(r.user_id, 'identification.suggested',
        'Someone suggested an identification 🌳',
        'A community member suggested a species for your identification request.',
        'identification_request', r.id);
    }
    await awardBadges(req.user!.id);
    res.status(201).json({ suggestion: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// Moderator: verify / unresolved / review
identificationsRouter.post('/:id/verify', requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const schema = z.object({ species_id: z.string().uuid(), reason: z.string().max(2000).optional() });
    const body = schema.parse(req.body);
    const r = (await pool.query(`SELECT * FROM identification_requests WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!r) {
      res.status(404).json({ error: 'Request not found' });
      return;
    }
    const sp = (await pool.query(`SELECT id FROM species WHERE id = $1 AND deleted_at IS NULL`, [body.species_id])).rows[0];
    if (!sp) {
      res.status(404).json({ error: 'Species not found' });
      return;
    }
    await pool.query(
      `UPDATE identification_requests SET status = 'verified', verified_species_id = $1, verified_by = $2, verified_at = now() WHERE id = $3`,
      [body.species_id, req.user!.id, r.id],
    );
    await moderate(req.user!.id, 'identification_request', r.id, 'verified', body.reason);
    await notify(r.user_id, 'identification.verified', 'Your tree identification was verified ✓',
      'A moderator verified the identification of your tree.', 'identification_request', r.id);
    res.json({ ok: true });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

for (const [path, status] of [['unresolved', 'unresolved'], ['review', 'moderator_review']] as const) {
  identificationsRouter.post(`/:id/${path}`, requireRole('moderator', 'admin'), async (req, res, next) => {
    try {
      const schema = z.object({ reason: z.string().max(2000).optional() });
      const body = schema.parse(req.body);
      const r = (await pool.query(`SELECT * FROM identification_requests WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
      if (!r) {
        res.status(404).json({ error: 'Request not found' });
        return;
      }
      await pool.query(`UPDATE identification_requests SET status = $1 WHERE id = $2`, [status, r.id]);
      await moderate(req.user!.id, 'identification_request', r.id, status, body.reason);
      if (status === 'unresolved') {
        await notify(r.user_id, 'identification.unresolved', 'Identification unresolved',
          body.reason ?? 'There was not enough evidence for a reliable identification.',
          'identification_request', r.id);
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
}
