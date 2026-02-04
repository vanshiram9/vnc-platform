// ============================================================
// VNC PLATFORM — INCIDENT FREEZE ENGINE
// File: backend/src/security/incident.freeze.ts
// Grade: BANK + MILITARY + RBI
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/**
 * INCIDENT FREEZE PRINCIPLE
 * -------------------------
 * - Any suspicious or confirmed incident can freeze:
 *   - a user
 *   - a wallet
 *   - or the entire system
 *
 * - Freeze is SAFE by default
 * - Unfreeze is MANUAL + EXPLICIT
 * - No silent recovery
 *
 * This file is the FINAL SAFETY NET.
 */

import { Injectable } from '@nestjs/common';
import { KillSwitch } from '../owner/kill.switch';

type FreezeScope = 'USER' | 'WALLET' | 'SYSTEM';

interface FreezeEvent {
  scope: FreezeScope;
  targetId?: string;
  reason: string;
  timestamp: Date;
}

@Injectable()
export class IncidentFreeze {
  private readonly events: FreezeEvent[] = [];

  constructor(
    private readonly killSwitch: KillSwitch,
  ) {}

  /* ---------------------------------------------------------- */
  /* SYSTEM FREEZE (GLOBAL)                                     */
  /* ---------------------------------------------------------- */

  freezeSystem(reason: string): void {
    if (!this.killSwitch.isActive()) {
      this.killSwitch.activate(reason);
      this.record({
        scope: 'SYSTEM',
        reason,
      });
    }
  }

  isSystemFrozen(): boolean {
    return this.killSwitch.isActive();
  }

  /* ---------------------------------------------------------- */
  /* USER FREEZE                                                */
  /* ---------------------------------------------------------- */

  freezeUser(
    userId: string,
    reason: string,
  ): void {
    this.record({
      scope: 'USER',
      targetId: userId,
      reason,
    });

    /**
     * IMPORTANT:
     * Actual user freeze flag is applied
     * by domain services (UsersService)
     * after review.
     *
     * This engine only decides & records.
     */
  }

  /* ---------------------------------------------------------- */
  /* WALLET FREEZE                                              */
  /* ---------------------------------------------------------- */

  freezeWallet(
    walletId: string,
    reason: string,
  ): void {
    this.record({
      scope: 'WALLET',
      targetId: walletId,
      reason,
    });

    /**
     * Actual wallet freeze flag is applied
     * by WalletService after verification.
     */
  }

  /* ---------------------------------------------------------- */
  /* INCIDENT RECORDING                                         */
  /* ---------------------------------------------------------- */

  private record(
    event: Omit<FreezeEvent, 'timestamp'>,
  ) {
    this.events.push({
      ...event,
      timestamp: new Date(),
    });
  }

  /* ---------------------------------------------------------- */
  /* FORENSIC SNAPSHOT                                          */
  /* ---------------------------------------------------------- */

  snapshot(): FreezeEvent[] {
    // Read-only forensic view
    return [...this.events];
  }
}
