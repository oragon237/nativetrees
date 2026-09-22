import type { NextFunction, Request, Response } from 'express';
import { verifyAccessToken } from '../utils/jwt';

export interface AuthUser {
  id: string;
  roles: string[];
}

declare global {
  namespace Express {
    interface Request {
      user?: AuthUser;
    }
  }
}

export function authRequired(req: Request, res: Response, next: NextFunction) {
  const header = req.headers.authorization ?? '';
  const [scheme, token] = header.split(' ');
  if (scheme !== 'Bearer' || !token) {
    res.status(401).json({ error: 'Missing Bearer token' });
    return;
  }
  try {
    const payload = verifyAccessToken(token);
    req.user = { id: payload.sub, roles: payload.roles ?? [] };
    next();
  } catch {
    res.status(401).json({ error: 'Invalid or expired token' });
  }
}
