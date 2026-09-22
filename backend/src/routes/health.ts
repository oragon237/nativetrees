import { Router } from 'express';
import { pool } from '../db/pool';

export const healthRouter = Router();

healthRouter.get('/', async (_req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ ok: true, service: 'katutubong-puno-api', phase: 1 });
  } catch {
    res.status(503).json({ ok: false, db: 'unreachable' });
  }
});
