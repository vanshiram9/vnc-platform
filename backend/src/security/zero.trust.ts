// backend/src/security/zero.trust.ts

/**
 * VNC PLATFORM — ZERO TRUST GATE
 * FINAL & HARD-LOCKED
 *
 * Purpose:
 * - Enforce zero-trust checks before critical actions
 * - Centralized, reusable decision logic
 *
 * IMPORTANT:
 * - No HTTP
 * - No persistence
 * - Deterministic & auditable
 */

import { KillSwitch } from '../owner/kill.switch';

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

export interface ZeroTrustContext {
  userId: string;
  userFrozen?: boolean;
  walletFrozen?: boolean;
  action: CriticalAction;
}

/**
 * ZeroTrustGate
 * Stateless verifier (except kill-switch read)
 */
export class ZeroTrustGate {
  constructor(
    private readonly killSwitch: KillSwitch,
  ) {}

  /**
   * Verify whether an action is allowed
   */
  verify(ctx: ZeroTrustContext): {
    allowed: boolean;
    reason?: string;
  } {
    // Global emergency stop
    if (this.killSwitch.isActive()) {
      return {
        allowed: false,
        reason: 'KILL_SWITCH_ACTIVE',
      };
    }

    // User-level freeze
    if (ctx.userFrozen === true) {
      return {
        allowed: false,
        reason: 'USER_FROZEN',
      };
    }

    // Wallet-level freeze (for financial actions)
    if (
      ctx.walletFrozen === true &&
      this.isFinancialAction(ctx.action)
    ) {
      return {
        allowed: false,
        reason: 'WALLET_FROZEN',
      };
    }

    return { allowed: true };
  }

  /* ----------------------- */
  /* Internal helpers        */
  /* ----------------------- */

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
}
