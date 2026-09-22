import 'dotenv/config';

function required(name: string, fallback?: string): string {
  const v = process.env[name] ?? fallback;
  if (!v) throw new Error(`Missing env var ${name}. See .env.example`);
  return v;
}

export const env = {
  port: parseInt(process.env.PORT ?? '4000', 10),
  databaseUrl: required('DATABASE_URL'),
  jwtSecret: required('JWT_SECRET'),
  jwtExpiresIn: process.env.JWT_EXPIRES_IN ?? '7d',
  uploadDir: process.env.UPLOAD_DIR ?? 'uploads',
  storageDriver: process.env.STORAGE_DRIVER ?? 'local',
  frontendUrl: process.env.FRONTEND_URL ?? 'http://localhost:5173',
};
