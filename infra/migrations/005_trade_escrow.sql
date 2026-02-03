-- ============================================================
-- VNC PLATFORM — TRADE & ESCROW
-- Migration: 005_trade_escrow.sql
-- Final Master Hard-Lock Version: v6.7.0.4
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- 1. ENUM TYPES
-- ------------------------------------------------------------

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'trade_side') THEN
    CREATE TYPE trade_side AS ENUM (
      'BUY',
      'SELL'
    );
  END IF;
END$$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'trade_status') THEN
    CREATE TYPE trade_status AS ENUM (
      'OPEN',
      'MATCHED',
      'ESCROW_LOCKED',
      'SETTLED',
      'CANCELLED',
      'FAILED'
    );
  END IF;
END$$;

-- ------------------------------------------------------------
-- 2. TRADES TABLE
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.trades (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  wallet_id UUID NOT NULL REFERENCES public.wallets(id),

  side trade_side NOT NULL,
  asset VARCHAR(32) NOT NULL,
  quantity NUMERIC(24, 8) NOT NULL CHECK (quantity > 0),
  price NUMERIC(24, 8) NOT NULL CHECK (price > 0),

  status trade_status NOT NULL DEFAULT 'OPEN',

  created_at TIMESTAMPTZ NOT NULL DEFAULT now_utc(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now_utc()
);

CREATE INDEX IF NOT EXISTS idx_trades_user_id
  ON public.trades(user_id);

CREATE INDEX IF NOT EXISTS idx_trades_status
  ON public.trades(status);

-- ------------------------------------------------------------
-- 3. ESCROW RECORDS
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.trade_escrows (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  trade_id UUID NOT NULL REFERENCES public.trades(id) ON DELETE CASCADE,
  wallet_id UUID NOT NULL REFERENCES public.wallets(id),

  locked_amount NUMERIC(24, 8) NOT NULL CHECK (locked_amount > 0),
  released BOOLEAN NOT NULL DEFAULT FALSE,

  created_at TIMESTAMPTZ NOT NULL DEFAULT now_utc(),
  released_at TIMESTAMPTZ
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_trade_escrow_trade
  ON public.trade_escrows(trade_id);

-- ------------------------------------------------------------
-- 4. UPDATED_AT TRIGGER
-- ------------------------------------------------------------

DROP TRIGGER IF EXISTS trg_trades_updated_at ON public.trades;
CREATE TRIGGER trg_trades_updated_at
BEFORE UPDATE ON public.trades
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- ------------------------------------------------------------
-- 5. ESCROW SAFETY RULE (NO DOUBLE RELEASE)
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION prevent_escrow_double_release()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF OLD.released = TRUE THEN
    RAISE EXCEPTION 'ESCROW_ALREADY_RELEASED';
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_no_double_release ON public.trade_escrows;
CREATE TRIGGER trg_no_double_release
BEFORE UPDATE ON public.trade_escrows
FOR EACH ROW
EXECUTE FUNCTION prevent_escrow_double_release();

-- ------------------------------------------------------------
-- 6. REGISTER THIS MIGRATION
-- ------------------------------------------------------------

INSERT INTO audit.schema_migrations (migration_name)
VALUES ('005_trade_escrow.sql')
ON CONFLICT (migration_name) DO NOTHING;

COMMIT;
