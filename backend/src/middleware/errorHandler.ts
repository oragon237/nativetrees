import type { NextFunction, Request, Response } from 'express';

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export function errorHandler(err: unknown, _req: Request, res: Response, _next: NextFunction) {
  const e = err as { type?: string; status?: number };
  if (e?.type === 'entity.parse.failed' || e?.status === 400) {
    res.status(400).json({ error: 'Malformed JSON body' });
    return;
  }
  console.error('[api] error', err);
  res.status(500).json({ error: 'Internal server error' });
}
