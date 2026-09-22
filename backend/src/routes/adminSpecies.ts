import type { NextFunction, Request, Response } from 'express';
import { Router } from 'express';
import { z } from 'zod';
import multer from 'multer';
import { pool } from '../db/pool';
import { authRequired } from '../middleware/auth';
import { requireRole, writeAudit } from '../middleware/requireRole';
import { saveBuffer } from '../utils/storage';

/**
 * Admin Tree Knowledge Engine (species editor backend).
 * Reads: moderator+. Writes: admin (photo verify/upload: moderator+).
 * All writes create audit_logs entries for scientific-record traceability.
 */

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 8 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => {
    if (file.mimetype.startsWith('image/')) cb(null, true);
    else cb(new Error('Only image uploads are allowed'));
  },
});

const audit = (
  req: { user?: { id: string }; ip?: string },
  action: string,
  entityId: string,
  oldValues?: unknown,
  newValues?: unknown,
) =>
  writeAudit(pool.query.bind(pool), {
    userId: req.user!.id,
    action,
    entityType: 'species',
    entityId,
    oldValues,
    newValues,
    ip: req.ip,
  });

const scalarSchema = z.object({
  scientific_name: z.string().min(3).max(255),
  genus: z.string().min(2).max(120),
  species_epithet: z.string().min(2).max(120),
  family: z.string().min(2).max(120),
  native_status: z.enum(['native', 'endemic']),
  description: z.string().max(20000).default(''),
  leaf_description: z.string().max(5000).nullable().optional(),
  bark_description: z.string().max(5000).nullable().optional(),
  flower_description: z.string().max(5000).nullable().optional(),
  fruit_description: z.string().max(5000).nullable().optional(),
  seed_description: z.string().max(5000).nullable().optional(),
  growth_form: z.enum(['small', 'medium', 'large']).nullable().optional(),
  min_height_m: z.number().positive().max(200).nullable().optional(),
  max_height_m: z.number().positive().max(200).nullable().optional(),
  min_canopy_m: z.number().positive().max(200).nullable().optional(),
  max_canopy_m: z.number().positive().max(200).nullable().optional(),
  growth_rate: z.enum(['slow', 'moderate', 'fast']).nullable().optional(),
  fruit_bearing: z.boolean().default(false),
  flowering: z.boolean().default(false),
  conservation_status: z.string().max(120).nullable().optional(),
  conservation_source: z.string().max(255).nullable().optional(),
});

const nestedName = z.object({
  name: z.string().min(1).max(255),
  name_type: z.enum(['common', 'local', 'alternative']),
  language: z.string().max(60).nullable().optional(),
  locality: z.string().max(120).nullable().optional(),
  is_primary: z.boolean().default(false),
});
const nestedPurpose = z.object({
  purpose_slug: z.string().min(1),
  suitability: z.enum(['possible', 'suitable', 'highly_suitable']).default('suitable'),
  notes: z.string().max(2000).nullable().optional(),
});
const nestedCondition = z.object({
  condition_slug: z.string().min(1),
  suitability: z.enum(['possible', 'suitable', 'highly_suitable']).default('suitable'),
  notes: z.string().max(2000).nullable().optional(),
});
const nestedDistribution = z.object({
  region: z.string().max(120).nullable().optional(),
  province: z.string().max(120).nullable().optional(),
  island_group: z.enum(['Luzon', 'Visayas', 'Mindanao']).nullable().optional(),
  distribution_type: z.enum(['native', 'endemic']).default('native'),
  notes: z.string().max(2000).nullable().optional(),
});
const nestedReference = z.object({
  title: z.string().min(1),
  author: z.string().max(255).nullable().optional(),
  organization: z.string().max(255).nullable().optional(),
  publication_year: z.number().int().min(1500).max(2100).nullable().optional(),
  source_type: z.string().max(120).default('other'),
  source_url: z.string().url().max(2000).nullable().optional(),
  notes: z.string().max(5000).nullable().optional(),
});

const createSchema = scalarSchema.extend({
  names: z.array(nestedName).default([]),
  purposes: z.array(nestedPurpose).default([]),
  conditions: z.array(nestedCondition).default([]),
  distribution: z.array(nestedDistribution).default([]),
  references: z.array(nestedReference).default([]),
});

async function fullDetail(id: string) {
  const { rows } = await pool.query(`SELECT * FROM species WHERE id = $1 AND deleted_at IS NULL`, [id]);
  const species = rows[0];
  if (!species) return null;
  const [names, photos, purposes, conditions, distribution, references] = await Promise.all([
    pool.query(`SELECT * FROM species_names WHERE species_id = $1 ORDER BY is_primary DESC, name`, [id]),
    pool.query(`SELECT * FROM species_photos WHERE species_id = $1 ORDER BY created_at`, [id]),
    pool.query(
      `SELECT p.id, p.name, p.slug, sp.suitability, sp.notes FROM species_purposes sp
       JOIN purposes p ON p.id = sp.purpose_id WHERE sp.species_id = $1`,
      [id],
    ),
    pool.query(
      `SELECT c.id, c.category, c.name, c.slug, spc.suitability, spc.notes
       FROM species_planting_conditions spc JOIN planting_conditions c ON c.id = spc.condition_id
       WHERE spc.species_id = $1 ORDER BY c.category, c.name`,
      [id],
    ),
    pool.query(`SELECT * FROM species_distribution WHERE species_id = $1`, [id]),
    pool.query(`SELECT * FROM species_references WHERE species_id = $1 ORDER BY created_at`, [id]),
  ]);
  return {
    species,
    names: names.rows,
    photos: photos.rows,
    purposes: purposes.rows,
    plantingConditions: conditions.rows,
    distribution: distribution.rows,
    references: references.rows,
  };
}

export const adminSpeciesRouter = Router();
adminSpeciesRouter.use(authRequired);

// ---------- list (any status) ----------
adminSpeciesRouter.get('/species', requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const q = ((req.query.q as string) ?? '').trim();
    const status = req.query.status as string | undefined;
    const limit = Math.min(parseInt((req.query.limit as string) ?? '20', 10) || 20, 100);
    const offset = parseInt((req.query.offset as string) ?? '0', 10) || 0;
    const conds = ['s.deleted_at IS NULL'];
    const values: unknown[] = [];
    if (q) {
      values.push(`%${q}%`);
      conds.push(
        `(s.scientific_name ILIKE $${values.length}
          OR EXISTS (SELECT 1 FROM species_names n WHERE n.species_id = s.id AND n.name ILIKE $${values.length}))`,
      );
    }
    if (status && ['draft', 'verified', 'archived'].includes(status)) {
      values.push(status);
      conds.push(`s.verification_status = $${values.length}`);
    }
    values.push(limit, offset);
    const { rows } = await pool.query(
      `SELECT s.id, s.scientific_name, s.genus, s.family, s.verification_status, s.updated_at,
        (SELECT n.name FROM species_names n WHERE n.species_id = s.id
          AND n.is_primary AND n.name_type = 'common' LIMIT 1) AS primary_name
       FROM species s WHERE ${conds.join(' AND ')}
       ORDER BY s.updated_at DESC LIMIT $${values.length - 1} OFFSET $${values.length}`,
      values,
    );
    res.json({ species: rows });
  } catch (err) {
    next(err);
  }
});

// ---------- detail (any status) ----------
adminSpeciesRouter.get('/species/:id', requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const detail = await fullDetail(req.params.id);
    if (!detail) {
      res.status(404).json({ error: 'Species not found' });
      return;
    }
    res.json(detail);
  } catch (err) {
    next(err);
  }
});

// ---------- create ----------
adminSpeciesRouter.post('/species', requireRole('admin'), async (req, res, next) => {
  const client = await pool.connect();
  try {
    const body = createSchema.parse(req.body);
    const dup = await client.query(`SELECT id FROM species WHERE scientific_name = $1`, [
      body.scientific_name.trim(),
    ]);
    if (dup.rowCount) {
      res.status(409).json({ error: 'Scientific name already exists' });
      return;
    }
    await client.query('BEGIN');
    const cols = [
      'scientific_name', 'genus', 'species_epithet', 'family', 'native_status', 'description',
      'leaf_description', 'bark_description', 'flower_description', 'fruit_description',
      'seed_description', 'growth_form', 'min_height_m', 'max_height_m', 'min_canopy_m',
      'max_canopy_m', 'growth_rate', 'fruit_bearing', 'flowering', 'conservation_status',
      'conservation_source',
    ];
    const vals = cols.map((c) => (body as Record<string, unknown>)[c] ?? null);
    const placeholders = cols.map((_, i) => `$${i + 1}`).join(',');
    const { rows } = await client.query(
      `INSERT INTO species (${cols.join(',')}, created_by) VALUES (${placeholders}, $${cols.length + 1}) RETURNING *`,
      [...vals, req.user!.id],
    );
    const species = rows[0];
    for (const n of body.names) {
      await client.query(
        `INSERT INTO species_names (species_id, name, name_type, language, locality, is_primary)
         VALUES ($1,$2,$3,$4,$5,$6)`,
        [species.id, n.name.trim(), n.name_type, n.language ?? null, n.locality ?? null, n.is_primary],
      );
    }
    for (const p of body.purposes) {
      await client.query(
        `INSERT INTO species_purposes (species_id, purpose_id, suitability, notes)
         SELECT $1, id, $2, $3 FROM purposes WHERE slug = $4
         ON CONFLICT (species_id, purpose_id) DO UPDATE SET suitability = EXCLUDED.suitability, notes = EXCLUDED.notes`,
        [species.id, p.suitability, p.notes ?? null, p.purpose_slug],
      );
    }
    for (const c of body.conditions) {
      await client.query(
        `INSERT INTO species_planting_conditions (species_id, condition_id, suitability, notes)
         SELECT $1, id, $2, $3 FROM planting_conditions WHERE slug = $4
         ON CONFLICT (species_id, condition_id) DO UPDATE SET suitability = EXCLUDED.suitability, notes = EXCLUDED.notes`,
        [species.id, c.suitability, c.notes ?? null, c.condition_slug],
      );
    }
    for (const d of body.distribution) {
      await client.query(
        `INSERT INTO species_distribution (species_id, region, province, island_group, distribution_type, notes)
         VALUES ($1,$2,$3,$4,$5,$6)`,
        [species.id, d.region ?? null, d.province ?? null, d.island_group ?? null, d.distribution_type, d.notes ?? null],
      );
    }
    for (const r of body.references) {
      await client.query(
        `INSERT INTO species_references (species_id, title, author, organization, publication_year, source_type, source_url, notes)
         VALUES ($1,$2,$3,$4,$5,$6,$7,$8)`,
        [species.id, r.title, r.author ?? null, r.organization ?? null, r.publication_year ?? null, r.source_type, r.source_url ?? null, r.notes ?? null],
      );
    }
    await client.query('COMMIT');
    await audit(req, 'species.create', species.id, null, { scientific_name: species.scientific_name });
    res.status(201).json(await fullDetail(species.id));
  } catch (err) {
    await client.query('ROLLBACK');
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  } finally {
    client.release();
  }
});

// ---------- patch scalars ----------
const patchSchema = scalarSchema.partial().extend({
  verification_status: z.enum(['draft', 'verified', 'archived']).optional(),
  is_featured: z.boolean().optional(),
});

adminSpeciesRouter.patch('/species/:id', requireRole('admin'), async (req, res, next) => {
  try {
    const body = patchSchema.parse(req.body);
    const { rows } = await pool.query(`SELECT * FROM species WHERE id = $1 AND deleted_at IS NULL`, [
      req.params.id,
    ]);
    const current = rows[0];
    if (!current) {
      res.status(404).json({ error: 'Species not found' });
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
    if (body.verification_status === 'verified' && current.verification_status !== 'verified') {
      values.push(req.user!.id);
      sets.push(`verified_by = $${values.length}`, `verified_at = now()`);
    }
    if (sets.length === 0) {
      res.status(400).json({ error: 'No fields to update' });
      return;
    }
    values.push(req.params.id);
    await pool.query(`UPDATE species SET ${sets.join(', ')} WHERE id = $${values.length}`, values);
    await audit(req, 'species.update', req.params.id, { verification_status: current.verification_status }, body);
    res.json(await fullDetail(req.params.id));
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// ---------- publish / archive ----------
adminSpeciesRouter.post('/species/:id/publish', requireRole('admin'), async (req, res, next) => {
  try {
    const { rowCount } = await pool.query(
      `UPDATE species SET verification_status = 'verified', verified_by = $1, verified_at = now()
       WHERE id = $2 AND deleted_at IS NULL`,
      [req.user!.id, req.params.id],
    );
    if (!rowCount) {
      res.status(404).json({ error: 'Species not found' });
      return;
    }
    await audit(req, 'species.publish', req.params.id, null, { verification_status: 'verified' });
    res.json(await fullDetail(req.params.id));
  } catch (err) {
    next(err);
  }
});

adminSpeciesRouter.post('/species/:id/archive', requireRole('admin'), async (req, res, next) => {
  try {
    const { rowCount } = await pool.query(
      `UPDATE species SET verification_status = 'archived' WHERE id = $1 AND deleted_at IS NULL`,
      [req.params.id],
    );
    if (!rowCount) {
      res.status(404).json({ error: 'Species not found' });
      return;
    }
    await audit(req, 'species.archive', req.params.id, null, { verification_status: 'archived' });
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

// ---------- merge duplicates (admin) ----------
adminSpeciesRouter.post('/species/:id/merge', requireRole('admin'), async (req, res, next) => {
  const client = await pool.connect();
  try {
    const schema = z.object({ into_id: z.string().uuid(), reason: z.string().max(2000).optional() });
    const body = schema.parse(req.body);
    if (body.into_id === req.params.id) {
      res.status(400).json({ error: 'Cannot merge a species into itself' });
      return;
    }
    const [src, dst] = await Promise.all([
      client.query(`SELECT * FROM species WHERE id = $1 AND deleted_at IS NULL`, [req.params.id]),
      client.query(`SELECT * FROM species WHERE id = $1 AND deleted_at IS NULL`, [body.into_id]),
    ]);
    if (!src.rows[0] || !dst.rows[0]) {
      res.status(404).json({ error: 'Source or target species not found' });
      return;
    }
    const from = req.params.id;
    const into = body.into_id;
    await client.query('BEGIN');
    // Plain re-point (no uniqueness conflicts).
    for (const [table, col] of [
      ['species_names', 'species_id'], ['species_photos', 'species_id'],
      ['species_distribution', 'species_id'], ['species_references', 'species_id'],
      ['observations', 'species_id'], ['identification_suggestions', 'species_id'],
      ['marketplace_listings', 'species_id'], ['correction_requests', 'species_id'],
    ] as const) {
      await client.query(`UPDATE ${table} SET ${col} = $1 WHERE ${col} = $2`, [into, from]);
    }
    await client.query(`UPDATE identification_requests SET verified_species_id = $1 WHERE verified_species_id = $2`, [into, from]);
    // Link tables: copy missing links, then drop the source rows.
    await client.query(
      `INSERT INTO species_purposes (species_id, purpose_id, suitability, notes, reference_id)
       SELECT $1, purpose_id, suitability, notes, reference_id FROM species_purposes WHERE species_id = $2
       ON CONFLICT DO NOTHING`, [into, from]);
    await client.query(`DELETE FROM species_purposes WHERE species_id = $1`, [from]);
    await client.query(
      `INSERT INTO species_planting_conditions (species_id, condition_id, suitability, notes, reference_id)
       SELECT $1, condition_id, suitability, notes, reference_id FROM species_planting_conditions WHERE species_id = $2
       ON CONFLICT DO NOTHING`, [into, from]);
    await client.query(`DELETE FROM species_planting_conditions WHERE species_id = $1`, [from]);
    await client.query(
      `INSERT INTO favorites (user_id, species_id) SELECT user_id, $1 FROM favorites WHERE species_id = $2
       ON CONFLICT DO NOTHING`, [into, from]);
    await client.query(`DELETE FROM favorites WHERE species_id = $1`, [from]);
    await client.query(`UPDATE species SET verification_status = 'archived' WHERE id = $1`, [from]);
    await client.query('COMMIT');
    await audit(req, 'species.merge', into,
      { merged_from: from, source_name: src.rows[0].scientific_name },
      { target_name: dst.rows[0].scientific_name, reason: body.reason ?? null });
    res.json(await fullDetail(into));
  } catch (err) {
    await client.query('ROLLBACK');
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  } finally {
    client.release();
  }
});
adminSpeciesRouter.post('/species/:id/names', requireRole('admin'), async (req, res, next) => {
  try {
    const body = nestedName.parse(req.body);
    const { rows } = await pool.query(
      `INSERT INTO species_names (species_id, name, name_type, language, locality, is_primary)
       VALUES ($1,$2,$3,$4,$5,$6) RETURNING *`,
      [req.params.id, body.name.trim(), body.name_type, body.language ?? null, body.locality ?? null, body.is_primary],
    );
    await audit(req, 'species.name.add', req.params.id, null, body);
    res.status(201).json({ name: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

adminSpeciesRouter.delete('/species/:id/names/:nameId', requireRole('admin'), async (req, res, next) => {
  try {
    const { rows } = await pool.query(`SELECT * FROM species_names WHERE id = $1 AND species_id = $2`, [
      req.params.nameId,
      req.params.id,
    ]);
    if (!rows[0]) {
      res.status(404).json({ error: 'Name not found' });
      return;
    }
    await pool.query(`DELETE FROM species_names WHERE id = $1`, [req.params.nameId]);
    await audit(req, 'species.name.remove', req.params.id, rows[0], null);
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

// ---------- purposes / conditions (link tables) ----------
const linkDelete = (table: string, idCol: string, action: string) =>
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { rowCount } = await pool.query(
        `DELETE FROM ${table} WHERE species_id = $1 AND ${idCol} = $2`,
        [req.params.id, req.params.linkId],
      );
      if (!rowCount) {
        res.status(404).json({ error: 'Link not found' });
        return;
      }
      await audit(req, action, req.params.id, { [idCol]: req.params.linkId }, null);
      res.json({ ok: true });
    } catch (err) {
      next(err);
    }
  };

adminSpeciesRouter.post('/species/:id/purposes', requireRole('admin'), async (req, res, next) => {
  try {
    const body = nestedPurpose.parse(req.body);
    const { rows } = await pool.query(
      `INSERT INTO species_purposes (species_id, purpose_id, suitability, notes)
       SELECT $1, id, $2, $3 FROM purposes WHERE slug = $4
       ON CONFLICT (species_id, purpose_id) DO UPDATE SET suitability = EXCLUDED.suitability, notes = EXCLUDED.notes
       RETURNING *`,
      [req.params.id, body.suitability, body.notes ?? null, body.purpose_slug],
    );
    if (!rows[0]) {
      res.status(404).json({ error: 'Unknown purpose slug' });
      return;
    }
    await audit(req, 'species.purpose.set', req.params.id, null, body);
    res.status(201).json({ link: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

adminSpeciesRouter.delete(
  '/species/:id/purposes/:linkId',
  requireRole('admin'),
  linkDelete('species_purposes', 'purpose_id', 'species.purpose.remove'),
);

adminSpeciesRouter.post('/species/:id/conditions', requireRole('admin'), async (req, res, next) => {
  try {
    const body = nestedCondition.parse(req.body);
    const { rows } = await pool.query(
      `INSERT INTO species_planting_conditions (species_id, condition_id, suitability, notes)
       SELECT $1, id, $2, $3 FROM planting_conditions WHERE slug = $4
       ON CONFLICT (species_id, condition_id) DO UPDATE SET suitability = EXCLUDED.suitability, notes = EXCLUDED.notes
       RETURNING *`,
      [req.params.id, body.suitability, body.notes ?? null, body.condition_slug],
    );
    if (!rows[0]) {
      res.status(404).json({ error: 'Unknown condition slug' });
      return;
    }
    await audit(req, 'species.condition.set', req.params.id, null, body);
    res.status(201).json({ link: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

adminSpeciesRouter.delete(
  '/species/:id/conditions/:linkId',
  requireRole('admin'),
  linkDelete('species_planting_conditions', 'condition_id', 'species.condition.remove'),
);

// ---------- distribution ----------
adminSpeciesRouter.post('/species/:id/distribution', requireRole('admin'), async (req, res, next) => {
  try {
    const body = nestedDistribution.parse(req.body);
    const { rows } = await pool.query(
      `INSERT INTO species_distribution (species_id, region, province, island_group, distribution_type, notes)
       VALUES ($1,$2,$3,$4,$5,$6) RETURNING *`,
      [req.params.id, body.region ?? null, body.province ?? null, body.island_group ?? null, body.distribution_type, body.notes ?? null],
    );
    await audit(req, 'species.distribution.add', req.params.id, null, body);
    res.status(201).json({ distribution: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

adminSpeciesRouter.delete('/species/:id/distribution/:distId', requireRole('admin'), async (req, res, next) => {
  try {
    const { rowCount } = await pool.query(
      `DELETE FROM species_distribution WHERE id = $1 AND species_id = $2`,
      [req.params.distId, req.params.id],
    );
    if (!rowCount) {
      res.status(404).json({ error: 'Distribution record not found' });
      return;
    }
    await audit(req, 'species.distribution.remove', req.params.id, { id: req.params.distId }, null);
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

// ---------- references ----------
adminSpeciesRouter.post('/species/:id/references', requireRole('admin'), async (req, res, next) => {
  try {
    const body = nestedReference.parse(req.body);
    const { rows } = await pool.query(
      `INSERT INTO species_references (species_id, title, author, organization, publication_year, source_type, source_url, notes)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8) RETURNING *`,
      [req.params.id, body.title, body.author ?? null, body.organization ?? null, body.publication_year ?? null, body.source_type, body.source_url ?? null, body.notes ?? null],
    );
    await audit(req, 'species.reference.add', req.params.id, null, { title: body.title });
    res.status(201).json({ reference: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

adminSpeciesRouter.delete('/species/:id/references/:refId', requireRole('admin'), async (req, res, next) => {
  try {
    const { rowCount } = await pool.query(
      `DELETE FROM species_references WHERE id = $1 AND species_id = $2`,
      [req.params.refId, req.params.id],
    );
    if (!rowCount) {
      res.status(404).json({ error: 'Reference not found' });
      return;
    }
    await audit(req, 'species.reference.remove', req.params.id, { id: req.params.refId }, null);
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

// ---------- photos ----------
const photoSchema = z.object({
  photo_type: z.enum(['whole_tree', 'leaf', 'bark', 'flower', 'fruit', 'seed', 'seedling']),
  caption: z.string().max(1000).nullable().optional(),
});

adminSpeciesRouter.post(
  '/species/:id/photos',
  requireRole('moderator', 'admin'),
  upload.single('photo'),
  async (req, res, next) => {
    try {
      const body = photoSchema.parse(req.body);
      if (!req.file) {
        res.status(400).json({ error: 'Missing image file field "photo"' });
        return;
      }
      const stored = await saveBuffer(req.file.buffer, {
        prefix: `species/${req.params.id}`,
        filename: req.file.originalname || 'photo.jpg',
        contentType: req.file.mimetype,
      });
      const { rows } = await pool.query(
        `INSERT INTO species_photos (species_id, uploaded_by, file_url, photo_type, caption)
         VALUES ($1,$2,$3,$4,$5) RETURNING *`,
        [req.params.id, req.user!.id, stored.url, body.photo_type, body.caption ?? null],
      );
      await audit(req, 'species.photo.upload', req.params.id, null, { photo_type: body.photo_type });
      res.status(201).json({ photo: rows[0] });
    } catch (err) {
      if (err instanceof z.ZodError) {
        res.status(400).json({ error: 'Validation failed', details: err.flatten() });
        return;
      }
      next(err);
    }
  },
);

adminSpeciesRouter.patch('/species/:id/photos/:photoId', requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const schema = z.object({ verification_status: z.enum(['pending', 'verified', 'rejected']) });
    const body = schema.parse(req.body);
    const { rows } = await pool.query(
      `UPDATE species_photos SET verification_status = $1, verified_by = $2
       WHERE id = $3 AND species_id = $4 RETURNING *`,
      [body.verification_status, req.user!.id, req.params.photoId, req.params.id],
    );
    if (!rows[0]) {
      res.status(404).json({ error: 'Photo not found' });
      return;
    }
    await audit(req, `species.photo.${body.verification_status}`, req.params.id, null, {
      photo_id: req.params.photoId,
    });
    res.json({ photo: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

adminSpeciesRouter.delete('/species/:id/photos/:photoId', requireRole('admin'), async (req, res, next) => {
  try {
    const { rowCount } = await pool.query(
      `DELETE FROM species_photos WHERE id = $1 AND species_id = $2`,
      [req.params.photoId, req.params.id],
    );
    if (!rowCount) {
      res.status(404).json({ error: 'Photo not found' });
      return;
    }
    await audit(req, 'species.photo.remove', req.params.id, { photo_id: req.params.photoId }, null);
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

// ---------- catalog management ----------
const purposeSchema = z.object({
  name: z.string().min(2).max(120),
  slug: z.string().min(2).max(120),
  description: z.string().max(5000).default(''),
  icon: z.string().max(60).nullable().optional(),
  sort_order: z.number().int().default(0),
  active: z.boolean().default(true),
});

adminSpeciesRouter.post('/purposes', requireRole('admin'), async (req, res, next) => {
  try {
    const body = purposeSchema.parse(req.body);
    const { rows } = await pool.query(
      `INSERT INTO purposes (name, slug, description, icon, sort_order, active)
       VALUES ($1,$2,$3,$4,$5,$6) RETURNING *`,
      [body.name, body.slug.toLowerCase(), body.description, body.icon ?? null, body.sort_order, body.active],
    );
    res.status(201).json({ purpose: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

const conditionSchema = z.object({
  category: z.enum(['sunlight', 'site', 'soil', 'moisture', 'elevation', 'space']),
  name: z.string().min(2).max(120),
  slug: z.string().min(2).max(120),
  description: z.string().max(5000).nullable().optional(),
  active: z.boolean().default(true),
});

adminSpeciesRouter.post('/planting-conditions', requireRole('admin'), async (req, res, next) => {
  try {
    const body = conditionSchema.parse(req.body);
    const { rows } = await pool.query(
      `INSERT INTO planting_conditions (category, name, slug, description, active)
       VALUES ($1,$2,$3,$4,$5) RETURNING *`,
      [body.category, body.name, body.slug.toLowerCase(), body.description ?? null, body.active],
    );
    res.status(201).json({ condition: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});
