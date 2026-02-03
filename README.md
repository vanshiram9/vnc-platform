# VNC PLATFORM

**Final Master Hard-Lock Version:** `v6.7.0.4`  
**Lock Status:** HARD-LOCKED (Backend)  
**Scope:** Root • Docs • Infra • Final  
**Frontend:** Pending (out of scope for this phase)

---

## 1. What is VNC Platform?

VNC Platform is a security-first, zero-trust digital infrastructure designed for:
- Wallet & ledger–based value systems
- Trade, escrow, import–export flows
- Mining & reward mechanisms
- Merchant, admin, and owner governance
- Compliance-ready operations (AML, RBI, judicial)

The platform is engineered with **damage containment** as the primary security objective:
> In the worst case, the system freezes and records evidence — funds and control are never lost.

---

## 2. Hard-Lock Philosophy

This repository follows a **Hard-Lock Architecture**:

- ❌ No new features
- ❌ No deletions
- ❌ No rewrites
- ❌ No bypass of zero-trust or ledger rules

The **project tree is the single source of truth**.  
All changes outside the defined scope invalidate the audit seal.

Reference: `architecture.lock.json`

---

## 3. Current Status Matrix

| Area        | Status     | Notes |
|-------------|------------|-------|
| Backend     | COMPLETE   | Frozen, audited, security-sealed |
| Frontend   | PENDING    | Will be completed later |
| Docs       | REQUIRED   | Being finalized in this phase |
| Infra      | REQUIRED   | Being finalized in this phase |
| Final Seal | REQUIRED   | Being finalized in this phase |

---

## 4. Security Model (High Level)

- **Zero-Trust Gate:** Every critical action is verified
- **Append-Only Ledger:** No balance mutation, only derived state
- **Freeze-First Response:** On anomaly/fraud, freeze precedes investigation
- **Kill-Switch:** Owner-level emergency halt
- **Forensic Snapshot:** Court-ready evidence capture

No claim of “perfect security” is made.  
The guarantee is **controlled damage and provable integrity**.

---

## 5. Compliance Readiness

The platform includes explicit structures for:
- AML reporting
- RBI-aligned compliance summaries
- Judicial / court response payloads

All compliance outputs are:
- Deterministic
- Auditable
- Read-only (no mutation of system state)

---

## 6. Audit & Tamper Protection

- All critical files are tracked in `audit.hashes.json`
- Any silent modification post-seal invalidates audit integrity
- Owner override is required for any exception

---

## 7. Allowed & Forbidden Actions

### Allowed
- Completing pending **docs/**
- Completing pending **infra/**
- Completing pending **final/**

### Forbidden
- Modifying backend logic
- Adding/removing modules
- Changing ledger or zero-trust behavior
- Bypassing security or governance layers

---

## 8. Authority Model

- **Owner:** Final authority (emergency controls only)
- **Admin:** Operational moderation (no overrides)
- **System:** Fail-closed by default

---

## 9. Final Note

This repository is designed to withstand:
- Adversarial audits
- Regulatory scrutiny
- Hostile threat modeling

Progress beyond this point is **strictly controlled**.

---

**VNC PLATFORM — Build once. Lock hard. Verify always.**
