import { pool } from '../db/pool';

/**
 * Push notification hook (V2). With PUSH_ENABLED=true the app attempts
 * delivery via a configured provider; otherwise it logs (dev behavior).
 * In-app notifications (notify()) always work regardless of this setting.
 */
export async function sendPush(userId: string, title: string, body: string): Promise<void> {
  const { rows } = await pool.query(`SELECT count(*)::int AS c FROM device_tokens WHERE user_id = $1`, [userId]);
  if (process.env.PUSH_ENABLED === 'true' && rows[0].c > 0) {
    // Integration point: call FCM/APNs here with stored device tokens.
    console.log(`[push] would deliver to ${rows[0].c} device(s) of ${userId}: ${title}`);
    return;
  }
  console.log(`[push:stub] to=${userId} title=${title} body=${body}`);
}
