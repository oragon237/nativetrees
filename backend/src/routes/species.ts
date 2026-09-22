import { Router } from 'express';
import { z } from 'zod';
import { pool } from '../db/pool';

/**
 * Public Tree Knowledge Engine.
 * - GET /api/v1/species — search + structured filters (verified only)
 * - GET /api/v1/species/:id — full tree profile (verified only)
 * - GET /api/v1/recommendations — Right Tree finder engine (filtering, not AI)
 * - GET /api/v1/purposes, GET /api/v1/planting-conditions — catalogs
 */

const listQuery = z.object({
  q: z.string().max(200).optional(),
  purpose: z.string().max(500).optional(), // comma-separated slugs
  sunlight: z.string().max(300).optional(),
  site: z.string().max(500).optional(),
  soil: z.string().max(300).optional(),
  moisture: z.string().max(200).optional(),
  elevation: z.string().max(200).optional(),
  space: z.string().max(200).optional(),
  fruit_bearing: z.enum(['true', 'false']).optional(),
  flowering: z.enum(['true', 'false']).optional(),
  growth_rate: z.enum(['slow', 'moderate', 'fast']).optional(),
  growth_form: z.enum(['small', 'medium', 'large']).optional(),
  native_status: z.enum(['native', 'endemic']).optional(),
  province: z.string().max(120).optional(),
  region: z.string().max(120).optional(),
  island_group: z.enum(['Luzon', 'Visayas', 'Mindanao']).optional(),
  featured: z.enum(['true']).optional(),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  offset: z.coerce.number().int().min(0).default(0),
});

type Filters = z.infer<typeof listQuery>;

const LIST_COLUMNS = `
  s.id, s.scientific_name, s.genus, s.species_epithet, s.family, s.native_status,
  s.growth_form, s.min_height_m, s.max_height_m, s.min_canopy_m, s.max_canopy_m,
  s.growth_rate, s.fruit_bearing, s.flowering, s.verification_status, s.is_featured,
  (SELECT n.name FROM species_names n
     WHERE n.species_id = s.id AND n.is_primary AND n.name_type = 'common' LIMIT 1) AS primary_name,
  (SELECT p.file_url FROM species_photos p
     WHERE p.species_id = s.id AND p.verification_status = 'verified'
     ORDER BY p.created_at LIMIT 1) AS primary_photo,
  (SELECT COALESCE(array_agg(pp.slug), '{}') FROM species_purposes sp
     JOIN purposes pp ON pp.id = sp.purpose_id WHERE sp.species_id = s.id) AS purposes,
  (SELECT COALESCE(array_agg(c.slug), '{}') FROM species_planting_conditions spc
     JOIN planting_conditions c ON c.id = spc.condition_id WHERE spc.species_id = s.id) AS conditions`;

function csv(v?: string): string[] {
  return (v ?? '').split(',').map((s) => s.trim().toLowerCase()).filter(Boolean);
}

/** Builds the shared WHERE clause. Always restricts to verified, non-deleted records. */
function buildWhere(f: Filters, values: unknown[]): string {
  const conds = [`s.verification_status = 'verified'`, `s.deleted_at IS NULL`];
  const push = (sql: string, ...params: unknown[]) => {
    for (const p of params) values.push(p);
    conds.push(sql);
  };

  if (f.q?.trim()) {
    values.push(`%${f.q.trim()}%`);
    const i = values.length;
    conds.push(
      `(s.scientific_name ILIKE $${i} OR s.genus ILIKE $${i} OR s.family ILIKE $${i}
        OR EXISTS (SELECT 1 FROM species_names n WHERE n.species_id = s.id AND n.name ILIKE $${i}))`,
    );
  }
  const purposes = csv(f.purpose);
  if (purposes.length) {
    values.push(purposes);
    conds.push(
      `EXISTS (SELECT 1 FROM species_purposes sp JOIN purposes p ON p.id = sp.purpose_id
        WHERE sp.species_id = s.id AND p.slug = ANY($${values.length}))`,
    );
  }
  const condCats: Array<[string | undefined, string]> = [
    [f.sunlight, 'sunlight'],
    [f.site, 'site'],
    [f.soil, 'soil'],
    [f.moisture, 'moisture'],
    [f.elevation, 'elevation'],
    [f.space, 'space'],
  ];
  for (const [raw, category] of condCats) {
    const slugs = csv(raw);
    if (!slugs.length) continue;
    values.push(category, slugs);
    const ci = values.length - 1;
    conds.push(
      `EXISTS (SELECT 1 FROM species_planting_conditions spc
        JOIN planting_conditions c ON c.id = spc.condition_id
        WHERE spc.species_id = s.id AND c.category = $${ci} AND c.slug = ANY($${ci + 1}))`,
    );
  }
  if (f.fruit_bearing !== undefined) push(`s.fruit_bearing = $${values.length + 1}`, f.fruit_bearing === 'true');
  if (f.featured) push(`s.is_featured = TRUE`);
  if (f.flowering !== undefined) push(`s.flowering = $${values.length + 1}`, f.flowering === 'true');
  if (f.growth_rate) push(`s.growth_rate = $${values.length + 1}`, f.growth_rate);
  if (f.growth_form) push(`s.growth_form = $${values.length + 1}`, f.growth_form);
  if (f.native_status) push(`s.native_status = $${values.length + 1}`, f.native_status);
  if (f.province) {
    values.push(f.province);
    conds.push(
      `EXISTS (SELECT 1 FROM species_distribution d WHERE d.species_id = s.id AND d.province ILIKE $${values.length})`,
    );
  }
  if (f.region) {
    values.push(f.region);
    conds.push(
      `EXISTS (SELECT 1 FROM species_distribution d WHERE d.species_id = s.id AND d.region ILIKE $${values.length})`,
    );
  }
  if (f.island_group) {
    values.push(f.island_group);
    conds.push(
      `EXISTS (SELECT 1 FROM species_distribution d WHERE d.species_id = s.id AND d.island_group = $${values.length})`,
    );
  }
  return conds.join(' AND ');
}

/** Human-readable labels for match reasons. */
async function labelMaps(): Promise<{ purposes: Map<string, string>; conditions: Map<string, string> }> {
  const [p, c] = await Promise.all([
    pool.query(`SELECT slug, name FROM purposes`),
    pool.query(`SELECT slug, name, category FROM planting_conditions`),
  ]);
  return {
    purposes: new Map(p.rows.map((r) => [r.slug as string, r.name as string])),
    conditions: new Map(c.rows.map((r) => [r.slug as string, `${r.name} (${r.category})`])),
  };
}

function matchReasons(
  f: Filters,
  row: { purposes: string[]; conditions: string[] },
  labels: { purposes: Map<string, string>; conditions: Map<string, string> },
): string[] {
  const out: string[] = [];
  for (const slug of csv(f.purpose)) {
    if (row.purposes.includes(slug)) out.push(`Documented purpose: ${labels.purposes.get(slug) ?? slug}`);
  }
  for (const raw of [f.sunlight, f.site, f.soil, f.moisture, f.elevation, f.space]) {
    for (const slug of csv(raw)) {
      if (row.conditions.includes(slug)) out.push(`Suitable for ${labels.conditions.get(slug) ?? slug}`);
    }
  }
  return out;
}

async function searchSpecies(f: Filters) {
  const values: unknown[] = [];
  const where = buildWhere(f, values);
  const total = (
    await pool.query(`SELECT COUNT(*)::int AS total FROM species s WHERE ${where}`, values)
  ).rows[0].total as number;
  values.push(f.limit, f.offset);
  const { rows } = await pool.query(
    `SELECT ${LIST_COLUMNS} FROM species s WHERE ${where}
     ORDER BY s.scientific_name LIMIT $${values.length - 1} OFFSET $${values.length}`,
    values,
  );
  return { rows, total };
}

export const speciesRouter = Router();

// GET /api/v1/species
speciesRouter.get('/', async (req, res, next) => {
  try {
    const f = listQuery.parse(req.query);
    const { rows, total } = await searchSpecies(f);
    const labels = await labelMaps();
    res.json({
      total,
      limit: f.limit,
      offset: f.offset,
      species: rows.map((r) => ({ ...r, matchReasons: matchReasons(f, r, labels) })),
    });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// GET /api/v1/species/:id — full tree profile
speciesRouter.get('/:id', async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT s.*,
        (SELECT n.name FROM species_names n WHERE n.species_id = s.id
          AND n.is_primary AND n.name_type = 'common' LIMIT 1) AS primary_name
       FROM species s WHERE s.id = $1 AND s.verification_status = 'verified' AND s.deleted_at IS NULL`,
      [req.params.id],
    );
    const species = rows[0];
    if (!species) {
      res.status(404).json({ error: 'Species not found' });
      return;
    }
    const [names, photos, purposes, conditions, distribution, references] = await Promise.all([
      pool.query(`SELECT * FROM species_names WHERE species_id = $1 ORDER BY is_primary DESC, name`, [
        species.id,
      ]),
      pool.query(
        `SELECT id, file_url, thumbnail_url, photo_type, caption, created_at FROM species_photos
         WHERE species_id = $1 AND verification_status = 'verified' ORDER BY created_at`,
        [species.id],
      ),
      pool.query(
        `SELECT p.id, p.name, p.slug, p.description, sp.suitability, sp.notes
         FROM species_purposes sp JOIN purposes p ON p.id = sp.purpose_id WHERE sp.species_id = $1`,
        [species.id],
      ),
      pool.query(
        `SELECT c.id, c.category, c.name, c.slug, spc.suitability, spc.notes
         FROM species_planting_conditions spc JOIN planting_conditions c ON c.id = spc.condition_id
         WHERE spc.species_id = $1 ORDER BY c.category, c.name`,
        [species.id],
      ),
      pool.query(`SELECT * FROM species_distribution WHERE species_id = $1`, [species.id]),
      pool.query(`SELECT * FROM species_references WHERE species_id = $1 ORDER BY created_at`, [
        species.id,
      ]),
    ]);
    const groupedConditions: Record<string, typeof conditions.rows> = {};
    for (const c of conditions.rows) {
      (groupedConditions[c.category] ??= []).push(c);
    }
    res.json({
      species,
      names: names.rows,
      photos: photos.rows,
      purposes: purposes.rows,
      plantingConditions: groupedConditions,
      distribution: distribution.rows,
      references: references.rows,
    });
  } catch (err) {
    next(err);
  }
});

// GET /api/v1/species/:id/listings — Find Seedlings (active only, public: no seller contact)
speciesRouter.get('/:id/listings', async (req, res, next) => {
  try {
    const province = (req.query.province as string) ?? '';
    const values: unknown[] = [req.params.id];
    let extra = '';
    if (province.trim()) {
      values.push(province.trim());
      extra = `AND l.province ILIKE $2`;
    }
    const { rows } = await pool.query(
      `SELECT l.id, l.title, l.material_type, l.quantity, l.price, l.province, l.municipality,
        l.approximate_height_cm, u.display_name AS seller_name,
        EXISTS(SELECT 1 FROM nursery_verifications n WHERE n.user_id = l.seller_id AND n.status = 'verified') AS seller_verified,
        (SELECT p.file_url FROM listing_photos p WHERE p.listing_id = l.id ORDER BY p.sort_order LIMIT 1) AS cover_photo
       FROM marketplace_listings l JOIN users u ON u.id = l.seller_id
       WHERE l.species_id = $1 AND l.status = 'active' AND l.deleted_at IS NULL ${extra}
       ORDER BY l.created_at DESC`,
      values,
    );
    res.json({ listings: rows });
  } catch (err) {
    next(err);
  }
});

export const recommendationsRouter = Router();
// GET /api/v1/recommendations?purpose=shade&site=backyard&sunlight=full-sun&space=large...
// Filtering/matching system (V1) — NOT an AI engine. No percentage scores.
recommendationsRouter.get('/', async (req, res, next) => {
  try {
    const f = listQuery.parse(req.query);
    const hasFacet =
      f.purpose ?? f.sunlight ?? f.site ?? f.soil ?? f.moisture ?? f.elevation ?? f.space;
    if (!hasFacet && !f.province && !f.island_group) {
      res.status(400).json({
        error: 'Specify at least one of: purpose, sunlight, site, soil, moisture, elevation, space, province, island_group',
      });
      return;
    }
    const { rows, total } = await searchSpecies(f);
    const labels = await labelMaps();
    res.json({
      total,
      limit: f.limit,
      offset: f.offset,
      matches: rows.map((r) => ({
        id: r.id,
        primary_name: r.primary_name,
        scientific_name: r.scientific_name,
        native_status: r.native_status,
        growth_form: r.growth_form,
        max_height_m: r.max_height_m,
        max_canopy_m: r.max_canopy_m,
        primary_photo: r.primary_photo,
        purposes: r.purposes,
        matchReasons: matchReasons(f, r, labels),
      })),
    });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

export const catalogRouter = Router();

catalogRouter.get('/purposes', async (_req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT id, name, slug, description, icon, sort_order FROM purposes
       WHERE active ORDER BY sort_order, name`,
    );
    res.json({ purposes: rows });
  } catch (err) {
    next(err);
  }
});

catalogRouter.get('/planting-conditions', async (_req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT id, category, name, slug, description FROM planting_conditions
       WHERE active ORDER BY category, name`,
    );
    const grouped: Record<string, typeof rows> = {};
    for (const c of rows) (grouped[c.category] ??= []).push(c);
    res.json({ conditions: grouped });
  } catch (err) {
    next(err);
  }
});
