import fs from 'node:fs';
import path from 'node:path';
import { env } from '../config/env';

/**
 * Phase 1 storage abstraction.
 * V1 spec (§42): DB stores file URL/key, files live in object storage.
 * Local driver implements the same interface S3 will use later,
 * so callers never touch the filesystem directly.
 */
export interface StoredFile {
  key: string;
  url: string;
}

export async function saveBuffer(
  buffer: Buffer,
  opts: { prefix: string; filename: string; contentType?: string },
): Promise<StoredFile> {
  if (env.storageDriver !== 'local') {
    throw new Error(
      `Storage driver "${env.storageDriver}" not configured yet. Phase 1 supports "local" only.`,
    );
  }
  const dir = path.join(process.cwd(), env.uploadDir, opts.prefix);
  fs.mkdirSync(dir, { recursive: true });
  const safe = `${Date.now()}-${opts.filename.replace(/[^a-zA-Z0-9._-]/g, '_')}`;
  const full = path.join(dir, safe);
  fs.writeFileSync(full, buffer);
  const key = `${opts.prefix}/${safe}`;
  return { key, url: `/uploads/${key}` };
}
