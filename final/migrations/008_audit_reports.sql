-- ============================================================
-- VNC PLATFORM — AUDIT & REPORTING
-- Migration: 008_audit_reports.sql
-- Final Master Hard-Lock Version: v6.7.0.4
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- 1. ENUM TYPES
-- ------------------------------------------------------------

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'audit_event_type') THEN
    CREATE TYPE audit_event_type AS ENUM (
      'SECURITY',
      'COMPLIANCE',
      'ECONOMIC',
      'GOVERNANCE',
      'SYSTEM'
    );
  END IF;
END$$;

-- ------------------------------------------------------------
-- 2. AUDIT EVENTS (APPEND-ONLY)
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS audit.audit_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  event_type audit_event_type NOT NULL,
  entity_type VARCHAR(64),
  entity_id UUID,

  description TEXT NOT NULL,
  metadata JSONB,

  created_at TIMESTAMPTZ NOT NULL DEFAULT now_utc()
);

CREATE INDEX IF NOT EXISTS idx_audit_events_type
  ON audit.audit_events(event_type);

CREATE INDEX IF NOT EXISTS idx_audit_events_created
  ON audit.audit_events(created_at);

-- ------------------------------------------------------------
-- 3. FORENSIC SNAPSHOTS (METADATA ONLY)
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS audit.forensic_snapshots (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  scope VARCHAR(32) NOT NULL,      -- USER / WALLET / SYSTEM
  target_id UUID,
  reason TEXT NOT NULL,

  snapshot_ref TEXT NOT NULL,      -- hash / object reference
  created_by VARCHAR(16) NOT NULL, -- SYSTEM / ADMIN / OWNER

  created_at TIMESTAMPTZ NOT NULL DEFAULT now_utc()
);

CREATE INDEX IF NOT EXISTS idx_forensic_scope
  ON audit.forensic_snapshots(scope);

-- ------------------------------------------------------------
-- 4. PREVENT MUTATION (IMMUTABLE)
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION forbid_audit_mutation()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  RAISE EXCEPTION 'AUDIT_DATA_IS_IMMUTABLE';
END;
$$;

DROP TRIGGER IF EXISTS trg_audit_no_update ON audit.audit_events;
CREATE TRIGGER trg_audit_no_update
BEFORE UPDATE OR DELETE ON audit.audit_events
FOR EACH ROW
EXECUTE FUNCTION forbid_audit_mutation();

DROP TRIGGER IF EXISTS trg_snapshot_no_update ON audit.forensic_snapshots;
CREATE TRIGGER trg_snapshot_no_update
BEFORE UPDATE OR DELETE ON audit.forensic_snapshots
FOR EACH ROW
EXECUTE FUNCTION forbid_audit_mutation();

-- ------------------------------------------------------------
-- 5. REGISTER THIS MIGRATION
-- ------------------------------------------------------------

INSERT INTO audit.schema_migrations (migration_name)
VALUES ('008_audit_reports.sql')
ON CONFLICT (migration_name) DO NOTHING;

COMMIT;
