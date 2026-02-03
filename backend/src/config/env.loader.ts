// backend/src/config/env.loader.ts

/**
 * EnvLoader
 * Converts validated environment variables into
 * a structured, immutable runtime config object.
 */
export const EnvLoader = () => ({
  /**
   * Runtime
   */
  NODE_ENV: process.env.NODE_ENV,
  PORT: Number(process.env.PORT),

  /**
   * Application Identity
   */
  APP_NAME: process.env.APP_NAME,

  /**
   * Auth / Security
   */
  JWT_SECRET: process.env.JWT_SECRET,
  JWT_EXPIRES_IN: process.env.JWT_EXPIRES_IN,

  /**
   * Database
   */
  DATABASE_URL: process.env.DATABASE_URL,

  /**
   * Feature Control
   */
  FEATURE_FLAGS_HASH: process.env.FEATURE_FLAGS_HASH,

  /**
   * Country / Risk Controls
   */
  DEFAULT_COUNTRY: process.env.DEFAULT_COUNTRY,
  RISK_MODE: process.env.RISK_MODE,

  /**
   * External Providers
   */
  SMS_PROVIDER_KEY: process.env.SMS_PROVIDER_KEY,
  EMAIL_PROVIDER_KEY: process.env.EMAIL_PROVIDER_KEY,

  /**
   * Compliance / Audit
   */
  AUDIT_LOG_RETENTION_DAYS: Number(
    process.env.AUDIT_LOG_RETENTION_DAYS,
  ),
});
