// backend/src/security/incident.freeze.ts

/**
 * VNC PLATFORM — INCIDENT FREEZE
 * FINAL & HARD-LOCKED
 *
 * Purpose:
 * - Automatically freeze entities during security incidents
 * - Triggered by risk, fraud, anomaly, or admin signals
 *
 * IMPORTANT:
 * - No HTTP
 * - No persistence
 * - Deterministic execution
 */

import { UsersService } from '../users/users.service';
import { WalletService } from '../wallet/wallet.service';
import { KillSwitch } from '../owner/kill.switch';
import { RiskAction } from '../core/risk.matrix';

export type IncidentLevel =
  | 'USER'
  | 'WALLET'
  | 'SYSTEM';

export interface IncidentContext {
  userId?: string;
  reason: string;
  severity: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';
}

export class IncidentFreeze {
  constructor(
    private readonly usersService: UsersService,
    private readonly walletService: WalletService,
    private readonly killSwitch: KillSwitch,
  ) {}

  /**
   * Execute incident freeze
   */
  async execute(
    level: IncidentLevel,
    ctx: IncidentContext,
  ) {
    const timestamp = new Date();

    // SYSTEM-WIDE INCIDENT
    if (
      level === 'SYSTEM' ||
      ctx.severity === 'CRITICAL'
    ) {
      this.killSwitch.activate(ctx.reason);
      return {
        level: 'SYSTEM',
        action: RiskAction.FREEZE,
        reason: ctx.reason,
        timestamp,
      };
    }

    // USER / WALLET INCIDENT
    if (!ctx.userId) {
      throw new Error(
        'USER_ID_REQUIRED_FOR_INCIDENT',
      );
    }

    // Freeze user
    await this.usersService.setFrozen(
      ctx.userId,
      true,
    );

    // Freeze wallet
    await this.walletService.setFrozen(
      ctx.userId,
      true,
    );

    return {
      level,
      userId: ctx.userId,
      action: RiskAction.FREEZE,
      reason: ctx.reason,
      timestamp,
    };
  }
}
