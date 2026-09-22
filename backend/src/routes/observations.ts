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
  species_id: z.string().uuid().nullable().optional(),
  observation_date: z.string().date().optional(),
  region: z.string().max(120).nullable().optional(),
  province: z.string().max(120).nullable().optional(),
  municipality: z.string().max(120).nullable().optional(),
  latitude: z.number().min(-90).max(90).nullable().optional(),
  longitude: z.number().min(-180).max(180).nullable().optional(),
  location_precision: precision,
  habitat: z.string().max(255).nullable().optional(),
  estimated_height_m: z.number().positive().max(200).nullable().optional(),
  flowering: z.boolean().nullable().optional(),
  fruiting: z.boolean().nullable().optional(),
  notes: z.string().max(5000).nullable().optional(),
});

export const observationsRouter = Router();
observationsRouter.use(authRequired);

// POST /api/v1/observations
observationsRouter.post('/', async (req, res, next) => {
  try {
    const b = createSchema.parse(req.body);
    if (b.species_id) {
      const sp = (await pool.query(`SELECT id FROM species WHERE id = $1 AND deleted_at IS NULL`, [b.species_id])).rows[0];
      if (!sp) {
        res.status(404).json({ error: 'Species not found' });
        return;
      }
    }
    const { rows } = await pool.query(
      `INSERT INTO observations (user_id, species_id, observation_date, region, province, municipality,
        latitude, longitude, location_precision, habitat, estimated_height_m, flowering, fruiting, notes)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14) RETURNING *`,
      [req.user!.id, b.species_id ?? null, b.observation_date ?? new Date().toISOString().slice(0, 10),
        b.region ?? null, b.province ?? null, b.municipality ?? null, b.latitude ?? null, b.longitude ?? null,
        b.location_precision, b.habitat ?? null, b.estimated_height_m ?? null, b.flowering ?? null,
        b.fruiting ?? null, b.notes ?? null],
    );
    res.status(201).json({ observation: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// POST /api/v1/observations/:id/photos
observationsRouter.post('/:id/photos', upload.single('photo'), async (req, res, next) => {
  try {
    const obs = (await pool.query(`SELECT * FROM observations WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!obs) {
      res.status(404).json({ error: 'Observation not found' });
      return;
    }
    const isMod = req.user!.roles.includes('moderator') || req.user!.roles.includes('admin');
    if (obs.user_id !== req.user!.id && !isMod) {
      res.status(403).json({ error: 'Not your observation' });
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
    const stored = await saveBuffer(req.file.buffer, {
      prefix: `observations/${obs.id}`,
      filename: req.file.originalname || 'photo.jpg',
    });
    const { rows } = await pool.query(
      `INSERT INTO observation_photos (observation_id, file_url, photo_type) VALUES ($1,$2,$3) RETURNING *`,
      [obs.id, stored.url, body.photo_type],
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

// GET /api/v1/observations/mine
observationsRouter.get('/mine', async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT o.*, (SELECT count(*)::int FROM observation_photos p WHERE p.observation_id = o.id) AS photo_count
       FROM observations o WHERE o.user_id = $1 AND o.deleted_at IS NULL ORDER BY o.created_at DESC`,
      [req.user!.id],
    );
    res.json({ observations: rows });
  } catch (err) {
    next(err);
  }
});

// GET /api/v1/observations (public: approved + own)
observationsRouter.get('/', async (req, res, next) => {
  try {
    const species = req.query.species_id as string | undefined;
    const province = req.query.province as string | undefined;
    const limit = Math.min(parseInt((req.query.limit as string) ?? '20', 10) || 20, 100);
    const offset = parseInt((req.query.offset as string) ?? '0', 10) || 0;
    const conds = [`o.deleted_at IS NULL`, `(o.status = 'approved' OR o.user_id = $1)`];
    const values: unknown[] = [req.user!.id];
    if (species) {
      values.push(species);
      conds.push(`o.species_id = $${values.length}`);
    }
    if (province) {
      values.push(province);
      conds.push(`o.province ILIKE $${values.length}`);
    }
    values.push(limit, offset);
    const { rows } = await pool.query(
      `SELECT o.*, (SELECT n.name FROM species_names n WHERE n.species_id = o.species_id
          AND n.is_primary AND n.name_type = 'common' LIMIT 1) AS species_name
       FROM observations o WHERE ${conds.join(' AND ')}
       ORDER BY o.created_at DESC LIMIT $${values.length - 1} OFFSET $${values.length}`,
      values,
    );
    res.json({ observations: rows.map((r) => sanitizeLocation(r, req.user ?? null, r.user_id)) });
  } catch (err) {
    next(err);
  }
});

// GET /api/v1/observations/:id
observationsRouter.get('/:id', async (req, res, next) => {
  try {
    const obs = (await pool.query(`SELECT * FROM observations WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!obs) {
      res.status(404).json({ error: 'Observation not found' });
      return;
    }
    const isMod = req.user!.roles.includes('moderator') || req.user!.roles.includes('admin');
    if (obs.status !== 'approved' && obs.user_id !== req.user!.id && !isMod) {
      res.status(404).json({ error: 'Observation not found' });
      return;
    }
    const photos = (await pool.query(`SELECT * FROM observation_photos WHERE observation_id = $1 ORDER BY created_at`, [obs.id])).rows;
    res.json({ observation: sanitizeLocation(obs, req.user ?? null, obs.user_id), photos });
  } catch (err) {
    next(err);
  }
});

// PATCH /api/v1/observations/:id (owner, while not approved/rejected)
observationsRouter.patch('/:id', async (req, res, next) => {
  try {
    const obs = (await pool.query(`SELECT * FROM observations WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!obs || obs.user_id !== req.user!.id) {
      res.status(404).json({ error: 'Observation not found' });
      return;
    }
    if (['approved', 'rejected'].includes(obs.status)) {
      res.status(400).json({ error: `Cannot edit a ${obs.status} observation` });
      return;
    }
    const body = createSchema.partial().parse(req.body);
    const sets: string[] = [];
    const values: unknown[] = [];
    for (const [k, v] of Object.entries(body)) {
      if (v !== undefined) {
        values.push(v);
        sets.push(`${k} = $${values.length}`);
      }
    }
    if (!sets.length) {
      res.status(400).json({ error: 'No fields to update' });
      return;
    }
    if (obs.status === 'needs_information') sets.push(`status = 'pending'`);
    values.push(obs.id);
    const { rows } = await pool.query(`UPDATE observations SET ${sets.join(', ')} WHERE id = $${values.length} RETURNING *`, values);
    res.json({ observation: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

async function review(id: string, modId: string, status: string, action: string, reason?: string) {
  await pool.query(`UPDATE observations SET status = $1, reviewed_by = $2, reviewed_at = now() WHERE id = $3`, [status, modId, id]);
  await moderate(modId, 'observation', id, action, reason);
  const obs = (await pool.query(`SELECT user_id FROM observations WHERE id = $1`, [id])).rows[0];
  const titles: Record<string, string> = {
    approved: 'Observation approved 🌳',
    needs_information: 'More information requested',
    rejected: 'Observation not approved',
  };
  if (obs && titles[status]) {
    await notify(obs.user_id, `observation.${status}`, titles[status],
      reason ?? `Your tree observation is now: ${status}.`, 'observation', id);
    if (status === 'approved') await awardBadges(obs.user_id);
  }
}

// Moderator review actions
for (const [path, status, action] of [
  ['approve', 'approved', 'approved'],
  ['request-info', 'needs_information', 'requested_information'],
  ['reject', 'rejected', 'rejected'],
] as const) {
  observationsRouter.post(`/:id/${path}`, requireRole('moderator', 'admin'), async (req, res, next) => {
    try {
      const schema = z.object({ reason: z.string().max(2000).optional() });
      const body = schema.parse(req.body);
      const obs = (await pool.query(`SELECT id FROM observations WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
      if (!obs) {
        res.status(404).json({ error: 'Observation not found' });
        return;
      }
      await review(req.params.id, req.user!.id, status, action, body.reason);
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
