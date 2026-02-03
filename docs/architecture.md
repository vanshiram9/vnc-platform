---

## 3. Module Segmentation

### 3.1 Core Domains
- **Auth**: Authentication, OTP, JWT strategy
- **Users**: Identity, role state, freeze state
- **Wallet**: Ledger-based balance derivation
- **Trade**: Buy/Sell + escrow logic
- **Mining**: Reward logic under rules
- **Ads**: Anti-fraud guarded payouts
- **Import-Export**: Escrow & LC logic
- **Merchant**: Settlement & merchant KYC
- **FAQ / Support**: Read/write support flows

Each domain:
- Has its own module
- Has explicit controller → service boundary
- Cannot bypass security gates

---

## 4. Security Architecture

### 4.1 Zero-Trust Gate
All critical actions pass through a **ZeroTrustGate** which validates:
- Kill-switch state
- User freeze state
- Wallet freeze state
- Action category (financial vs non-financial)

### 4.2 Incident Freeze
On high risk or anomaly:
- User + wallet are frozen
- System-wide kill-switch may activate
- No partial execution is allowed

### 4.3 Forensic Snapshot
At incident time:
- Immutable snapshot is generated
- Contains user, wallet, trades, risk signals
- Designed for court / regulator review

---

## 5. Ledger & Funds Safety

- Balances are **never stored**
- Only **ledger entries** are persisted
- Balance is always **derived**
- Ledger is **append-only**
- Hash-chained entries prevent tampering

Result:
> Funds cannot be silently altered or drained.

---

## 6. Governance Model

| Role  | Authority |
|------|-----------|
| User | Limited to own scope |
| Admin | Moderation & review only |
| Owner | Emergency controls (kill-switch) |

- Admin cannot override security
- Owner actions are auditable
- No role escalation via request payloads

---

## 7. Compliance & Audit

Architecture explicitly supports:
- AML reporting
- RBI-aligned summaries
- Judicial response payloads

All reports are:
- Deterministic
- Read-only
- Generated from system state

---

## 8. Deployment Boundaries

- **Backend**: Hard-locked, immutable
- **Docs / Infra / Final**: Required for production seal
- **Frontend**: Isolated, handled separately

---

## 9. What This Architecture Guarantees

✔ No unauthorized fund movement  
✔ No privilege escalation  
✔ No silent logic changes  
✔ No audit ambiguity  

---

## 10. What It Does NOT Claim

❌ Absolute security  
❌ Immunity to all network attacks  

Instead, it guarantees:
> **Maximum damage = freeze + evidence, not loss.**

---

**VNC PLATFORM — ARCHITECTURE SEALED**
