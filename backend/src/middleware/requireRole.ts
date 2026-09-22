import type { NextFunction, Request, Response } from 'express';

/**
 * Tokens issued at login already carry expanded roles
 * (admin => admin+moderator+user, moderator => moderator+user),
 * so a simple membership check is sufficient and predictable.
 */
export function requireRole(...allowed: string[]) {
  return (req: Request, res: Response, next: NextFunction) => {
    const roles = req.user?.roles ?? [];
    if (allowed.some((a) => roles.includes(a))) {
      next();
      return;
    }
    res.status(403).json({ error: 'Forbidden: insufficient role' });
  };
}

export async function writeAudit(
  query: (text: string, params: unknown[]) => Promise<unknown>,
  entry: {
    userId?: string | null;
    action: string;
    entityType: string;
    entityId?: string | null;
    oldValues?: unknown;
    newValues?: unknown;
    ip?: string | null;
  },
) {
  await query(
    `INSERT INTO audit_logs (user_id, action, entity_type, entity_id, old_values, new_values, ip_address)
     VALUES ($1,$2,$3,$4,$5,$6,$7)`,
    [
      entry.userId ?? null,
      entry.action,
      entry.entityType,
      entry.entityId ?? null,
      entry.oldValues ? JSON.stringify(entry.oldValues) : null,
      entry.newValues ? JSON.stringify(entry.newValues) : null,
      entry.ip ?? null,
    ],
  );
}
