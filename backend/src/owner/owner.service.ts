// ============================================================
// VNC PLATFORM — OWNER SERVICE
// File: backend/src/owner/owner.service.ts
// Grade: BANK + MILITARY + RBI
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import {
  Injectable,
  ForbiddenException,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';

import { UsersService } from '../users/users.service';
import { ZeroTrustGate } from '../security/zero.trust';
import { KillSwitch } from './kill.switch';
import { FeatureFlags } from '../core/feature.flags';
import { CountryRules } from '../core/country.rules';

@Injectable()
export class OwnerService {
  constructor(
    private readonly usersService: UsersService,
    private readonly killSwitch: KillSwitch,
    private readonly featureFlags: FeatureFlags,
    private readonly countryRules: CountryRules,
  ) {}

  /* ---------------------------------------------------------- */
  /* INTERNAL ZERO-TRUST OWNER CHECK                             */
  /* ---------------------------------------------------------- */

  private async verifyOwner(ownerId: string) {
    const owner = await this.usersService.findById(ownerId);
    if (!owner) throw new NotFoundException('OWNER_NOT_FOUND');

    const zt = new ZeroTrustGate(this.killSwitch);
    const decision = zt.verify({
      userId: owner.id,
      role: owner.role,
      userFrozen: owner.isFrozen,
      action: 'OWNER',
    });

    if (!decision.allowed) {
      throw new ForbiddenException(decision.reason);
    }

    return owner;
  }

  /* ---------------------------------------------------------- */
  /* SYSTEM STATUS                                              */
  /* ---------------------------------------------------------- */

  async getSystemStatus(ownerId: string) {
    await this.verifyOwner(ownerId);

    return {
      systemFrozen: this.killSwitch.isActive(),
      features: this.featureFlags.snapshot(),
      countryRules: this.countryRules.snapshot(),
      timestamp: new Date(),
    };
  }

  /* ---------------------------------------------------------- */
  /* FEATURE TOGGLE CONTROL                                     */
  /* ---------------------------------------------------------- */

  async setFeatureFlag(
    ownerId: string,
    feature: string,
    enabled: boolean,
  ): Promise<void> {
    await this.verifyOwner(ownerId);

    if (!this.featureFlags.exists(feature)) {
      throw new BadRequestException('UNKNOWN_FEATURE');
    }

    this.featureFlags.set(feature, enabled);
  }

  /* ---------------------------------------------------------- */
  /* COUNTRY RULE CONTROL                                       */
  /* ---------------------------------------------------------- */

  async setCountryRule(
    ownerId: string,
    countryCode: string,
    allowed: boolean,
  ): Promise<void> {
    await this.verifyOwner(ownerId);

    if (!countryCode || countryCode.length !== 2) {
      throw new BadRequestException('INVALID_COUNTRY_CODE');
    }

    this.countryRules.set(countryCode.toUpperCase(), allowed);
  }

  /* ---------------------------------------------------------- */
  /* EMERGENCY KILL SWITCH                                      */
  /* ---------------------------------------------------------- */

  async activateEmergencyFreeze(
    ownerId: string,
    reason: string,
  ): Promise<void> {
    await this.verifyOwner(ownerId);
    this.killSwitch.activate(reason);
  }

  async deactivateEmergencyFreeze(
    ownerId: string,
  ): Promise<void> {
    await this.verifyOwner(ownerId);
    this.killSwitch.deactivate();
  }
}
