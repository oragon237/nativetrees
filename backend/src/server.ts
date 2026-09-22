import { createApp } from './app';
import { env } from './config/env';
import { pool } from './db/pool';

async function main() {
  await pool.query('SELECT 1');
  console.log('[db] connected');
  const app = createApp();
  app.listen(env.port, () => {
    console.log(`[api] Katutubong Puno Phase 1 listening on http://localhost:${env.port}`);
  });
}

main().catch((err) => {
  console.error('[api] failed to start', err);
  process.exit(1);
});
