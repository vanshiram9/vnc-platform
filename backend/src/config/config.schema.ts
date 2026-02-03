// backend/src/config/config.schema.ts

import * as Joi from 'joi';

/**
 * Environment Variable Contract
 * Any missing / invalid variable MUST fail startup.
 */
export const ConfigSchema = Joi.object({
  /**
   * Runtime
   */
  NODE_ENV: Joi.string()
    .valid('development', 'staging', 'production')
    .required(),

  PORT: Joi.number()
    .port()
    .required(),

  /**
   * Application Identity
   */
  APP_NAME: Joi.string()
    .default('VNC-PLATFORM'),

  /**
   * Security / Auth
   */
  JWT_SECRET: Joi.string().min(32).required(),
  JWT_EXPIRES_IN: Joi.string().required(),

  /**
   * Database
   */
  DATABASE_URL: Joi.string().uri().required(),

  /**
   * Feature Control
   */
  FEATURE_FLAGS_HASH: Joi.string().required(),

  /**
   * Country / Risk Controls
   */
  DEFAULT_COUNTRY: Joi.string().length(2).required(),
  RISK_MODE: Joi.string()
    .valid('low', 'medium', 'high')
    .required(),

  /**
   * External Services (optional but validated if present)
   */
  SMS_PROVIDER_KEY: Joi.string().optional(),
  EMAIL_PROVIDER_KEY: Joi.string().optional(),

  /**
   * Compliance / Audit
   */
  AUDIT_LOG_RETENTION_DAYS: Joi.number().integer().min(30).required(),
}).unknown(false); // ❌ forbid undeclared env vars
