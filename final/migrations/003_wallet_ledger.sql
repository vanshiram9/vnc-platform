-- ============================================================
-- VNC PLATFORM — WALLET & LEDGER
-- Migration: 003_wallet_ledger.sql
-- Final Master Hard-Lock Version: v6.7.0.4
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- 1. ENUM TYPES
-- ------------------------------------------------------------

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'ledger_entry_type') THEN
    CREATE TYPE ledger_entry_type AS ENUM (
      'CREDIT',
      'DEBIT',
      'LOCK',
      'UNLOCK',
      'FEE',
      'REVERSAL'
    );
  END IF;
END$$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'wallet_state') THEN
    CREATE TYPE wallet_state AS ENUM (
      'ACTIVE',
      'FROZEN'
    );
  END IF;
END$$;

-- ------------------------------------------------------------
-- 2. WALLETS TABLE (NO BALANCE STORED)
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.wallets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,

  currency VARCHAR(16) NOT NULL,
  state wallet_state NOT NULL DEFAULT 'ACTIVE',
  is_frozen BOOLEAN NOT NULL DEFAULT FALSE,

  created_at TIMESTAMPTZ NOT NULL DEFAULT now_utc(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now_utc(),

  CONSTRAINT uq_wallet_user_currency UNIQUE (user_id, currency)
);

-- ------------------------------------------------------------
-- 3. LEDGER ENTRIES (APPEND-ONLY)
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.ledger_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  wallet_id UUID NOT NULL REFERENCES public.wallets(id) ON DELETE CASCADE,

  entry_type ledger_entry_type NOT NULL,
  amount NUMERIC(24, 8) NOT NULL CHECK (amount >= 0),

  -- Hash-chain fields
  prev_hash TEXT,
  entry_hash TEXT NOT NULL,

  -- Context
  reference_type VARCHAR(64),
  reference_id UUID,

  created_at TIMESTAMPTZ NOT NULL DEFAULT now_utc()
);

CREATE INDEX IF NOT EXISTS idx_ledger_wallet_id
  ON public.ledger_entries(wallet_id);

CREATE INDEX IF NOT EXISTS idx_ledger_created_at
  ON public.ledger_entries(created_at);

-- ------------------------------------------------------------
-- 4. HASH GENERATION RULE (SERVER-ENFORCED)
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION compute_ledger_hash(
  _wallet_id UUID,
  _entry_type ledger_entry_type,
  _amount NUMERIC,
  _prev_hash TEXT,
  _created_at TIMESTAMPTZ
)
RETURNS TEXT
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT encode(
    digest(
      concat_ws(
        '|',
        _wallet_id::text,
        _entry_type::text,
        _amount::text,
        COALESCE(_prev_hash, ''),
        _created_at::text
      ),
      'sha256'
    ),
    'hex'
  );
$$;

-- ------------------------------------------------------------
-- 5. PREVENT UPDATE / DELETE ON LEDGER (IMMUTABLE)
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION forbid_ledger_mutation()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  RAISE EXCEPTION 'LEDGER_ENTRIES_ARE_IMMUTABLE';
END;
$$;

DROP TRIGGER IF EXISTS trg_ledger_no_update ON public.ledger_entries;
CREATE TRIGGER trg_ledger_no_update
BEFORE UPDATE OR DELETE ON public.ledger_entries
FOR EACH ROW
EXECUTE FUNCTION forbid_ledger_mutation();

-- ------------------------------------------------------------
-- 6. UPDATED_AT TRIGGER FOR WALLETS
-- ------------------------------------------------------------

DROP TRIGGER IF EXISTS trg_wallets_updated_at ON public.wallets;
CREATE TRIGGER trg_wallets_updated_at
BEFORE UPDATE ON public.wallets
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- ------------------------------------------------------------
-- 7. REGISTER THIS MIGRATION
-- ------------------------------------------------------------

INSERT INTO audit.schema_migrations (migration_name)
VALUES ('003_wallet_ledger.sql')
ON CONFLICT (migration_name) DO NOTHING;

COMMIT;
