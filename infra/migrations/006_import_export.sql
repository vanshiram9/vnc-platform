-- ============================================================
-- VNC PLATFORM — IMPORT / EXPORT (IE)
-- Migration: 006_import_export.sql
-- Final Master Hard-Lock Version: v6.7.0.4
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- 1. ENUM TYPES
-- ------------------------------------------------------------

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'ie_contract_status') THEN
    CREATE TYPE ie_contract_status AS ENUM (
      'CREATED',
      'ESCROW_LOCKED',
      'CONDITIONS_MET',
      'RELEASED',
      'EXPIRED',
      'CANCELLED',
      'FROZEN'
    );
  END IF;
END$$;

-- ------------------------------------------------------------
-- 2. IE CONTRACTS
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.ie_contracts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  importer_id UUID NOT NULL REFERENCES public.users(id),
  exporter_id UUID NOT NULL REFERENCES public.users(id),

  importer_wallet_id UUID NOT NULL REFERENCES public.wallets(id),
  exporter_wallet_id UUID NOT NULL REFERENCES public.wallets(id),

  asset VARCHAR(32) NOT NULL,
  amount NUMERIC(24, 8) NOT NULL CHECK (amount > 0),

  status ie_contract_status NOT NULL DEFAULT 'CREATED',

  expiry_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now_utc(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now_utc()
);

CREATE INDEX IF NOT EXISTS idx_ie_contracts_status
  ON public.ie_contracts(status);

-- ------------------------------------------------------------
-- 3. IE ESCROW (SINGLE RELEASE GUARANTEE)
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.ie_escrows (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  contract_id UUID NOT NULL REFERENCES public.ie_contracts(id) ON DELETE CASCADE,
  locked_amount NUMERIC(24, 8) NOT NULL CHECK (locked_amount > 0),

  released BOOLEAN NOT NULL DEFAULT FALSE,
  released_at TIMESTAMPTZ,

  created_at TIMESTAMPTZ NOT NULL DEFAULT now_utc()
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_ie_escrow_contract
  ON public.ie_escrows(contract_id);

-- ------------------------------------------------------------
-- 4. UPDATED_AT TRIGGER
-- ------------------------------------------------------------

DROP TRIGGER IF EXISTS trg_ie_contracts_updated_at ON public.ie_contracts;
CREATE TRIGGER trg_ie_contracts_updated_at
BEFORE UPDATE ON public.ie_contracts
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- ------------------------------------------------------------
-- 5. ESCROW DOUBLE-RELEASE PROTECTION
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION prevent_ie_double_release()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF OLD.released = TRUE THEN
    RAISE EXCEPTION 'IE_ESCROW_ALREADY_RELEASED';
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_ie_no_double_release ON public.ie_escrows;
CREATE TRIGGER trg_ie_no_double_release
BEFORE UPDATE ON public.ie_escrows
FOR EACH ROW
EXECUTE FUNCTION prevent_ie_double_release();

-- ------------------------------------------------------------
-- 6. REGISTER THIS MIGRATION
-- ------------------------------------------------------------

INSERT INTO audit.schema_migrations (migration_name)
VALUES ('006_import_export.sql')
ON CONFLICT (migration_name) DO NOTHING;

COMMIT;
