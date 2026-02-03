# VNC PLATFORM — SYSTEM ARCHITECTURE
Final Master Hard-Lock Version: v6.7.0.4

---

## 1. Architecture Objective

VNC Platform is designed as a **security-first, zero-trust, hard-locked system**
where financial safety, governance control, and auditability are prioritized
over feature velocity.

The architecture guarantees that:
- No single component can compromise the system
- No implicit trust exists between layers
- All critical actions are verifiable and reversible only via governance

---

## 2. Core Architectural Principles

### 2.1 Zero-Trust by Default
Every action is treated as hostile until verified.  
Trust is **never assumed**, only derived through checks.

### 2.2 Hard-Lock Architecture
Once sealed:
- No new modules can be added
- No existing logic can be modified
- No security rules can be bypassed

Reference: `architecture.lock.json`

### 2.3 Fail-Closed Design
If any uncertainty occurs:
→ the system denies execution  
→ freezes relevant entities  
→ records forensic evidence

---

## 3. High-Level System Layout

Client Applications (Mobile / Web) │ ▼ HTTP API Layer (Controllers) │ ▼ Application Services (Business Logic) │ ├── Zero-Trust Gate ├── Incident Freeze ├── Governance Rules │ ▼ Persistence Layer (PostgreSQL) │ ▼ Audit & Forensic Artifacts

---

## 4. Backend Module Architecture

Each domain module is isolated and structured as:

module/ ├── module.ts ├── controller.ts ├── service.ts └── entity / logic files


### Core Modules
- Auth
- Users
- KYC
- Wallet
- Mining
- Ads
- Trade
- Import–Export
- Merchant
- FAQ
- Support
- Admin
- Owner
- AI
- Compliance
- Security

Each module:
- Owns its own logic
- Cannot directly access another module’s internal state
- Communicates only through defined services

---

## 5. Security Architecture

### 5.1 Zero-Trust Gate
All critical actions pass through a centralized verification layer that checks:
- Kill-switch state
- User freeze status
- Wallet freeze status
- Action risk category

No controller or service can bypass this gate.

---

### 5.2 Incident Freeze System
On detection of:
- Fraud
- Anomaly
- High-risk behavior
- Manual admin escalation

The system immediately:
- Freezes the user
- Freezes the wallet
- Optionally activates a system-wide kill-switch

Execution never continues in parallel.

---

### 5.3 Forensic Snapshot
At the time of any incident:
- A point-in-time snapshot is generated
- Includes user, wallet, trade, and risk context
- Snapshot is immutable and read-only

Designed for:
- Internal investigation
- Regulatory review
- Judicial proceedings

---

## 6. Ledger & Funds Safety Model

- Wallet balances are **never stored**
- Only ledger entries are persisted
- Ledger is append-only
- Balance is always derived from history
- Ledger entries are hash-chained

This ensures:
- No silent balance modification
- No double-spend
- No historical tampering

---

## 7. Governance & Authority Model

| Role   | Capabilities |
|------|--------------|
| User | Limited to personal scope |
| Admin | Review, moderation, escalation |
| Owner | Emergency controls only |

Rules:
- Admin cannot override security
- Owner actions are logged and auditable
- No role escalation via API input

---

## 8. Compliance Architecture

The system natively supports:
- AML reporting
- RBI-aligned compliance summaries
- Judicial response artifacts

Compliance outputs:
- Do not mutate system state
- Are generated from verified data
- Are deterministic and reproducible

---

## 9. Deployment & Isolation

- Backend is fully hard-locked
- Infra and docs are sealed before production
- Frontend is isolated and cannot alter backend rules

---

## 10. Threat Model Summary

The architecture assumes:
- Compromised clients
- Stolen tokens
- Malicious insiders
- High-volume automated attacks

Response strategy:
> Contain damage, freeze execution, preserve evidence.

---

## 11. Guarantees

✔ Funds cannot be drained silently  
✔ Privilege escalation is blocked  
✔ Security bypass paths do not exist  
✔ Audit trails are complete  

---

## 12. Explicit Non-Claims

The system does NOT claim:
- Absolute security
- Immunity from all attacks

It guarantees:
> **Worst case outcome is freeze + evidence, not loss.**

---

**VNC PLATFORM — ARCHITECTURE HARD-LOCKED**
