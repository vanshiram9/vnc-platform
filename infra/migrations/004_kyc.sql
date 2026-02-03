-- ============================================================
-- VNC PLATFORM — KYC
-- Migration: 004_kyc.sql
-- Final Master Hard-Lock Version: v6.7.0.4
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- 1. KYC RECORDS
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.kyc_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,

  -- Current KYC state (mirrors users.kyc_status for fast checks)
  status kyc_status NOT NULL DEFAULT 'PENDING',

  -- Metadata
  submitted_at TIMESTAMPTZ,
  reviewed_at TIMESTAMPTZ,
  reviewed_by UUID REFERENCES public.users(id),

  -- Audit
  created_at TIMESTAMPTZ NOT NULL DEFAULT now_utc(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now_utc(),

  CONSTRAINT uq_kyc_user UNIQUE (user_id)
);

-- ------------------------------------------------------------
-- 2. KYC DOCUMENTS (METADATA ONLY)
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.kyc_documents (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  kyc_id UUID NOT NULL REFERENCES public.kyc_records(id) ON DELETE CASCADE,

  document_type VARCHAR(64) NOT NULL,
  document_ref TEXT NOT NULL, -- reference / hash, not raw document
  uploaded_at TIMESTAMPTZ NOT NULL DEFAULT now_utc()
);

CREATE INDEX IF NOT EXISTS idx_kyc_documents_kyc_id
  ON public.kyc_documents(kyc_id);

-- ------------------------------------------------------------
-- 3. UPDATED_AT TRIGGER
-- ------------------------------------------------------------

DROP TRIGGER IF EXISTS trg_kyc_records_updated_at ON public.kyc_records;
CREATE TRIGGER trg_kyc_records_updated_at
BEFORE UPDATE ON public.kyc_records
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- ------------------------------------------------------------
-- 4. KYC STATE CONSISTENCY CHECK
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION sync_user_kyc_status()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE public.users
  SET kyc_status = NEW.status
  WHERE id = NEW.user_id;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_sync_user_kyc_status ON public.kyc_records;
CREATE TRIGGER trg_sync_user_kyc_status
AFTER INSERT OR UPDATE ON public.kyc_records
FOR EACH ROW
EXECUTE FUNCTION sync_user_kyc_status();

-- ------------------------------------------------------------
-- 5. REGISTER THIS MIGRATION
-- ------------------------------------------------------------

INSERT INTO audit.schema_migrations (migration_name)
VALUES ('004_kyc.sql')
ON CONFLICT (migration_name) DO NOTHING;

COMMIT;
