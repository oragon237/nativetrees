import fs from 'node:fs';
import path from 'node:path';
import { pool } from './pool';

const dir = path.join(__dirname, '..', '..', 'migrations');

async function main() {
  await pool.query(
    `CREATE TABLE IF NOT EXISTS schema_migrations (
       filename VARCHAR(255) PRIMARY KEY,
       applied_at TIMESTAMPTZ NOT NULL DEFAULT now()
     )`,
  );
  const applied = new Set(
    (await pool.query(`SELECT filename FROM schema_migrations`)).rows.map(
      (r) => r.filename as string,
    ),
  );
  const files = fs
    .readdirSync(dir)
    .filter((f) => f.endsWith('.sql'))
    .sort();
  for (const file of files) {
    if (applied.has(file)) {
      console.log(`[migrate] skipping ${file} (already applied)`);
      continue;
    }
    const sql = fs.readFileSync(path.join(dir, file), 'utf8');
    console.log(`[migrate] applying ${file} ...`);
    await pool.query('BEGIN');
    try {
      await pool.query(sql);
      await pool.query(`INSERT INTO schema_migrations (filename) VALUES ($1)`, [file]);
      await pool.query('COMMIT');
      console.log(`[migrate] applied ${file}`);
    } catch (err) {
      await pool.query('ROLLBACK');
      throw err;
    }
  }
  await pool.end();
  console.log('[migrate] done');
}

main().catch((err) => {
  console.error('[migrate] failed', err);
  process.exit(1);
});
