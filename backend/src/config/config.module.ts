// backend/src/config/config.module.ts

import { Module, Global } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';

import { ConfigSchema } from './config.schema';
import { EnvLoader } from './env.loader';

/**
 * Global Config Module
 * Loaded once, frozen, and shared application-wide.
 */
@Global()
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [EnvLoader],
      validationSchema: ConfigSchema,
      cache: true,
      expandVariables: true,
    }),
  ],
})
export class AppConfigModule {}
