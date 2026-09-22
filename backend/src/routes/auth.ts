import { Router } from 'express';
import { z } from 'zod';
import { pool } from '../db/pool';
import { hashPassword, verifyPassword } from '../utils/password';
import { generateOpaqueToken, hashOpaqueToken, signAccessToken } from '../utils/jwt';
import { sendEmail } from '../utils/email';
import { authRequired } from '../middleware/auth';

export const authRouter = Router();

const registerSchema = z.object({
  email: z.string().email().max(320),
  password: z.string().min(8).max(128),
  display_name: z.string().min(2).max(120),
  region: z.string().max(120).optional(),
  province: z.string().max(120).optional(),
});

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1),
});

/** Implied roles: admin acts as moderator+user, moderator as user. */
function expandRoles(roles: string[]): string[] {
  const set = new Set(roles);
  if (set.has('admin')) {
    set.add('moderator');
    set.add('user');
  }
  if (set.has('moderator')) set.add('user');
  if (set.size === 0) set.add('user');
  return [...set];
}

async function rolesFor(userId: string): Promise<string[]> {
  const { rows } = await pool.query(
    `SELECT r.name FROM user_roles ur JOIN roles r ON r.id = ur.role_id WHERE ur.user_id = $1`,
    [userId],
  );
  return expandRoles(rows.map((r) => r.name as string));
}

function publicUser(row: Record<string, unknown>) {
  return {
    id: row.id,
    email: row.email,
    display_name: row.display_name,
    profile_photo_url: row.profile_photo_url,
    bio: row.bio,
    region: row.region,
    province: row.province,
    municipality: row.municipality,
    email_verified_at: row.email_verified_at,
    account_status: row.account_status,
    created_at: row.created_at,
  };
}

// POST /api/v1/auth/register
authRouter.post('/register', async (req, res, next) => {
  try {
    const body = registerSchema.parse(req.body);
    const email = body.email.toLowerCase().trim();
    const exists = await pool.query(`SELECT id FROM users WHERE email = $1`, [email]);
    if (exists.rowCount) {
      res.status(409).json({ error: 'Email already registered' });
      return;
    }
    const password_hash = await hashPassword(body.password);
    const client = await pool.connect();
    try {
      await client.query('BEGIN');
      const { rows } = await client.query(
        `INSERT INTO users (email, password_hash, display_name, region, province)
         VALUES ($1,$2,$3,$4,$5) RETURNING *`,
        [email, password_hash, body.display_name.trim(), body.region ?? null, body.province ?? null],
      );
      const user = rows[0];
      await client.query(
        `INSERT INTO user_roles (user_id, role_id) SELECT $1, id FROM roles WHERE name = 'user'
         ON CONFLICT DO NOTHING`,
        [user.id],
      );
      const { raw, hash } = generateOpaqueToken();
      await client.query(
        `INSERT INTO auth_tokens (user_id, type, token_hash, expires_at)
         VALUES ($1,'email_verify',$2, now() + interval '7 days')`,
        [user.id, hash],
      );
      await client.query('COMMIT');
      await sendEmail(
        email,
        'Verify your Katutubong Puno account',
        `Welcome! Verify your email with this token (valid 7 days):\n\n${raw}\n\nPOST /api/v1/auth/verify-email { "token": "<token>" }`,
      );
      res.status(201).json({
        user: publicUser(user),
        // Dev-only convenience so Phase 1 can be tested without an SMTP server.
        ...(process.env.NODE_ENV !== 'production' ? { emailVerificationToken: raw } : {}),
      });
    } catch (e) {
      await client.query('ROLLBACK');
      throw e;
    } finally {
      client.release();
    }
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// POST /api/v1/auth/login
authRouter.post('/login', async (req, res, next) => {
  try {
    const body = loginSchema.parse(req.body);
    const email = body.email.toLowerCase().trim();
    const { rows } = await pool.query(`SELECT * FROM users WHERE email = $1 AND deleted_at IS NULL`, [
      email,
    ]);
    const user = rows[0];
    if (!user || !(await verifyPassword(body.password, user.password_hash))) {
      res.status(401).json({ error: 'Invalid email or password' });
      return;
    }
    if (user.account_status !== 'active') {
      res.status(403).json({ error: `Account is ${user.account_status}` });
      return;
    }
    await pool.query(`UPDATE users SET last_login_at = now() WHERE id = $1`, [user.id]);
    const roles = await rolesFor(user.id);
    const token = signAccessToken({ sub: user.id, roles });
    res.json({ token, user: { ...publicUser(user), roles } });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// POST /api/v1/auth/verify-email
authRouter.post('/verify-email', async (req, res, next) => {
  try {
    const schema = z.object({ token: z.string().min(10) });
    const { token } = schema.parse(req.body);
    const hash = hashOpaqueToken(token);
    const { rows } = await pool.query(
      `SELECT * FROM auth_tokens WHERE token_hash = $1 AND type = 'email_verify'
       AND used_at IS NULL AND expires_at > now()`,
      [hash],
    );
    const record = rows[0];
    if (!record) {
      res.status(400).json({ error: 'Invalid or expired verification token' });
      return;
    }
    await pool.query(`UPDATE auth_tokens SET used_at = now() WHERE id = $1`, [record.id]);
    await pool.query(`UPDATE users SET email_verified_at = now() WHERE id = $1`, [record.user_id]);
    res.json({ ok: true });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// POST /api/v1/auth/password-reset-request
authRouter.post('/password-reset-request', async (req, res, next) => {
  try {
    const schema = z.object({ email: z.string().email() });
    const { email } = schema.parse(req.body);
    const { rows } = await pool.query(`SELECT id FROM users WHERE email = $1 AND deleted_at IS NULL`, [
      email.toLowerCase().trim(),
    ]);
    // Always return ok to avoid account enumeration.
    if (rows[0]) {
      const { raw, hash } = generateOpaqueToken();
      await pool.query(
        `INSERT INTO auth_tokens (user_id, type, token_hash, expires_at)
         VALUES ($1,'password_reset',$2, now() + interval '1 hour')`,
        [rows[0].id, hash],
      );
      await sendEmail(
        email,
        'Reset your Katutubong Puno password',
        `Use this token within 1 hour:\n\n${raw}\n\nPOST /api/v1/auth/password-reset-confirm { "token": "<token>", "newPassword": "..." }`,
      );
      if (process.env.NODE_ENV !== 'production') {
        res.json({ ok: true, passwordResetToken: raw });
        return;
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

// POST /api/v1/auth/password-reset-confirm
authRouter.post('/password-reset-confirm', async (req, res, next) => {
  try {
    const schema = z.object({ token: z.string().min(10), newPassword: z.string().min(8).max(128) });
    const { token, newPassword } = schema.parse(req.body);
    const hash = hashOpaqueToken(token);
    const { rows } = await pool.query(
      `SELECT * FROM auth_tokens WHERE token_hash = $1 AND type = 'password_reset'
       AND used_at IS NULL AND expires_at > now()`,
      [hash],
    );
    const record = rows[0];
    if (!record) {
      res.status(400).json({ error: 'Invalid or expired reset token' });
      return;
    }
    await pool.query(`UPDATE auth_tokens SET used_at = now() WHERE id = $1`, [record.id]);
    await pool.query(`UPDATE users SET password_hash = $1 WHERE id = $2`, [
      await hashPassword(newPassword),
      record.user_id,
    ]);
    res.json({ ok: true });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});

// POST /api/v1/auth/password — change password while logged in.
authRouter.post('/password', authRequired, async (req, res, next) => {
  try {
    const schema = z.object({
      currentPassword: z.string().min(1),
      newPassword: z.string().min(8).max(128),
    });
    const body = schema.parse(req.body);
    const { rows } = await pool.query(`SELECT * FROM users WHERE id = $1 AND deleted_at IS NULL`, [
      req.user!.id,
    ]);
    const user = rows[0];
    if (!user || !(await verifyPassword(body.currentPassword, user.password_hash))) {
      res.status(401).json({ error: 'Current password is incorrect' });
      return;
    }
    await pool.query(`UPDATE users SET password_hash = $1 WHERE id = $2`, [
      await hashPassword(body.newPassword),
      user.id,
    ]);
    res.json({ ok: true });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Validation failed', details: err.flatten() });
      return;
    }
    next(err);
  }
});
authRouter.get('/me', authRequired, async (req, res, next) => {
  try {
    const { rows } = await pool.query(`SELECT * FROM users WHERE id = $1 AND deleted_at IS NULL`, [
      req.user!.id,
    ]);
    if (!rows[0]) {
      res.status(404).json({ error: 'User not found' });
      return;
    }
    res.json({ user: { ...publicUser(rows[0]), roles: await rolesFor(rows[0].id) } });
  } catch (err) {
    next(err);
  }
});

export { rolesFor };
