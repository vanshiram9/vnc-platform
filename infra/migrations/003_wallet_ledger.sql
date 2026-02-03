-- ============================================================
-- VNC PLATFORM — WALLET & LEDGER (DB-HARDENED)
-- Migration: 003_wallet_ledger.sql
-- Final Master Hard-Lock Version: v6.7.0.4
-- ============================================================

BEGIN;

-- ENUM TYPES
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname='ledger_entry_type') THEN
    CREATE TYPE ledger_entry_type AS ENUM
      ('CREDIT','DEBIT','LOCK','UNLOCK','FEE','REVERSAL');
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname='wallet_state') THEN
    CREATE TYPE wallet_state AS ENUM ('ACTIVE','FROZEN');
  END IF;
END $$;

-- WALLETS (NO BALANCE)
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

-- LEDGER (APPEND ONLY + HASH CHAIN)
CREATE TABLE IF NOT EXISTS public.ledger_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  wallet_id UUID NOT NULL REFERENCES public.wallets(id) ON DELETE CASCADE,
  entry_type ledger_entry_type NOT NULL,
  amount NUMERIC(24,8) NOT NULL CHECK (amount >= 0),
  prev_hash TEXT NOT NULL,
  entry_hash TEXT NOT NULL UNIQUE,
  reference_type VARCHAR(64),
  reference_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now_utc()
);

CREATE INDEX IF NOT EXISTS idx_ledger_wallet_time
  ON public.ledger_entries(wallet_id, created_at);

-- HASH COMPUTE
CREATE OR REPLACE FUNCTION compute_ledger_hash(
  _wallet_id UUID,
  _entry_type ledger_entry_type,
  _amount NUMERIC,
  _prev_hash TEXT,
  _created_at TIMESTAMPTZ
) RETURNS TEXT
LANGUAGE SQL IMMUTABLE AS $$
  SELECT encode(
    digest(
      concat_ws('|',_wallet_id,_entry_type,_amount,_prev_hash,_created_at),
      'sha256'
    ),
    'hex'
  );
$$;

-- CHAIN ENFORCEMENT
CREATE OR REPLACE FUNCTION enforce_ledger_chain()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE last_hash TEXT;
BEGIN
  SELECT entry_hash INTO last_hash
  FROM public.ledger_entries
  WHERE wallet_id = NEW.wallet_id
  ORDER BY created_at DESC
  LIMIT 1;

  IF last_hash IS NULL THEN
    IF NEW.prev_hash <> 'GENESIS' THEN
      RAISE EXCEPTION 'INVALID_LEDGER_GENESIS';
    END IF;
  ELSE
    IF NEW.prev_hash <> last_hash THEN
      RAISE EXCEPTION 'LEDGER_CHAIN_BROKEN';
    END IF;
  END IF;

  IF NEW.entry_hash <>
     compute_ledger_hash(
       NEW.wallet_id, NEW.entry_type,
       NEW.amount, NEW.prev_hash, NEW.created_at
     )
  THEN
    RAISE EXCEPTION 'INVALID_LEDGER_HASH';
  END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_ledger_chain
BEFORE INSERT ON public.ledger_entries
FOR EACH ROW EXECUTE FUNCTION enforce_ledger_chain();

-- IMMUTABLE
CREATE OR REPLACE FUNCTION forbid_ledger_mutation()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION 'LEDGER_IMMUTABLE';
END;
$$;

CREATE TRIGGER trg_ledger_no_update
BEFORE UPDATE OR DELETE ON public.ledger_entries
FOR EACH ROW EXECUTE FUNCTION forbid_ledger_mutation();

INSERT INTO audit.schema_migrations (migration_name)
VALUES ('003_wallet_ledger.sql')
ON CONFLICT DO NOTHING;

COMMIT;
