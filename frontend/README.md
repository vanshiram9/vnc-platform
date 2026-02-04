# VNC PLATFORM — FRONTEND (MOBILE CLIENT)

**Version:** v6.7.0.4  
**Scope:** Mobile-only Flutter application  
**Security Model:** Backend Zero-Trust (Frontend = Thin Client)

---

## 📌 PURPOSE

This frontend is a **secure mobile client** for the VNC Platform.
It does NOT contain business authority.

All critical decisions are enforced by the backend:
- Authentication
- Wallet balance & ledger
- Trading & escrow
- KYC, risk, country rules
- Admin & Owner governance
- Emergency freeze

The frontend only:
- Sends authenticated requests
- Renders server-validated state
- Handles UI navigation & local UX state

---

## 🔐 SECURITY PRINCIPLES (NON-NEGOTIABLE)

- ❌ No balance calculation on client
- ❌ No role enforcement on client
- ❌ No feature enable/disable on client
- ❌ No country/risk logic on client
- ❌ No silent fallback if API fails

✅ Backend is the **single source of truth**  
✅ Frontend follows **Zero-Trust discipline**

---

## 📂 PROJECT STRUCTURE (LOCKED)
