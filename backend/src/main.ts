// backend/src/main.ts

import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import helmet from 'helmet';
import compression from 'compression';

import { bootstrapApplication } from './bootstrap/app.bootstrap';
import { LifecycleManager } from './bootstrap/lifecycle.manager';

async function bootstrap() {
  /**
   * Create NestJS Application
   */
  const app = await NestFactory.create(AppModule, {
    bufferLogs: true,
  });

  /**
   * Global Security Middlewares
   */
  app.use(helmet());
  app.use(compression());

  /**
   * Global Validation (DTO level hard validation)
   */
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  /**
   * Config Service (env driven)
   */
  const configService = app.get(ConfigService);

  const PORT = configService.get<number>('PORT') || 3000;
  const NODE_ENV = configService.get<string>('NODE_ENV') || 'development';

  /**
   * Bootstrap Self-Tests, Feature Flags, Risk Gates
   * (Delegated to bootstrap layer — no logic leak here)
   */
  await bootstrapApplication(app);

  /**
   * Lifecycle Manager
   * Handles:
   * - graceful shutdown
   * - signal trapping
   * - forensic snapshot hooks
   */
  LifecycleManager.attach(app);

  /**
   * Start HTTP Server
   */
  await app.listen(PORT);

  // Explicit log (audit friendly)
  // eslint-disable-next-line no-console
  console.log(
    `[VNC PLATFORM] Backend started | env=${NODE_ENV} | port=${PORT}`,
  );
}

/**
 * Fatal-level protection
 * Any unhandled error freezes startup (no silent boot)
 */
bootstrap().catch((err) => {
  // eslint-disable-next-line no-console
  console.error('[VNC PLATFORM] FATAL BOOT ERROR', err);
  process.exit(1);
});
