-- ============================================================
-- VNC PLATFORM — INITIAL DATABASE SETUP
-- Migration: 001_init.sql
-- Final Master Hard-Lock Version: v6.7.0.4
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- 1. REQUIRED EXTENSIONS
-- ------------------------------------------------------------
-- UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Cryptographic helpers (hashing)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ------------------------------------------------------------
-- 2. GLOBAL AUDIT SCHEMA
-- ------------------------------------------------------------
-- Separate schema for audit / forensic data
CREATE SCHEMA IF NOT EXISTS audit;

-- ------------------------------------------------------------
-- 3. GLOBAL FUNCTIONS
-- ------------------------------------------------------------

-- Immutable current timestamp (explicit wrapper)
CREATE OR REPLACE FUNCTION now_utc()
RETURNS TIMESTAMPTZ
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT NOW() AT TIME ZONE 'UTC';
$$;

-- ------------------------------------------------------------
-- 4. BASE ENUM TYPES
-- ------------------------------------------------------------

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'record_status') THEN
    CREATE TYPE record_status AS ENUM (
      'ACTIVE',
      'FROZEN',
      'ARCHIVED'
    );
  END IF;
END$$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'kyc_status') THEN
    CREATE TYPE kyc_status AS ENUM (
      'PENDING',
      'APPROVED',
      'REJECTED'
    );
  END IF;
END$$;

-- ------------------------------------------------------------
-- 5. MIGRATION TRACKING TABLE
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS audit.schema_migrations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  migration_name TEXT NOT NULL UNIQUE,
  applied_at TIMESTAMPTZ NOT NULL DEFAULT now_utc()
);

-- ------------------------------------------------------------
-- 6. REGISTER THIS MIGRATION
-- ------------------------------------------------------------

INSERT INTO audit.schema_migrations (migration_name)
VALUES ('001_init.sql')
ON CONFLICT (migration_name) DO NOTHING;

COMMIT;
