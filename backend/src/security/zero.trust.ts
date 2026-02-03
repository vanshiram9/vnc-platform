// ============================================================
// VNC PLATFORM — ZERO TRUST GATE
// File: backend/src/security/zero.trust.ts
// Grade: BANK + MILITARY + RBI
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/**
 * ZERO TRUST PRINCIPLE
 * --------------------
 * - No action is trusted by default
 * - No role is trusted by default
 * - No state is assumed safe
 * - Every critical action must pass this gate
 *
 * IMPORTANT DESIGN RULES
 * ----------------------
 * - No HTTP / Express dependency
 * - No persistence
 * - Deterministic decisions only
 * - Explicit invocation by services
 */

import { KillSwitch } from '../owner/kill.switch';

/* ----------------------------- */
/* CRITICAL ACTIONS (LOCKED)     */
/* ----------------------------- */

export type CriticalAction =
  | 'AUTH'
  | 'WALLET'
  | 'WITHDRAW'
  | 'TRADE'
  | 'MINING'
  | 'ADS'
  | 'IMPORT_EXPORT'
  | 'ADMIN'
  | 'OWNER';

/* ----------------------------- */
/* CONTEXT REQUIRED FOR DECISION */
/* ----------------------------- */

export interface ZeroTrustContext {
  userId: string;

  /** Hard states */
  userFrozen?: boolean;
  walletFrozen?: boolean;
  systemFrozen?: boolean;

  /** Identity & authority */
  role?: 'USER' | 'MERCHANT' | 'ADMIN' | 'OWNER';

  /** Action intent */
  action: CriticalAction;

  /** Optional risk score (0–100) */
  riskScore?: number;
}

/* ----------------------------- */
/* ZERO TRUST GATE               */
/* ----------------------------- */

export class ZeroTrustGate {
  constructor(
    private readonly killSwitch: KillSwitch,
  ) {}

  /**
   * Verify whether a critical action is allowed
   */
  verify(
    ctx: ZeroTrustContext,
  ): { allowed: boolean; reason?: string } {
    /* 1️⃣ GLOBAL EMERGENCY STOP */
    if (this.killSwitch.isActive() || ctx.systemFrozen === true) {
      return this.deny('SYSTEM_FROZEN');
    }

    /* 2️⃣ USER FREEZE (ABSOLUTE) */
    if (ctx.userFrozen === true) {
      return this.deny('USER_FROZEN');
    }

    /* 3️⃣ WALLET FREEZE (FINANCIAL ACTIONS) */
    if (
      ctx.walletFrozen === true &&
      this.isFinancialAction(ctx.action)
    ) {
      return this.deny('WALLET_FROZEN');
    }

    /* 4️⃣ ROLE BOUNDARY (NO IMPLICIT TRUST) */
    if (!this.isRoleAllowed(ctx.role, ctx.action)) {
      return this.deny('ROLE_NOT_ALLOWED');
    }

    /* 5️⃣ RISK SCORE GATE (DEFENSIVE) */
    if (
      typeof ctx.riskScore === 'number' &&
      ctx.riskScore >= 80
    ) {
      return this.deny('RISK_TOO_HIGH');
    }

    /* 6️⃣ PASSED ZERO TRUST */
    return { allowed: true };
  }

  /* ----------------------------- */
  /* INTERNAL HELPERS              */
  /* ----------------------------- */

  private deny(reason: string) {
    return { allowed: false, reason };
  }

  private isFinancialAction(
    action: CriticalAction,
  ): boolean {
    return [
      'WALLET',
      'WITHDRAW',
      'TRADE',
      'IMPORT_EXPORT',
      'ADS',
      'MINING',
    ].includes(action);
  }

  private isRoleAllowed(
    role: ZeroTrustContext['role'],
    action: CriticalAction,
  ): boolean {
    if (!role) return false;

    if (action === 'OWNER') {
      return role === 'OWNER';
    }

    if (action === 'ADMIN') {
      return role === 'ADMIN' || role === 'OWNER';
    }

    return true;
  }
}
