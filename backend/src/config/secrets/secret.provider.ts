// backend/src/config/secrets/secret.provider.ts

import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

/**
 * SecretProvider
 * Central, read-only access layer for sensitive values.
 * All secrets must flow through this provider.
 */
@Injectable()
export class SecretProvider {
  constructor(private readonly config: ConfigService) {}

  /**
   * Generic secret getter
   * Throws if secret is missing or empty.
   */
  get(name: string): string {
    const value = this.config.get<string>(name);

    if (!value || value.trim().length === 0) {
      throw new Error(`SECRET_MISSING: ${name}`);
    }

    return value;
  }

  /**
   * JWT secret accessor
   */
  jwtSecret(): string {
    return this.get('JWT_SECRET');
  }

  /**
   * Database URL accessor
   */
  databaseUrl(): string {
    return this.get('DATABASE_URL');
  }

  /**
   * Optional external provider keys
   * Returns undefined if not configured
   */
  optional(name: string): string | undefined {
    const value = this.config.get<string>(name);
    return value && value.trim().length > 0 ? value : undefined;
  }
}
