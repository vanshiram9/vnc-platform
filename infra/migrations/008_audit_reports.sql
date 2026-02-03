-- ============================================================
-- VNC PLATFORM — AUDIT & FORENSIC (HARDENED)
-- Migration: 008_audit_reports.sql
-- ============================================================

BEGIN;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname='audit_actor') THEN
    CREATE TYPE audit_actor AS ENUM ('SYSTEM','ADMIN','OWNER');
  END IF;
END $$;

CREATE TABLE IF NOT EXISTS audit.audit_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  event_type VARCHAR(32) NOT NULL,
  description TEXT NOT NULL,
  metadata JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now_utc()
);

CREATE TABLE IF NOT EXISTS audit.forensic_snapshots (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  scope VARCHAR(32) NOT NULL,
  target_id UUID,
  reason TEXT NOT NULL,
  snapshot_ref TEXT NOT NULL,
  created_by audit_actor NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now_utc()
);

CREATE OR REPLACE FUNCTION forbid_audit_mutation()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION 'AUDIT_IMMUTABLE';
END;
$$;

CREATE TRIGGER trg_audit_no_mutation
BEFORE UPDATE OR DELETE ON audit.audit_events
FOR EACH ROW EXECUTE FUNCTION forbid_audit_mutation();

CREATE TRIGGER trg_snapshot_no_mutation
BEFORE UPDATE OR DELETE ON audit.forensic_snapshots
FOR EACH ROW EXECUTE FUNCTION forbid_audit_mutation();

INSERT INTO audit.schema_migrations (migration_name)
VALUES ('008_audit_reports.sql')
ON CONFLICT DO NOTHING;

COMMIT;
