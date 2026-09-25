import { Router } from 'express';
import { z } from 'zod';
import multer from 'multer';
import { pool } from '../db/pool';
import { authRequired } from '../middleware/auth';
import { requireRole, writeAudit } from '../middleware/requireRole';
import { saveBuffer } from '../utils/storage';
import { moderate, notify, sanitizeLocation } from '../utils/moderation';

/**
 * Community Species & Photo Contributions.
 * Users propose new species / contribute photos; NOTHING becomes verified
 * data without moderator/admin review. Publishing runs in transactions and
 * is idempotent (re-approving returns the existing official record).
 * Mounted at /api/v1 with per-route auth (never blanket middleware).
 */

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 8 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => (file.mimetype.startsWith('image/') ? cb(null, true) : cb(new Error('Only images'))),
});

const MAX_PHOTOS = 8;
const PHOTO_TYPES = ['whole_tree', 'leaf', 'bark', 'flower', 'fruit', 'seed', 'seedling', 'other'] as const;
const PRECISION = z.enum(['hidden', 'municipality', 'approximate', 'exact_private']).default('municipality');

const audit = (
  req: { user?: { id: string }; ip?: string },
  action: string,
  entityType: string,
  entityId: string,
  oldValues?: unknown,
  newValues?: unknown,
) =>
  writeAudit(pool.query.bind(pool), {
    userId: req.user!.id,
    action,
    entityType,
    entityId,
    oldValues,
    newValues,
    ip: req.ip,
  });

/** Normalized duplicate matching across scientific + all known names. */
async function findDuplicates(q: string, includePending = true) {
  const needle = q.toLowerCase().trim().replace(/\s+/g, ' ');
  if (!needle) return { species: [], pendingContributions: [] };
  const like = `%${needle}%`;
  const { rows: species } = await pool.query(
    `SELECT s.id, s.scientific_name, s.verification_status,
      (SELECT n.name FROM species_names n WHERE n.species_id = s.id
        AND n.is_primary AND n.name_type = 'common' LIMIT 1) AS primary_name
     FROM species s
     WHERE s.deleted_at IS NULL AND s.id IN (
       SELECT s2.id FROM species s2 LEFT JOIN species_names n2 ON n2.species_id = s2.id
       WHERE s2.deleted_at IS NULL AND (s2.scientific_name ILIKE $1 OR n2.name ILIKE $1)
     )
     ORDER BY
       CASE WHEN lower(s.scientific_name) = $2 THEN 0
            WHEN EXISTS (SELECT 1 FROM species_names x WHERE x.species_id = s.id AND lower(x.name) = $2) THEN 1
            ELSE 2 END,
       s.scientific_name
     LIMIT 5`,
    [like, needle],
  );
  let pendingContributions: unknown[] = [];
  if (includePending) {
    const r = await pool.query(
      `SELECT id, proposed_common_name, proposed_scientific_name, status FROM species_contributions
       WHERE deleted_at IS NULL AND status IN ('pending','under_review','needs_more_info')
         AND (lower(proposed_common_name) LIKE $1 OR lower(COALESCE(proposed_scientific_name,'')) LIKE $1)
       LIMIT 5`,
      [like],
    );
    pendingContributions = r.rows;
  }
  return { species, pendingContributions };
}

export const contributionsRouter = Router();

// ---------- duplicate check (must precede :id routes) ----------
contributionsRouter.get('/species-contributions/check-duplicates', authRequired, async (req, res, next) => {
  try {
    const q = z.object({ q: z.string().min(2).max(255) }).parse(req.query);
    const { species, pendingContributions } = await findDuplicates(q.q);
    res.json({ matches: species, pendingContributions });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// ---------- user: species contributions ----------
const createSchema = z.object({
  proposed_common_name: z.string().min(2).max(255),
  proposed_scientific_name: z.string().max(255).nullable().optional(),
  description: z.string().max(10000).default(''),
  location_text: z.string().max(255).nullable().optional(),
  latitude: z.number().min(-90).max(90).nullable().optional(),
  longitude: z.number().min(-180).max(180).nullable().optional(),
  location_precision: PRECISION,
  observed_at: z.string().date().nullable().optional(),
  source_reference: z.string().max(5000).nullable().optional(),
});

function cleanScientific(v: unknown): string | null {
  if (typeof v !== 'string') return null;
  const t = v.trim();
  if (!t || /^unknown$/i.test(t)) return null;
  return t;
}

contributionsRouter.post('/species-contributions', authRequired, async (req, res, next) => {
  try {
    const body = createSchema.parse(req.body);
    const sci = cleanScientific(body.proposed_scientific_name);
    const { rows } = await pool.query(
      `INSERT INTO species_contributions (submitted_by, proposed_scientific_name, proposed_common_name,
        description, location_text, latitude, longitude, location_precision, observed_at, source_reference)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) RETURNING *`,
      [req.user!.id, sci, body.proposed_common_name.trim(), body.description,
        body.location_text ?? null, body.latitude ?? null, body.longitude ?? null,
        body.location_precision, body.observed_at ?? null, body.source_reference ?? null],
    );
    const c = rows[0];
    await moderate(req.user!.id, 'species_contribution', c.id, 'submitted');
    await notify(req.user!.id, 'contribution.submitted', 'Contribution received 🌳',
      `Your proposed species "${c.proposed_common_name}" is pending moderator review.`,
      'species_contribution', c.id);
    const { species, pendingContributions } = await findDuplicates(
      `${c.proposed_common_name} ${sci ?? ''}`, false);
    res.status(201).json({ contribution: c, possibleDuplicates: species, pendingContributions });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

contributionsRouter.get('/species-contributions/mine', authRequired, async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT c.*,
        (SELECT count(*)::int FROM species_contribution_photos p WHERE p.contribution_id = c.id) AS photo_count,
        (SELECT p.file_url FROM species_contribution_photos p WHERE p.contribution_id = c.id ORDER BY p.created_at LIMIT 1) AS thumbnail
       FROM species_contributions c
       WHERE c.submitted_by = $1 AND c.deleted_at IS NULL ORDER BY c.created_at DESC`,
      [req.user!.id],
    );
    res.json({ contributions: rows });
  } catch (err) {
    next(err);
  }
});

async function visibleContribution(id: string, viewer: { id: string; roles: string[] } | undefined) {
  const c = (await pool.query(`SELECT * FROM species_contributions WHERE id = $1 AND deleted_at IS NULL`, [id])).rows[0];
  if (!c) return null;
  const isMod = !!viewer && (viewer.roles.includes('moderator') || viewer.roles.includes('admin'));
  if (!viewer || (c.submitted_by !== viewer.id && !isMod)) return null;
  return c;
}

contributionsRouter.get('/species-contributions/:id', authRequired, async (req, res, next) => {
  try {
    const c = await visibleContribution(req.params.id, req.user ?? undefined);
    if (!c) {
      res.status(404).json({ error: 'Contribution not found' });
      return;
    }
    const photos = (await pool.query(
      `SELECT * FROM species_contribution_photos WHERE contribution_id = $1 ORDER BY created_at`, [c.id])).rows;
    const { species } = await findDuplicates(`${c.proposed_common_name} ${c.proposed_scientific_name ?? ''}`, false);
    const submitter = (await pool.query(`SELECT display_name, province FROM users WHERE id = $1`, [c.submitted_by])).rows[0];
    res.json({
      contribution: sanitizeLocation(c, req.user ?? null, c.submitted_by),
      photos,
      possibleDuplicates: species,
      submitter: submitter ? { display_name: submitter.display_name, province: submitter.province } : null,
    });
  } catch (err) {
    next(err);
  }
});

const ownerEditSchema = z.object({
  proposed_common_name: z.string().min(2).max(255).optional(),
  proposed_scientific_name: z.string().max(255).nullable().optional(),
  description: z.string().max(10000).optional(),
  location_text: z.string().max(255).nullable().optional(),
  latitude: z.number().min(-90).max(90).nullable().optional(),
  longitude: z.number().min(-180).max(180).nullable().optional(),
  location_precision: z.enum(['hidden', 'municipality', 'approximate', 'exact_private']).optional(),
  observed_at: z.string().date().nullable().optional(),
  source_reference: z.string().max(5000).nullable().optional(),
});

contributionsRouter.patch('/species-contributions/:id', authRequired, async (req, res, next) => {
  try {
    const c = (await pool.query(`SELECT * FROM species_contributions WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!c || c.submitted_by !== req.user!.id) {
      res.status(404).json({ error: 'Contribution not found' });
      return;
    }
    if (!['pending', 'needs_more_info'].includes(c.status)) {
      res.status(400).json({ error: `Cannot edit a ${c.status} contribution` });
      return;
    }
    const body = ownerEditSchema.parse(req.body);
    const sets: string[] = [];
    const values: unknown[] = [];
    for (const [k, v] of Object.entries(body)) {
      if (v !== undefined) {
        values.push(k === 'proposed_scientific_name' ? cleanScientific(v) : typeof v === 'string' ? v.trim() : v);
        sets.push(`${k} = $${values.length}`);
      }
    }
    if (!sets.length) {
      res.status(400).json({ error: 'No fields to update' });
      return;
    }
    values.push(c.id);
    const { rows } = await pool.query(`UPDATE species_contributions SET ${sets.join(', ')} WHERE id = $${values.length} RETURNING *`, values);
    await moderate(req.user!.id, 'species_contribution', c.id, 'edited');
    res.json({ contribution: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

async function addContributionPhotos(contributionId: string, files: Express.Multer.File[], photoType: string, caption?: string) {
  const count = (await pool.query(`SELECT count(*)::int AS c FROM species_contribution_photos WHERE contribution_id = $1`, [contributionId])).rows[0].c as number;
  if (count + files.length > MAX_PHOTOS) {
    throw Object.assign(new Error(`At most ${MAX_PHOTOS} photos per contribution`), { status: 400 });
  }
  const out = [];
  for (const f of files) {
    const stored = await saveBuffer(f.buffer, { prefix: `contributions/${contributionId}`, filename: f.originalname || 'photo.jpg' });
    const { rows } = await pool.query(
      `INSERT INTO species_contribution_photos (contribution_id, file_url, photo_type, caption)
       VALUES ($1,$2,$3,$4) RETURNING *`,
      [contributionId, stored.url, photoType, caption ?? null],
    );
    out.push(rows[0]);
  }
  return out;
}

contributionsRouter.post('/species-contributions/:id/photos', authRequired, upload.array('photo', MAX_PHOTOS), async (req, res, next) => {
  try {
    const c = (await pool.query(`SELECT * FROM species_contributions WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    const isMod = req.user!.roles.includes('moderator') || req.user!.roles.includes('admin');
    if (!c || (c.submitted_by !== req.user!.id && !isMod)) {
      res.status(404).json({ error: 'Contribution not found' });
      return;
    }
    if (!['pending', 'needs_more_info'].includes(c.status) && !isMod) {
      res.status(400).json({ error: `Cannot add photos to a ${c.status} contribution` });
      return;
    }
    const schema = z.object({
      photo_type: z.enum(PHOTO_TYPES).default('whole_tree'),
      caption: z.string().max(1000).nullable().optional(),
    });
    const body = schema.parse(req.body);
    if (!req.files?.length) {
      res.status(400).json({ error: 'Attach 1–8 image files as "photos"' });
      return;
    }
    const photos = await addContributionPhotos(c.id, req.files as Express.Multer.File[], body.photo_type, body.caption ?? undefined);
    res.status(201).json({ photos });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    if ((err as { status?: number }).status === 400) {
      res.status(400).json({ error: (err as Error).message });
      return;
    }
    next(err);
  }
});

contributionsRouter.post('/species-contributions/:id/resubmit', authRequired, async (req, res, next) => {
  try {
    const c = (await pool.query(`SELECT * FROM species_contributions WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!c || c.submitted_by !== req.user!.id) {
      res.status(404).json({ error: 'Contribution not found' });
      return;
    }
    if (c.status !== 'needs_more_info') {
      res.status(400).json({ error: 'Only contributions needing more info can be resubmitted' });
      return;
    }
    await pool.query(`UPDATE species_contributions SET status = 'pending' WHERE id = $1`, [c.id]);
    await moderate(req.user!.id, 'species_contribution', c.id, 'resubmitted');
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

// ---------- user: photo contributions to existing species ----------
const photoCreateSchema = z.object({
  photo_type: z.enum(PHOTO_TYPES).default('whole_tree'),
  location_text: z.string().max(255).nullable().optional(),
  latitude: z.number().min(-90).max(90).nullable().optional(),
  longitude: z.number().min(-180).max(180).nullable().optional(),
  location_precision: PRECISION,
  photographed_at: z.string().date().nullable().optional(),
  caption: z.string().max(1000).nullable().optional(),
  credit_name: z.string().max(120).nullable().optional(),
});

contributionsRouter.post('/species/:speciesId/photo-contributions', authRequired, upload.array('photo', MAX_PHOTOS), async (req, res, next) => {
  try {
    const sp = (await pool.query(`SELECT id FROM species WHERE id = $1 AND deleted_at IS NULL`, [req.params.speciesId])).rows[0];
    if (!sp) {
      res.status(404).json({ error: 'Species not found' });
      return;
    }
    const body = photoCreateSchema.parse(req.body);
    if (!req.files?.length) {
      res.status(400).json({ error: 'Attach 1–8 image files as "photos"' });
      return;
    }
    const files = req.files as Express.Multer.File[];
    // One contribution PER photo (each gets independent review + credit).
    const created = [];
    for (const f of files) {
      const stored = await saveBuffer(f.buffer, { prefix: `photo-contributions/${req.params.speciesId}`, filename: f.originalname || 'photo.jpg' });
      const { rows: r2 } = await pool.query(
        `INSERT INTO photo_contributions (species_id, submitted_by, file_url, photo_type, location_text,
          latitude, longitude, location_precision, photographed_at, caption, credit_name)
         VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11) RETURNING *`,
        [req.params.speciesId, req.user!.id, stored.url, body.photo_type, body.location_text ?? null,
          body.latitude ?? null, body.longitude ?? null, body.location_precision,
          body.photographed_at ?? null, body.caption ?? null, body.credit_name ?? null],
      );
      created.push(r2[0]);
      await moderate(req.user!.id, 'photo_contribution', r2[0].id, 'submitted');
    }
    await notify(req.user!.id, 'contribution.submitted', 'Photo contribution received 📷',
      `${created.length} photo(s) submitted for review. They will appear in the gallery only after approval.`,
      'photo_contribution', created[0]?.id);
    res.status(201).json({ contributions: created });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

contributionsRouter.get('/photo-contributions/mine', authRequired, async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT p.*, s.scientific_name,
        (SELECT n.name FROM species_names n WHERE n.species_id = p.species_id
          AND n.is_primary AND n.name_type = 'common' LIMIT 1) AS species_name
       FROM photo_contributions p JOIN species s ON s.id = p.species_id
       WHERE p.submitted_by = $1 AND p.deleted_at IS NULL ORDER BY p.created_at DESC`,
      [req.user!.id],
    );
    res.json({ contributions: rows });
  } catch (err) {
    next(err);
  }
});

contributionsRouter.get('/photo-contributions/:id', authRequired, async (req, res, next) => {
  try {
    const p = (await pool.query(`SELECT * FROM photo_contributions WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    const isMod = req.user!.roles.includes('moderator') || req.user!.roles.includes('admin');
    if (!p || (p.submitted_by !== req.user!.id && !isMod)) {
      res.status(404).json({ error: 'Contribution not found' });
      return;
    }
    res.json({ contribution: sanitizeLocation(p, req.user ?? null, p.submitted_by) });
  } catch (err) {
    next(err);
  }
});

// ---------- admin/moderator review queues ----------
contributionsRouter.get('/admin/species-contributions', authRequired, requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const status = req.query.status as string | undefined;
    const limit = Math.min(parseInt((req.query.limit as string) ?? '20', 10) || 20, 100);
    const offset = parseInt((req.query.offset as string) ?? '0', 10) || 0;
    const conds = ['c.deleted_at IS NULL'];
    const values: unknown[] = [];
    if (status && ['pending', 'under_review', 'needs_more_info', 'approved', 'rejected'].includes(status)) {
      values.push(status);
      conds.push(`c.status = $${values.length}`);
    }
    values.push(limit, offset);
    const { rows } = await pool.query(
      `SELECT c.*, u.display_name AS contributor,
        (SELECT count(*)::int FROM species_contribution_photos p WHERE p.contribution_id = c.id) AS photo_count,
        (SELECT p.file_url FROM species_contribution_photos p WHERE p.contribution_id = c.id ORDER BY p.created_at LIMIT 1) AS thumbnail
       FROM species_contributions c JOIN users u ON u.id = c.submitted_by
       WHERE ${conds.join(' AND ')} ORDER BY c.created_at DESC
       LIMIT $${values.length - 1} OFFSET $${values.length}`,
      values,
    );
    res.json({ contributions: rows });
  } catch (err) {
    next(err);
  }
});

contributionsRouter.get('/admin/species-contributions/:id', authRequired, requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const c = (await pool.query(
      `SELECT c.*, u.display_name AS contributor, u.province AS contributor_province
       FROM species_contributions c JOIN users u ON u.id = c.submitted_by
       WHERE c.id = $1 AND c.deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!c) {
      res.status(404).json({ error: 'Contribution not found' });
      return;
    }
    const photos = (await pool.query(
      `SELECT * FROM species_contribution_photos WHERE contribution_id = $1 ORDER BY created_at`, [c.id])).rows;
    const { species } = await findDuplicates(`${c.proposed_common_name} ${c.proposed_scientific_name ?? ''}`, false);
    res.json({ contribution: c, photos, possibleDuplicates: species });
  } catch (err) {
    next(err);
  }
});

const modEditSchema = z.object({
  proposed_common_name: z.string().min(2).max(255).optional(),
  proposed_scientific_name: z.string().max(255).nullable().optional(),
  description: z.string().max(10000).optional(),
  location_text: z.string().max(255).nullable().optional(),
  observed_at: z.string().date().nullable().optional(),
  source_reference: z.string().max(5000).nullable().optional(),
});

// Moderator/Admin may correct proposed data before approval.
contributionsRouter.patch('/admin/species-contributions/:id', authRequired, requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const c = (await pool.query(`SELECT * FROM species_contributions WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!c || ['approved', 'rejected'].includes(c.status)) {
      res.status(404).json({ error: 'Editable contribution not found' });
      return;
    }
    const body = modEditSchema.parse(req.body);
    const sets: string[] = [];
    const values: unknown[] = [];
    for (const [k, v] of Object.entries(body)) {
      if (v !== undefined) {
        values.push(k === 'proposed_scientific_name' ? cleanScientific(v) : typeof v === 'string' ? v.trim() : v);
        sets.push(`${k} = $${values.length}`);
      }
    }
    if (!sets.length) {
      res.status(400).json({ error: 'No fields to update' });
      return;
    }
    values.push(c.id);
    const { rows } = await pool.query(`UPDATE species_contributions SET ${sets.join(', ')} WHERE id = $${values.length} RETURNING *`, values);
    await moderate(req.user!.id, 'species_contribution', c.id, 'edited');
    res.json({ contribution: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

function splitScientific(name: string): { genus: string; epithet: string } {
  const parts = name.trim().split(/\s+/);
  return { genus: parts[0], epithet: parts.slice(1).join(' ') || 'sp.' };
}

const approveSchema = z.object({
  scientific_name: z.string().min(3).max(255).optional(),
  common_name: z.string().min(2).max(255).optional(),
  family: z.string().min(2).max(120),
  genus: z.string().min(2).max(120).optional(),
  species_epithet: z.string().min(1).max(120).optional(),
  native_status: z.enum(['native', 'endemic']).default('native'),
  reason: z.string().max(2000).optional(),
});

// ADMIN ONLY: publish — creates the official species record in a transaction.
// Idempotent: re-approving returns the already-published record.
contributionsRouter.post('/admin/species-contributions/:id/approve', authRequired, requireRole('admin'), async (req, res, next) => {
  const client = await pool.connect();
  try {
    const body = approveSchema.parse(req.body);
    const c = (await client.query(`SELECT * FROM species_contributions WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!c) {
      res.status(404).json({ error: 'Contribution not found' });
      return;
    }
    if (c.published_species_id) {
      const existing = (await client.query(`SELECT * FROM species WHERE id = $1`, [c.published_species_id])).rows[0];
      res.json({ species: existing, alreadyPublished: true });
      return;
    }
    if (['approved', 'rejected'].includes(c.status)) {
      res.status(404).json({ error: 'Approvable contribution not found' });
      return;
    }
    const finalSci = (body.scientific_name ?? c.proposed_scientific_name ?? '').trim();
    if (!finalSci) {
      res.status(400).json({ error: 'A scientific name is required to publish (correct it first)' });
      return;
    }
    const finalCommon = (body.common_name ?? c.proposed_common_name ?? '').trim();
    // Final duplicate check inside the transaction.
    const dup = (await client.query(
      `SELECT s.id FROM species s LEFT JOIN species_names n ON n.species_id = s.id
       WHERE s.deleted_at IS NULL AND (lower(s.scientific_name) = lower($1)
         OR (n.name_type = 'common' AND n.is_primary AND lower(n.name) = lower($2)))
       LIMIT 1`,
      [finalSci, finalCommon],
    )).rows[0];
    if (dup) {
      res.status(409).json({ error: 'A matching species now exists — link or merge instead', species_id: dup.id });
      return;
    }
    const { genus, epithet } = splitScientific(finalSci);
    await client.query('BEGIN');
    try {
      const { rows: srows } = await client.query(
        `INSERT INTO species (scientific_name, genus, species_epithet, family, native_status,
          description, verification_status, created_by, verified_by, verified_at)
         VALUES ($1,$2,$3,$4,$5,$6,'verified',$7,$7,now()) RETURNING *`,
        [finalSci, body.genus ?? genus, body.species_epithet ?? epithet, body.family.trim(),
          body.native_status, c.description, req.user!.id],
      );
      const species = srows[0];
      await client.query(
        `INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES ($1,$2,'common',TRUE)`,
        [species.id, finalCommon],
      );
      const cphotos = (await client.query(
        `SELECT * FROM species_contribution_photos WHERE contribution_id = $1 ORDER BY created_at`, [c.id])).rows;
      for (const p of cphotos) {
        const mapped = p.photo_type === 'other' ? 'whole_tree' : p.photo_type;
        const caption = p.photo_type === 'other' && p.caption
          ? `${p.caption} (category: other)` : (p.caption ?? 'Community-contributed photo.');
        await client.query(
          `INSERT INTO species_photos (species_id, uploaded_by, file_url, photo_type, caption, verification_status, verified_by)
           VALUES ($1,$2,$3,$4,$5,'verified',$6)`,
          [species.id, c.submitted_by, p.file_url, mapped, caption, req.user!.id],
        );
      }
      await client.query(
        `UPDATE species_contributions SET status = 'approved', published_species_id = $1,
          reviewed_by = $2, reviewed_at = now() WHERE id = $3`,
        [species.id, req.user!.id, c.id],
      );
      await client.query('COMMIT');
      await moderate(req.user!.id, 'species_contribution', c.id, 'approved', body.reason);
      await writeAudit(pool.query.bind(pool), {
        userId: req.user!.id,
        action: 'species.contribution.published',
        entityType: 'species',
        entityId: species.id,
        oldValues: { contribution_id: c.id },
        newValues: { scientific_name: finalSci },
        ip: req.ip,
      });
      await notify(c.submitted_by, 'contribution.approved', 'Species contribution approved ✓',
        `Your proposed species "${finalCommon}" is now part of the official database.`, 'species', species.id);
      res.status(201).json({ species, photosPublished: cphotos.length });
    } catch (e) {
      await client.query('ROLLBACK');
      throw e;
    }
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  } finally {
    client.release();
  }
});

const reviewSchema = z.object({ message: z.string().max(2000).optional() });

async function setContributionStatus(
  req: { user?: { id: string }; ip?: string },
  res: { status: (c: number) => { json: (b: unknown) => void }; json: (b: unknown) => void },
  id: string, status: 'under_review' | 'needs_more_info' | 'rejected', message?: string,
) {
  const c = (await pool.query(`SELECT * FROM species_contributions WHERE id = $1 AND deleted_at IS NULL`, [id])).rows[0];
  if (!c || ['approved', 'rejected'].includes(c.status)) {
    res.status(404).json({ error: 'Reviewable contribution not found' });
    return;
  }
  await pool.query(
    `UPDATE species_contributions SET status = $1, review_notes = COALESCE($2, review_notes),
      reviewed_by = $3, reviewed_at = now() WHERE id = $4`,
    [status, message ?? null, req.user!.id, id],
  );
  await moderate(req.user!.id, 'species_contribution', id, status, message);
  if (status !== 'under_review') {
    const titles = { needs_more_info: 'More information needed', rejected: 'Contribution not approved' } as const;
    await notify(c.submitted_by, `contribution.${status === 'rejected' ? 'rejected' : 'needs_info'}`,
      titles[status], message ?? `Your species contribution is now: ${status}.`,
      'species_contribution', id);
  }
  res.json({ ok: true });
}

contributionsRouter.post('/admin/species-contributions/:id/request-info', authRequired, requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const body = reviewSchema.parse(req.body);
    await setContributionStatus(req, res, req.params.id, 'needs_more_info', body.message);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

contributionsRouter.post('/admin/species-contributions/:id/reject', authRequired, requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const body = reviewSchema.parse(req.body);
    await setContributionStatus(req, res, req.params.id, 'rejected', body.message);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

contributionsRouter.post('/admin/species-contributions/:id/review', authRequired, requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    await setContributionStatus(req, res, req.params.id, 'under_review');
  } catch (err) {
    next(err);
  }
});

// ---------- admin: photo contributions ----------
contributionsRouter.get('/admin/photo-contributions', authRequired, requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const status = req.query.status as string | undefined;
    const limit = Math.min(parseInt((req.query.limit as string) ?? '20', 10) || 20, 100);
    const offset = parseInt((req.query.offset as string) ?? '0', 10) || 0;
    const conds = ['p.deleted_at IS NULL'];
    const values: unknown[] = [];
    if (status && ['pending', 'under_review', 'needs_more_info', 'approved', 'rejected'].includes(status)) {
      values.push(status);
      conds.push(`p.status = $${values.length}`);
    }
    values.push(limit, offset);
    const { rows } = await pool.query(
      `SELECT p.*, u.display_name AS contributor, s.scientific_name,
        (SELECT n.name FROM species_names n WHERE n.species_id = p.species_id
          AND n.is_primary AND n.name_type = 'common' LIMIT 1) AS species_name
       FROM photo_contributions p JOIN users u ON u.id = p.submitted_by
       JOIN species s ON s.id = p.species_id
       WHERE ${conds.join(' AND ')} ORDER BY p.created_at DESC
       LIMIT $${values.length - 1} OFFSET $${values.length}`,
      values,
    );
    res.json({ contributions: rows });
  } catch (err) {
    next(err);
  }
});

contributionsRouter.get('/admin/photo-contributions/:id', authRequired, requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const p = (await pool.query(
      `SELECT p.*, u.display_name AS contributor, u.province AS contributor_province, s.scientific_name
       FROM photo_contributions p JOIN users u ON u.id = p.submitted_by
       JOIN species s ON s.id = p.species_id
       WHERE p.id = $1 AND p.deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!p) {
      res.status(404).json({ error: 'Contribution not found' });
      return;
    }
    res.json({ contribution: p });
  } catch (err) {
    next(err);
  }
});

async function setPhotoStatus(
  req: { user?: { id: string }; ip?: string },
  res: { status: (c: number) => { json: (b: unknown) => void }; json: (b: unknown) => void },
  id: string, status: 'under_review' | 'needs_more_info' | 'approved' | 'rejected', message?: string,
) {
  const p = (await pool.query(`SELECT * FROM photo_contributions WHERE id = $1 AND deleted_at IS NULL`, [id])).rows[0];
  if (!p || ['approved', 'rejected'].includes(p.status)) {
    res.status(404).json({ error: 'Reviewable contribution not found' });
    return;
  }
  await pool.query(
    `UPDATE photo_contributions SET status = $1, review_notes = COALESCE($2, review_notes),
      reviewed_by = $3, reviewed_at = now() WHERE id = $4`,
    [status, message ?? null, req.user!.id, id],
  );
  await moderate(req.user!.id, 'photo_contribution', id, status, message);
  if (status !== 'under_review') {
    const titles = { needs_more_info: 'More information needed', rejected: 'Contribution not approved' } as const;
    await notify(p.submitted_by, `contribution.${status === 'rejected' ? 'rejected' : 'needs_info'}`,
      titles[status as 'needs_more_info' | 'rejected'],
      message ?? `Your photo contribution is now: ${status}.`, 'photo_contribution', id);
  }
  res.json({ ok: true });
}

// Moderator+ may publish PHOTOS (photo verification is moderator-level in this system).
// Idempotent: re-approving returns the existing official photo.
contributionsRouter.post('/admin/photo-contributions/:id/approve', authRequired, requireRole('moderator', 'admin'), async (req, res, next) => {
  const client = await pool.connect();
  try {
    const body = reviewSchema.parse(req.body);
    const p = (await client.query(`SELECT * FROM photo_contributions WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!p) {
      res.status(404).json({ error: 'Contribution not found' });
      return;
    }
    if (p.published_photo_id) {
      const existing = (await client.query(`SELECT * FROM species_photos WHERE id = $1`, [p.published_photo_id])).rows[0];
      res.json({ photo: existing, alreadyPublished: true });
      return;
    }
    if (['approved', 'rejected'].includes(p.status)) {
      res.status(404).json({ error: 'Reviewable contribution not found' });
      return;
    }
    const sp = (await client.query(`SELECT id FROM species WHERE id = $1 AND deleted_at IS NULL`, [p.species_id])).rows[0];
    if (!sp) {
      res.status(404).json({ error: 'Target species no longer exists' });
      return;
    }
    const mapped = p.photo_type === 'other' ? 'whole_tree' : p.photo_type;
    let caption = p.caption ?? 'Community-contributed photo.';
    if (p.photo_type === 'other') caption += ' (category: other)';
    if (p.credit_name) caption += `\nPhoto contributed by ${p.credit_name}.`;
    await client.query('BEGIN');
    try {
      const { rows } = await client.query(
        `INSERT INTO species_photos (species_id, uploaded_by, file_url, photo_type, caption, verification_status, verified_by)
         VALUES ($1,$2,$3,$4,$5,'verified',$6) RETURNING *`,
        [p.species_id, p.submitted_by, p.file_url, mapped, caption, req.user!.id],
      );
      await client.query(
        `UPDATE photo_contributions SET status = 'approved', published_photo_id = $1,
          reviewed_by = $2, reviewed_at = now() WHERE id = $3`,
        [rows[0].id, req.user!.id, p.id],
      );
      await client.query('COMMIT');
      await moderate(req.user!.id, 'photo_contribution', p.id, 'approved', body.message);
      await notify(p.submitted_by, 'contribution.approved', 'Photo contribution approved ✓',
        'Your photo is now part of the official species gallery.', 'photo_contribution', p.id);
      res.status(201).json({ photo: rows[0] });
    } catch (e) {
      await client.query('ROLLBACK');
      throw e;
    }
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  } finally {
    client.release();
  }
});

contributionsRouter.post('/admin/photo-contributions/:id/request-info', authRequired, requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const body = reviewSchema.parse(req.body);
    await setPhotoStatus(req, res, req.params.id, 'needs_more_info', body.message);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

contributionsRouter.post('/admin/photo-contributions/:id/reject', authRequired, requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    const body = reviewSchema.parse(req.body);
    await setPhotoStatus(req, res, req.params.id, 'rejected', body.message);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

contributionsRouter.post('/admin/photo-contributions/:id/review', authRequired, requireRole('moderator', 'admin'), async (req, res, next) => {
  try {
    await setPhotoStatus(req, res, req.params.id, 'under_review');
  } catch (err) {
    next(err);
  }
});
