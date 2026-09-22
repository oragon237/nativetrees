import { Router } from 'express';
import { z } from 'zod';
import multer from 'multer';
import { pool } from '../db/pool';
import { authRequired } from '../middleware/auth';
import { requireRole } from '../middleware/requireRole';
import { saveBuffer } from '../utils/storage';
import { moderate, notify, sanitizeLocation } from '../utils/moderation';

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 8 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => (file.mimetype.startsWith('image/') ? cb(null, true) : cb(new Error('Only images'))),
});

const precision = z.enum(['hidden', 'municipality', 'approximate', 'exact_private']).default('municipality');

export const v3Router = Router();

// ---------- planting tracker ----------
const plantSchema = z.object({
  species_id: z.string().uuid(),
  planted_date: z.string().date().optional(),
  region: z.string().max(120).nullable().optional(),
  province: z.string().max(120).nullable().optional(),
  municipality: z.string().max(120).nullable().optional(),
  latitude: z.number().min(-90).max(90).nullable().optional(),
  longitude: z.number().min(-180).max(180).nullable().optional(),
  location_precision: precision,
  notes: z.string().max(5000).nullable().optional(),
});

v3Router.post('/planted-trees', authRequired, async (req, res, next) => {
  try {
    const b = plantSchema.parse(req.body);
    const sp = (await pool.query(`SELECT id FROM species WHERE id = $1 AND deleted_at IS NULL`, [b.species_id])).rows[0];
    if (!sp) {
      res.status(404).json({ error: 'Species not found' });
      return;
    }
    const { rows } = await pool.query(
      `INSERT INTO planted_trees (user_id, species_id, planted_date, region, province, municipality,
        latitude, longitude, location_precision, notes)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) RETURNING *`,
      [req.user!.id, b.species_id, b.planted_date ?? new Date().toISOString().slice(0, 10),
        b.region ?? null, b.province ?? null, b.municipality ?? null, b.latitude ?? null,
        b.longitude ?? null, b.location_precision, b.notes ?? null],
    );
    res.status(201).json({ plantedTree: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

v3Router.get('/planted-trees/mine', authRequired, async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT t.*, s.scientific_name,
        (SELECT n.name FROM species_names n WHERE n.species_id = t.species_id
          AND n.is_primary AND n.name_type = 'common' LIMIT 1) AS species_name,
        (SELECT count(*)::int FROM growth_records g WHERE g.planted_tree_id = t.id) AS record_count,
        (SELECT max(g.height_m) FROM growth_records g WHERE g.planted_tree_id = t.id) AS latest_height_m
       FROM planted_trees t JOIN species s ON s.id = t.species_id
       WHERE t.user_id = $1 AND t.deleted_at IS NULL ORDER BY t.planted_date DESC`,
      [req.user!.id],
    );
    res.json({ plantedTrees: rows.map((r) => sanitizeLocation(r, req.user ?? null, r.user_id)) });
  } catch (err) {
    next(err);
  }
});

async function ownedTree(id: string, userId: string) {
  return (await pool.query(`SELECT * FROM planted_trees WHERE id = $1 AND user_id = $2 AND deleted_at IS NULL`, [id, userId])).rows[0];
}

v3Router.get('/planted-trees/:id', authRequired, async (req, res, next) => {
  try {
    const t = await ownedTree(req.params.id, req.user!.id);
    if (!t) {
      res.status(404).json({ error: 'Planted tree not found' });
      return;
    }
    const growth = (await pool.query(
      `SELECT * FROM growth_records WHERE planted_tree_id = $1 ORDER BY recorded_at`, [t.id])).rows;
    const species = (await pool.query(`SELECT id, scientific_name FROM species WHERE id = $1`, [t.species_id])).rows[0];
    res.json({ plantedTree: t, growth, species });
  } catch (err) {
    next(err);
  }
});

// Public QR landing: timeline + species, generalized location only.
v3Router.get('/planted-trees/public/:token', async (req, res, next) => {
  try {
    const t = (await pool.query(
      `SELECT t.*, s.scientific_name,
        (SELECT n.name FROM species_names n WHERE n.species_id = t.species_id
          AND n.is_primary AND n.name_type = 'common' LIMIT 1) AS species_name
       FROM planted_trees t JOIN species s ON s.id = t.species_id
       WHERE t.public_token = $1 AND t.deleted_at IS NULL`,
      [req.params.token],
    )).rows[0];
    if (!t) {
      res.status(404).json({ error: 'Not found' });
      return;
    }
    const growth = (await pool.query(
      `SELECT recorded_at, height_m, notes, file_url FROM growth_records WHERE planted_tree_id = $1 ORDER BY recorded_at`, [t.id])).rows;
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { latitude, longitude, municipality, ...rest } = sanitizeLocation(t, null, '');
    res.json({
      plantedTree: { ...rest, province: t.province, municipality: t.location_precision === 'municipality' || t.location_precision === 'approximate' ? t.municipality : null },
      growth,
    });
  } catch (err) {
    next(err);
  }
});

v3Router.post('/planted-trees/:id/growth', authRequired, upload.single('photo'), async (req, res, next) => {
  try {
    const t = await ownedTree(req.params.id, req.user!.id);
    if (!t) {
      res.status(404).json({ error: 'Planted tree not found' });
      return;
    }
    const schema = z.object({
      recorded_at: z.string().date().optional(),
      height_m: z.coerce.number().positive().max(200).nullable().optional(),
      notes: z.string().max(2000).nullable().optional(),
    });
    const body = schema.parse(req.body);
    let fileUrl: string | null = null;
    if (req.file) {
      const stored = await saveBuffer(req.file.buffer, { prefix: `growth/${t.id}`, filename: req.file.originalname || 'photo.jpg' });
      fileUrl = stored.url;
    }
    const { rows } = await pool.query(
      `INSERT INTO growth_records (planted_tree_id, recorded_at, height_m, notes, file_url)
       VALUES ($1,$2,$3,$4,$5) RETURNING *`,
      [t.id, body.recorded_at ?? new Date().toISOString().slice(0, 10), body.height_m ?? null, body.notes ?? null, fileUrl],
    );
    res.status(201).json({ record: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// ---------- community planting projects ----------
const projectSchema = z.object({
  title: z.string().min(3).max(255),
  description: z.string().max(5000).default(''),
  goal_trees: z.number().int().positive().default(100),
  region: z.string().max(120).nullable().optional(),
  province: z.string().max(120).nullable().optional(),
  start_date: z.string().date().nullable().optional(),
  end_date: z.string().date().nullable().optional(),
});

v3Router.get('/projects', async (req, res, next) => {
  try {
    const status = (req.query.status as string) || 'active';
    const { rows } = await pool.query(
      `SELECT p.*, u.display_name AS owner_name,
        (SELECT count(*)::int FROM project_participants pp WHERE pp.project_id = p.id) AS participants,
        (SELECT COALESCE(sum(pp.pledged_trees),0)::int FROM project_participants pp WHERE pp.project_id = p.id) AS pledged
       FROM projects p JOIN users u ON u.id = p.owner_id
       WHERE p.status = $1 AND p.deleted_at IS NULL ORDER BY p.created_at DESC LIMIT 50`,
      [status],
    );
    res.json({ projects: rows });
  } catch (err) {
    next(err);
  }
});

v3Router.post('/projects', authRequired, async (req, res, next) => {
  try {
    const body = projectSchema.parse(req.body);
    const { rows } = await pool.query(
      `INSERT INTO projects (owner_id, title, description, goal_trees, region, province, start_date, end_date)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8) RETURNING *`,
      [req.user!.id, body.title.trim(), body.description, body.goal_trees, body.region ?? null,
        body.province ?? null, body.start_date ?? null, body.end_date ?? null],
    );
    res.status(201).json({ project: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

v3Router.get('/projects/:id', async (req, res, next) => {
  try {
    const p = (await pool.query(
      `SELECT p.*, u.display_name AS owner_name FROM projects p JOIN users u ON u.id = p.owner_id
       WHERE p.id = $1 AND p.deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!p) {
      res.status(404).json({ error: 'Project not found' });
      return;
    }
    const parts = (await pool.query(
      `SELECT u.display_name, pp.pledged_trees FROM project_participants pp
       JOIN users u ON u.id = pp.user_id WHERE pp.project_id = $1 ORDER BY pp.created_at`, [p.id])).rows;
    res.json({ project: p, participants: parts });
  } catch (err) {
    next(err);
  }
});

v3Router.post('/projects/:id/join', authRequired, async (req, res, next) => {
  try {
    const schema = z.object({ pledged_trees: z.number().int().positive().default(1) });
    const body = schema.parse(req.body);
    const p = (await pool.query(`SELECT owner_id FROM projects WHERE id = $1 AND status = 'active' AND deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!p) {
      res.status(404).json({ error: 'Active project not found' });
      return;
    }
    await pool.query(
      `INSERT INTO project_participants (project_id, user_id, pledged_trees) VALUES ($1,$2,$3)
       ON CONFLICT (project_id, user_id) DO UPDATE SET pledged_trees = EXCLUDED.pledged_trees`,
      [req.params.id, req.user!.id, body.pledged_trees],
    );
    if (p.owner_id !== req.user!.id) {
      await notify(p.owner_id, 'project.joined', 'New project participant 🌱',
        'Someone joined your planting project.', 'project', req.params.id);
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

v3Router.patch('/projects/:id', authRequired, async (req, res, next) => {
  try {
    const schema = z.object({
      title: z.string().min(3).max(255).optional(),
      description: z.string().max(5000).optional(),
      goal_trees: z.number().int().positive().optional(),
      status: z.enum(['draft', 'active', 'completed', 'cancelled']).optional(),
    });
    const body = schema.parse(req.body);
    const p = (await pool.query(`SELECT owner_id FROM projects WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!p) {
      res.status(404).json({ error: 'Project not found' });
      return;
    }
    const isAdmin = req.user!.roles.includes('admin');
    if (p.owner_id !== req.user!.id && !isAdmin) {
      res.status(403).json({ error: 'Not your project' });
      return;
    }
    const sets: string[] = [];
    const values: unknown[] = [];
    for (const [k, v] of Object.entries(body)) {
      if (v !== undefined) {
        values.push(typeof v === 'string' ? v.trim() : v);
        sets.push(`${k} = $${values.length}`);
      }
    }
    if (!sets.length) {
      res.status(400).json({ error: 'No fields to update' });
      return;
    }
    values.push(req.params.id);
    const { rows } = await pool.query(`UPDATE projects SET ${sets.join(', ')} WHERE id = $${values.length} RETURNING *`, values);
    res.json({ project: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// ---------- organizations ----------
const orgSchema = z.object({
  name: z.string().min(2).max(255),
  org_type: z.enum(['school', 'ngo', 'lgu', 'society', 'other']).default('other'),
  province: z.string().max(120).nullable().optional(),
  description: z.string().max(5000).default(''),
});

v3Router.post('/organizations', authRequired, async (req, res, next) => {
  try {
    const body = orgSchema.parse(req.body);
    const { rows } = await pool.query(
      `INSERT INTO organization_profiles (owner_id, name, org_type, province, description)
       VALUES ($1,$2,$3,$4,$5)
       ON CONFLICT (owner_id) DO UPDATE SET name = EXCLUDED.name, org_type = EXCLUDED.org_type,
         province = EXCLUDED.province, description = EXCLUDED.description, status = 'pending',
         reviewed_by = NULL, reviewed_at = NULL
       RETURNING *`,
      [req.user!.id, body.name.trim(), body.org_type, body.province ?? null, body.description],
    );
    res.status(201).json({ organization: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

v3Router.get('/organizations/mine', authRequired, async (req, res, next) => {
  try {
    const { rows } = await pool.query(`SELECT * FROM organization_profiles WHERE owner_id = $1`, [req.user!.id]);
    res.json({ organization: rows[0] ?? null });
  } catch (err) {
    next(err);
  }
});

v3Router.get('/organizations', async (_req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT o.*, u.display_name AS owner_name FROM organization_profiles o
       JOIN users u ON u.id = o.owner_id WHERE o.status = 'verified' ORDER BY o.created_at DESC LIMIT 50`);
    res.json({ organizations: rows });
  } catch (err) {
    next(err);
  }
});

v3Router.get('/admin/organizations', authRequired, requireRole('admin'), async (_req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT o.*, u.display_name, u.email FROM organization_profiles o
       JOIN users u ON u.id = o.owner_id WHERE o.status = 'pending' ORDER BY o.created_at`);
    res.json({ pending: rows });
  } catch (err) {
    next(err);
  }
});

v3Router.post('/admin/organizations/:id/:decision', authRequired, requireRole('admin'), async (req, res, next) => {
  try {
    if (!['approve', 'reject'].includes(req.params.decision)) {
      res.status(400).json({ error: 'Decision must be approve or reject' });
      return;
    }
    const status = req.params.decision === 'approve' ? 'verified' : 'rejected';
    const { rows } = await pool.query(
      `UPDATE organization_profiles SET status = $1, reviewed_by = $2, reviewed_at = now()
       WHERE id = $3 RETURNING *`,
      [status, req.user!.id, req.params.id],
    );
    if (!rows[0]) {
      res.status(404).json({ error: 'Organization not found' });
      return;
    }
    await moderate(req.user!.id, 'organization_profile', rows[0].id, status);
    await notify(rows[0].owner_id, 'organization.verified',
      status === 'verified' ? 'Organization verified ✓' : 'Organization review update',
      status === 'verified' ? `"${rows[0].name}" is now a verified organization.` : 'Your organization profile was reviewed.',
      'organization_profile', rows[0].id);
    res.json({ organization: rows[0] });
  } catch (err) {
    next(err);
  }
});
