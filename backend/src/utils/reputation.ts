import { pool } from '../db/pool';

/** Reputation & badges (V2). Thresholds evaluated after contribution events. */
export async function awardBadges(userId: string): Promise<string[]> {
  const awarded: string[] = [];
  const grant = async (slug: string, ok: boolean) => {
    if (!ok) return;
    const r = await pool.query(
      `INSERT INTO user_badges (user_id, badge_id)
       SELECT $1, id FROM badges WHERE slug = $2
       ON CONFLICT DO NOTHING RETURNING badge_id`,
      [userId, slug],
    );
    if (r.rowCount) awarded.push(slug);
  };
  const count = async (sql: string) =>
    (await pool.query(sql, [userId])).rows[0].c as number;

  await grant('first-observation',
    (await count(`SELECT count(*)::int AS c FROM observations WHERE user_id = $1 AND deleted_at IS NULL`)) >= 1);
  await grant('seasoned-observer',
    (await count(`SELECT count(*)::int AS c FROM observations WHERE user_id = $1 AND status = 'approved'`)) >= 5);
  await grant('tree-identifier',
    (await count(`SELECT count(*)::int AS c FROM identification_suggestions WHERE suggested_by = $1`)) >= 3);
  await grant('seed-sharer',
    (await count(`SELECT count(*)::int AS c FROM marketplace_listings WHERE seller_id = $1 AND status IN ('active','sold_out')`)) >= 1);
  await grant('knowledge-keeper',
    (await count(`SELECT count(*)::int AS c FROM correction_requests WHERE submitted_by = $1 AND status = 'approved'`)) >= 1);
  return awarded;
}

export async function reputationFor(userId: string) {
  const { rows } = await pool.query(
    `SELECT
      (SELECT count(*)::int FROM observations WHERE user_id = $1 AND status = 'approved') AS approved_observations,
      (SELECT count(*)::int FROM identification_suggestions WHERE suggested_by = $1) AS suggestions,
      (SELECT count(*)::int FROM correction_requests WHERE submitted_by = $1 AND status = 'approved') AS corrections_approved,
      (SELECT count(*)::int FROM marketplace_listings WHERE seller_id = $1 AND status IN ('active','sold_out')) AS listings_approved`,
    [userId],
  );
  const r = rows[0];
  const score = r.approved_observations * 10 + r.suggestions * 5 + r.corrections_approved * 15 + r.listings_approved * 5;
  const badges = (await pool.query(
    `SELECT b.slug, b.name, b.description, b.icon, ub.awarded_at FROM user_badges ub
     JOIN badges b ON b.id = ub.badge_id WHERE ub.user_id = $1 ORDER BY ub.awarded_at`,
    [userId],
  )).rows;
  return { ...r, score, badges };
}
