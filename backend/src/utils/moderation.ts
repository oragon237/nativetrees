import { pool } from '../db/pool';

export async function notify(
  userId: string,
  type: string,
  title: string,
  message: string,
  entityType?: string,
  entityId?: string,
): Promise<void> {
  if (!userId) return;
  await pool.query(
    `INSERT INTO notifications (user_id, type, title, message, entity_type, entity_id)
     VALUES ($1,$2,$3,$4,$5,$6)`,
    [userId, type, title, message, entityType ?? null, entityId ?? null],
  );
}

export async function moderate(
  moderatorId: string,
  entityType: string,
  entityId: string,
  action: string,
  reason?: string | null,
): Promise<void> {
  await pool.query(
    `INSERT INTO moderation_actions (moderator_id, entity_type, entity_id, action, reason)
     VALUES ($1,$2,$3,$4,$5)`,
    [moderatorId, entityType, entityId, action, reason ?? null],
  );
}

/**
 * Location privacy (§21/§65): exact coordinates are never public by default.
 * - owner/moderator/admin viewer -> full record
 * - 'hidden' -> no coordinates, no locality below province
 * - 'municipality' -> locality only, no coordinates
 * - 'approximate' -> coordinates rounded to ~1km grid
 * - 'exact_private' -> treated as hidden for public viewers
 */
export function sanitizeLocation<T extends Record<string, unknown>>(
  row: T,
  viewer: { id: string; roles: string[] } | null,
  ownerId: string,
): T {
  const privileged =
    viewer && (viewer.id === ownerId || viewer.roles.includes('moderator') || viewer.roles.includes('admin'));
  if (privileged) return row;
  const precision = row.location_precision as string;
  const out = { ...(row as Record<string, unknown>) };
  if (precision === 'hidden' || precision === 'exact_private') {
    out.latitude = null;
    out.longitude = null;
    out.municipality = null;
  } else if (precision === 'municipality') {
    out.latitude = null;
    out.longitude = null;
  } else if (precision === 'approximate') {
    const round = (v: unknown) => (typeof v === 'number' || typeof v === 'string' ? Math.round(Number(v) * 100) / 100 : null);
    out.latitude = round(out.latitude);
    out.longitude = round(out.longitude);
  }
  return out as T;
}
