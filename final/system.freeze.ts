// final/system.freeze.ts

/**
 * VNC PLATFORM — SYSTEM FREEZE PROTOCOL
 * Final Master Hard-Lock Version: v6.7.0.4
 *
 * Purpose:
 * - Define how the system enters a frozen state
 * - Ensure freeze is explicit, auditable, and reversible only by authority
 *
 * NOTE:
 * - This file contains governance logic only
 * - No runtime side-effects
 * - No dependency on backend services
 */

export type FreezeScope =
  | 'USER'
  | 'WALLET'
  | 'MODULE'
  | 'SYSTEM';

export interface FreezeEvent {
  scope: FreezeScope;
  targetId?: string;
  reason: string;
  initiatedBy: 'SYSTEM' | 'ADMIN' | 'OWNER';
  timestamp: Date;
}

export interface FreezeState {
  active: boolean;
  events: FreezeEvent[];
}

/**
 * Immutable freeze state builder
 */
export function buildFreezeState(
  events: FreezeEvent[]
): FreezeState {
  return {
    active: events.length > 0,
    events: [...events]
  };
}

/**
 * Validate whether a freeze request is allowed
 */
export function validateFreezeRequest(input: {
  scope: FreezeScope;
  initiatedBy: 'SYSTEM' | 'ADMIN' | 'OWNER';
}): {
  allowed: boolean;
  reason?: string;
} {
  // Only OWNER can freeze entire system
  if (
    input.scope === 'SYSTEM' &&
    input.initiatedBy !== 'OWNER'
  ) {
    return {
      allowed: false,
      reason: 'ONLY_OWNER_CAN_FREEZE_SYSTEM'
    };
  }

  // Admin cannot freeze modules directly
  if (
    input.scope === 'MODULE' &&
    input.initiatedBy === 'ADMIN'
  ) {
    return {
      allowed: false,
      reason: 'ADMIN_MODULE_FREEZE_NOT_ALLOWED'
    };
  }

  return { allowed: true };
}
