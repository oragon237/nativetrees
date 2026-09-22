import crypto from 'node:crypto';
import jwt from 'jsonwebtoken';
import { env } from '../config/env';

export interface AccessPayload {
  sub: string; // user id
  roles: string[];
}

export function signAccessToken(payload: AccessPayload): string {
  return jwt.sign(payload, env.jwtSecret, {
    expiresIn: env.jwtExpiresIn as jwt.SignOptions['expiresIn'],
  });
}

export function verifyAccessToken(token: string): AccessPayload {
  return jwt.verify(token, env.jwtSecret) as AccessPayload;
}

/** Generate a one-time raw token + sha256 hash (store the hash). */
export function generateOpaqueToken(): { raw: string; hash: string } {
  const raw = crypto.randomBytes(32).toString('hex');
  const hash = crypto.createHash('sha256').update(raw).digest('hex');
  return { raw, hash };
}

export function hashOpaqueToken(raw: string): string {
  return crypto.createHash('sha256').update(raw).digest('hex');
}
