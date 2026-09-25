import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import morgan from 'morgan';
import rateLimit from 'express-rate-limit';
import path from 'node:path';
import { env } from './config/env';
import { healthRouter } from './routes/health';
import { authRouter } from './routes/auth';
import { usersRouter } from './routes/users';
import { adminRouter } from './routes/admin';
import { adminSpeciesRouter } from './routes/adminSpecies';
import { catalogRouter, recommendationsRouter, speciesRouter } from './routes/species';
import { favoritesRouter } from './routes/favorites';
import { observationsRouter } from './routes/observations';
import { identificationsRouter } from './routes/identifications';
import { communityRouter } from './routes/community';
import { marketplaceRouter } from './routes/marketplace';
import { notificationsRouter, reportsRouter, safetyAdminRouter } from './routes/safety';
import { v2Router } from './routes/v2';
import { v3Router } from './routes/v3';
import { contributionsRouter } from './routes/contributions';
import { errorHandler } from './middleware/errorHandler';

export function createApp() {
  const app = express();
  app.set('trust proxy', 1);
  app.use(helmet({ crossOriginResourcePolicy: { policy: 'cross-origin' } }));
  // Beta/prod: set CORS_ORIGINS=https://admin.example.com,https://app.example.com
  // (comma-separated). Unset = open (local development only).
  const origins = (process.env.CORS_ORIGINS ?? '')
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean);
  app.use(cors(origins.length ? { origin: origins } : undefined));
  app.use(morgan('dev'));
  app.use(express.json({ limit: '1mb' }));

  const authLimiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 60,
    standardHeaders: 'draft-7',
    legacyHeaders: false,
  });

  app.use('/uploads', express.static(path.join(process.cwd(), env.uploadDir)));
  app.use('/api/v1/health', healthRouter);
  app.use('/api/v1/auth', authLimiter, authRouter);
  app.use('/api/v1/users', usersRouter);
  app.use('/api/v1/species', speciesRouter);
  app.use('/api/v1/recommendations', recommendationsRouter);
  app.use('/api/v1', catalogRouter);
  app.use('/api/v1/favorites', favoritesRouter);
  app.use('/api/v1/observations', observationsRouter);
  app.use('/api/v1/identifications', identificationsRouter);
  app.use('/api/v1', communityRouter);
  app.use('/api/v1/marketplace', marketplaceRouter);
  app.use('/api/v1/reports', reportsRouter);
  app.use('/api/v1/notifications', notificationsRouter);
  app.use('/api/v1/admin', safetyAdminRouter);
  app.use('/api/v1', v2Router);
  app.use('/api/v1', v3Router);
  app.use('/api/v1', contributionsRouter);
  app.use('/api/v1/admin', adminRouter);
  app.use('/api/v1/admin', adminSpeciesRouter);

  app.use((_req, res) => res.status(404).json({ error: 'Not found' }));
  app.use(errorHandler);
  return app;
}
