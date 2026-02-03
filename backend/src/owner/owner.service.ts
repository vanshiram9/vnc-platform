// backend/src/owner/owner.service.ts

import { Injectable } from '@nestjs/common';

import { KillSwitch } from './kill.switch';
import { FeatureFlag, FeatureFlags } from '../core/feature.flags';
import {
  CountryRule,
  getCountryRule,
  setCountryRule,
} from '../core/country.rules';

@Injectable()
export class OwnerService {
  private readonly featureFlags = new FeatureFlags();

  constructor(
    private readonly killSwitch: KillSwitch,
  ) {}

  /**
   * Get global system status snapshot
   */
  async getSystemStatus() {
    return {
      features: this.featureFlags.getAll(),
      killSwitch: this.killSwitch.getStatus(),
      timestamp: new Date(),
    };
  }

  /**
   * Enable or disable a platform feature
   */
  async toggleFeature(
    feature: string,
    enabled: boolean,
  ) {
    const flag = feature as FeatureFlag;

    this.featureFlags.set(flag, enabled);

    return {
      feature: flag,
      enabled,
      timestamp: new Date(),
    };
  }

  /**
   * Update country policy
   */
  async updateCountryRule(
    countryCode: string,
    policy: CountryRule['policy'],
  ) {
    setCountryRule(countryCode, policy);

    return {
      countryCode,
      policy,
      updatedAt: new Date(),
    };
  }

  /**
   * Trigger emergency kill switch
   */
  async triggerKillSwitch(reason?: string) {
    this.killSwitch.activate(reason);

    return {
      status: 'KILL_SWITCH_ACTIVATED',
      reason: reason ?? 'UNSPECIFIED',
      timestamp: new Date(),
    };
  }
}
