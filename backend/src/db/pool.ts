import { Pool } from 'pg';
import { env } from '../config/env';

export const pool = new Pool({
  connectionString: env.databaseUrl,
  // Set PG_SSL=true for managed/hosted Postgres (Neon, Supabase, Docker TLS).
  // Same-machine VPS installs use plain localhost connections (PG_SSL unset).
  ssl: process.env.PG_SSL === 'true' ? { rejectUnauthorized: false } : undefined,
});

pool.on('error', (err) => {
  console.error('[db] pool error', err);
});
