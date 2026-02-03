-- ============================================================
-- VNC PLATFORM — USERS & AUTH BASE
-- Migration: 002_users.sql
-- Final Master Hard-Lock Version: v6.7.0.4
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- 1. ENUM TYPES (SAFE GUARDS)
-- ------------------------------------------------------------

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role') THEN
    CREATE TYPE user_role AS ENUM (
      'USER',
      'MERCHANT',
      'ADMIN',
      'OWNER'
    );
  END IF;
END$$;

-- ------------------------------------------------------------
-- 2. USERS TABLE
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Identity
  phone VARCHAR(20) UNIQUE,
  email VARCHAR(255) UNIQUE,
  country_code VARCHAR(4),

  -- Role & State
  role user_role NOT NULL DEFAULT 'USER',
  status record_status NOT NULL DEFAULT 'ACTIVE',
  kyc_status kyc_status NOT NULL DEFAULT 'PENDING',

  -- Security
  is_frozen BOOLEAN NOT NULL DEFAULT FALSE,
  last_login_at TIMESTAMPTZ,

  -- Audit
  created_at TIMESTAMPTZ NOT NULL DEFAULT now_utc(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now_utc()
);

-- ------------------------------------------------------------
-- 3. USER AUTH TOKENS (JWT TRACKING / REVOKE SUPPORT)
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.user_tokens (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,

  token_hash TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  revoked BOOLEAN NOT NULL DEFAULT FALSE,

  created_at TIMESTAMPTZ NOT NULL DEFAULT now_utc()
);

CREATE INDEX IF NOT EXISTS idx_user_tokens_user_id
  ON public.user_tokens(user_id);

CREATE INDEX IF NOT EXISTS idx_user_tokens_expires_at
  ON public.user_tokens(expires_at);

-- ------------------------------------------------------------
-- 4. OTP VERIFICATION STATE
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.user_otps (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,

  otp_hash TEXT NOT NULL,
  attempts INTEGER NOT NULL DEFAULT 0,
  expires_at TIMESTAMPTZ NOT NULL,

  created_at TIMESTAMPTZ NOT NULL DEFAULT now_utc()
);

CREATE INDEX IF NOT EXISTS idx_user_otps_user_id
  ON public.user_otps(user_id);

-- ------------------------------------------------------------
-- 5. UPDATED_AT TRIGGER
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now_utc();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_users_updated_at ON public.users;
CREATE TRIGGER trg_users_updated_at
BEFORE UPDATE ON public.users
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- ------------------------------------------------------------
-- 6. REGISTER THIS MIGRATION
-- ------------------------------------------------------------

INSERT INTO audit.schema_migrations (migration_name)
VALUES ('002_users.sql')
ON CONFLICT (migration_name) DO NOTHING;

COMMIT;
