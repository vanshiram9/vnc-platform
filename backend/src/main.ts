// ============================================================
// VNC PLATFORM — MAIN BOOTSTRAP
// Phase-1 CORE (COMPILE-SAFE)
// ============================================================

import 'reflect-metadata';

import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Basic CORS (Phase-1)
  app.enableCors({
    origin: '*',
    methods: ['GET', 'POST'],
  });

  const port = process.env.PORT || 3000;

  await app.listen(port);

  // eslint-disable-next-line no-console
  console.log(
    `VNC backend running on port ${port}`,
  );
}

bootstrap();
