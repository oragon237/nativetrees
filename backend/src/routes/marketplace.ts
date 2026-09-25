import { Router } from 'express';
import { z } from 'zod';
import multer from 'multer';
import { pool } from '../db/pool';
import { authRequired } from '../middleware/auth';
import { requireRole } from '../middleware/requireRole';
import { saveBuffer } from '../utils/storage';
import { moderate, notify } from '../utils/moderation';
import { awardBadges } from '../utils/reputation';

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 8 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => (file.mimetype.startsWith('image/') ? cb(null, true) : cb(new Error('Only images'))),
});

const createSchema = z.object({
  species_id: z.string().uuid(),
  title: z.string().min(3).max(255),
  material_type: z.enum(['seed', 'seedling', 'sapling']),
  approximate_age: z.string().max(120).nullable().optional(),
  approximate_height_cm: z.number().positive().max(100000).nullable().optional(),
  quantity: z.number().int().min(0).default(1),
  price: z.number().min(0).default(0),
  description: z.string().max(5000).default(''),
  region: z.string().min(1).max(120),
  province: z.string().min(1).max(120),
  municipality: z.string().max(120).nullable().optional(),
  contact_method: z.enum(['phone', 'email', 'other']).default('other'),
  contact_value: z.string().min(1).max(255),
});

function publicRow(r: Record<string, unknown>, authed: boolean) {
  // Privacy: seller contact is only shown to logged-in users.
  if (!authed) {
    const { contact_value: _c, ...rest } = r;
    return rest;
  }
  return r;
}

export const marketplaceRouter = Router();
marketplaceRouter.use(authRequired);

// GET /api/v1/marketplace (active only; filters: species_id, province, material_type, max_price)
marketplaceRouter.get('/', async (req, res, next) => {
  try {
    const limit = Math.min(parseInt((req.query.limit as string) ?? '20', 10) || 20, 100);
    const offset = parseInt((req.query.offset as string) ?? '0', 10) || 0;
    const conds = [`l.status = 'active'`, `l.deleted_at IS NULL`];
    const values: unknown[] = [];
    const q = (v: string | undefined) => (typeof v === 'string' && v.trim() ? v.trim() : '');
    if (q(req.query.species_id as string)) {
      values.push(q(req.query.species_id as string));
      conds.push(`l.species_id = $${values.length}`);
    }
    if (q(req.query.province as string)) {
      values.push(q(req.query.province as string));
      conds.push(`l.province ILIKE $${values.length}`);
    }
    if (q(req.query.material_type as string)) {
      values.push(q(req.query.material_type as string));
      conds.push(`l.material_type = $${values.length}`);
    }
    if (q(req.query.max_price as string)) {
      values.push(Number(q(req.query.max_price as string)));
      conds.push(`l.price <= $${values.length}`);
    }
    values.push(limit, offset);
    const { rows } = await pool.query(
      `SELECT l.*, u.display_name AS seller_name,
        EXISTS(SELECT 1 FROM nursery_verifications n WHERE n.user_id = l.seller_id AND n.status = 'verified') AS seller_verified,
        (SELECT n.name FROM species_names n WHERE n.species_id = l.species_id
          AND n.is_primary AND n.name_type = 'common' LIMIT 1) AS species_name,
        (SELECT p.file_url FROM listing_photos p WHERE p.listing_id = l.id ORDER BY p.sort_order LIMIT 1) AS cover_photo,
        s.scientific_name
       FROM marketplace_listings l JOIN users u ON u.id = l.seller_id
       JOIN species s ON s.id = l.species_id
       WHERE ${conds.join(' AND ')} ORDER BY l.created_at DESC, l.id
       LIMIT $${values.length - 1} OFFSET $${values.length}`,
      values,
    );
    res.json({ listings: rows.map((r) => publicRow(r, true)) });
  } catch (err) {
    next(err);
  }
});

// GET /api/v1/marketplace/mine
marketplaceRouter.get('/mine', async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      `SELECT l.*, (SELECT n.name FROM species_names n WHERE n.species_id = l.species_id
        AND n.is_primary AND n.name_type = 'common' LIMIT 1) AS species_name
       FROM marketplace_listings l WHERE l.seller_id = $1 AND l.deleted_at IS NULL ORDER BY l.created_at DESC`,
      [req.user!.id],
    );
    res.json({ listings: rows });
  } catch (err) {
    next(err);
  }
});

// GET /api/v1/marketplace/:id
marketplaceRouter.get('/:id', async (req, res, next) => {
  try {
    const l = (await pool.query(
      `SELECT l.*, u.display_name AS seller_name, s.scientific_name,
        EXISTS(SELECT 1 FROM nursery_verifications n WHERE n.user_id = l.seller_id AND n.status = 'verified') AS seller_verified,
        (SELECT n.name FROM species_names n WHERE n.species_id = l.species_id
          AND n.is_primary AND n.name_type = 'common' LIMIT 1) AS species_name
       FROM marketplace_listings l JOIN users u ON u.id = l.seller_id
       JOIN species s ON s.id = l.species_id WHERE l.id = $1 AND l.deleted_at IS NULL`,
      [req.params.id],
    )).rows[0];
    if (!l) {
      res.status(404).json({ error: 'Listing not found' });
      return;
    }
    const isMod = req.user!.roles.includes('moderator') || req.user!.roles.includes('admin');
    if (l.status !== 'active' && l.seller_id !== req.user!.id && !isMod) {
      res.status(404).json({ error: 'Listing not found' });
      return;
    }
    const photos = (await pool.query(`SELECT * FROM listing_photos WHERE listing_id = $1 ORDER BY sort_order`, [l.id])).rows;
    res.json({ listing: publicRow(l, !!req.user), photos });
  } catch (err) {
    next(err);
  }
});

// POST /api/v1/marketplace (creates pending listing; species must exist)
marketplaceRouter.post('/', async (req, res, next) => {
  try {
    const body = createSchema.parse(req.body);
    const sp = (await pool.query(
      `SELECT id FROM species WHERE id = $1 AND verification_status = 'verified' AND deleted_at IS NULL`, [body.species_id])).rows[0];
    if (!sp) {
      res.status(404).json({ error: 'Species not found. If the species is missing, request it first.' });
      return;
    }
    const cols = ['seller_id', 'species_id', 'title', 'material_type', 'approximate_age', 'approximate_height_cm',
      'quantity', 'price', 'description', 'region', 'province', 'municipality', 'contact_method', 'contact_value'];
    const vals = [req.user!.id, body.species_id, body.title.trim(), body.material_type, body.approximate_age ?? null,
      body.approximate_height_cm ?? null, body.quantity, body.price, body.description,
      body.region.trim(), body.province.trim(), body.municipality ?? null, body.contact_method, body.contact_value.trim()];
    const { rows } = await pool.query(
      `INSERT INTO marketplace_listings (${cols.join(',')}) VALUES (${cols.map((_, i) => `$${i + 1}`).join(',')}) RETURNING *`, vals);
    res.status(201).json({ listing: rows[0] });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// POST /api/v1/marketplace/:id/photos (owner or mod+)
marketplaceRouter.post('/:id/photos', upload.single('photo'), async (req, res, next) => {
  try {
    const l = (await pool.query(`SELECT * FROM marketplace_listings WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
    if (!l) {
      res.status(404).json({ error: 'Listing not found' });
      return;
    }
    const isMod = req.user!.roles.includes('moderator') || req.user!.roles.includes('admin');
    if (l.seller_id !== req.user!.id && !isMod) {
      res.status(403).json({ error: 'Not your listing' });
      return;
    }
    if (!req.file) {
      res.status(400).json({ error: 'Missing image file field "photo"' });
      return;
    }
    const count = (await pool.query(`SELECT count(*)::int AS c FROM listing_photos WHERE listing_id = $1`, [l.id])).rows[0].c as number;
    const stored = await saveBuffer(req.file.buffer, { prefix: `listings/${l.id}`, filename: req.file.originalname || 'photo.jpg' });
    const { rows } = await pool.query(
      `INSERT INTO listing_photos (listing_id, file_url, sort_order) VALUES ($1,$2,$3) RETURNING *`, [l.id, stored.url, count]);
    res.status(201).json({ photo: rows[0] });
  } catch (err) {
    next(err);
  }
});

// POST /api/v1/marketplace/:id/sold-out (owner)
marketplaceRouter.post('/:id/sold-out', async (req, res, next) => {
  try {
    const { rowCount } = await pool.query(
      `UPDATE marketplace_listings SET status = 'sold_out' WHERE id = $1 AND seller_id = $2 AND deleted_at IS NULL`,
      [req.params.id, req.user!.id]);
    if (!rowCount) {
      res.status(404).json({ error: 'Listing not found' });
      return;
    }
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

// Moderation: approve / reject / request-changes
for (const [path, status] of [['approve', 'active'], ['reject', 'rejected'], ['request-changes', 'draft']] as const) {
  marketplaceRouter.post(`/:id/${path}`, requireRole('moderator', 'admin'), async (req, res, next) => {
    try {
      const schema = z.object({ reason: z.string().max(2000).optional() });
      const body = schema.parse(req.body);
      const l = (await pool.query(`SELECT * FROM marketplace_listings WHERE id = $1 AND deleted_at IS NULL`, [req.params.id])).rows[0];
      if (!l) {
        res.status(404).json({ error: 'Listing not found' });
        return;
      }
      await pool.query(`UPDATE marketplace_listings SET status = $1, reviewed_by = $2 WHERE id = $3`, [status, req.user!.id, l.id]);
      await moderate(req.user!.id, 'marketplace_listing', l.id, status, body.reason);
      const titles: Record<string, string> = {
        active: 'Marketplace listing approved 🛒',
        rejected: 'Marketplace listing not approved',
        draft: 'Changes requested for your listing',
      };
      await notify(l.seller_id, `listing.${status === 'draft' ? 'changes_requested' : status}`, titles[status],
        body.reason ?? `Your listing "${l.title}" is now: ${status}.`, 'marketplace_listing', l.id);
      await awardBadges(l.seller_id);
      if (status === 'active') {
        const subs = await pool.query(
          `SELECT DISTINCT a.user_id FROM availability_alerts a
           WHERE a.species_id = $1 AND (a.province = '' OR a.province ILIKE $2) AND a.user_id <> $3`,
          [l.species_id, l.province, l.seller_id]);
        for (const s of subs.rows) {
          await notify(s.user_id, 'listing.alert', 'Seedlings available 🌱',
            `"${l.title}" is now available in ${l.province}.`, 'marketplace_listing', l.id);
        }
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
