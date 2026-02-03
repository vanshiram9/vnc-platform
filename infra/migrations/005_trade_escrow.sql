-- ============================================================
-- VNC PLATFORM — TRADE ESCROW (STRICT)
-- Migration: 005_trade_escrow.sql
-- ============================================================

BEGIN;

CREATE TABLE IF NOT EXISTS public.trade_escrows (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  trade_id UUID NOT NULL REFERENCES public.trades(id) ON DELETE CASCADE,
  wallet_id UUID NOT NULL REFERENCES public.wallets(id),
  locked_amount NUMERIC(24,8) NOT NULL CHECK (locked_amount > 0),
  released BOOLEAN NOT NULL DEFAULT FALSE,
  released_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now_utc()
);

CREATE OR REPLACE FUNCTION enforce_escrow_release()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  IF OLD.released = TRUE THEN
    RAISE EXCEPTION 'ESCROW_ALREADY_RELEASED';
  END IF;
  IF NEW.released = TRUE AND NEW.released_at IS NULL THEN
    RAISE EXCEPTION 'RELEASED_AT_REQUIRED';
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_escrow_guard
BEFORE UPDATE ON public.trade_escrows
FOR EACH ROW EXECUTE FUNCTION enforce_escrow_release();

INSERT INTO audit.schema_migrations (migration_name)
VALUES ('005_trade_escrow.sql')
ON CONFLICT DO NOTHING;

COMMIT;
