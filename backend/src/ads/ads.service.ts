// backend/src/ads/ads.service.ts

import {
  Injectable,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';

import { WalletService } from '../wallet/wallet.service';
import { UsersService } from '../users/users.service';
import { AdsAntiFraud } from './ads.antifraud';
import { RiskAction, evaluateRisk } from '../core/risk.matrix';
import { FeatureFlag } from '../core/feature.flags';
import { getCountryRule } from '../core/country.rules';

interface AdEventPayload {
  adId: string;
  event: 'VIEW' | 'CLICK' | 'COMPLETE';
  metadata?: Record<string, any>;
}

/**
 * ADS SERVICE
 * Handles ad events and rewards.
 */
@Injectable()
export class AdsService {
  constructor(
    private readonly walletService: WalletService,
    private readonly usersService: UsersService,
    private readonly antiFraud: AdsAntiFraud,
  ) {}

  /**
   * Handle ad interaction event
   */
  async handleAdEvent(
    identifier: string,
    payload: AdEventPayload,
  ) {
    if (!payload.adId || !payload.event) {
      throw new BadRequestException('INVALID_AD_EVENT');
    }

    const user = await this.usersService.getByIdentifier(
      identifier,
    );

    // Risk gate
    const risk = evaluateRisk({
      countryRule: getCountryRule(
        (user as any).countryCode || '',
      ),
      featureSnapshot: {
        [FeatureFlag.AUTH]: true,
        [FeatureFlag.WALLET]: true,
        [FeatureFlag.MINING]: true,
        [FeatureFlag.ADS]: true,
        [FeatureFlag.TRADE]: true,
        [FeatureFlag.IMPORT_EXPORT]: true,
        [FeatureFlag.MERCHANT]: true,
        [FeatureFlag.KYC]: true,
        [FeatureFlag.SUPPORT]: true,
        [FeatureFlag.ADMIN]: true,
      },
      signals: {},
    });

    if (risk.action === RiskAction.FREEZE) {
      throw new ForbiddenException('RISK_FREEZE');
    }

    // Anti-fraud validation
    const allowed = this.antiFraud.validateEvent(
      user.id,
      payload,
    );

    if (!allowed) {
      throw new ForbiddenException('AD_EVENT_REJECTED');
    }

    // Determine reward
    const reward = this.calculateReward(payload.event);

    if (reward <= 0) {
      return {
        status: 'EVENT_RECORDED',
        rewarded: false,
      };
    }

    // Credit reward via wallet ledger
    await this.walletService['appendLedger'](
      user.id,
      'AD_PAYOUT',
      reward,
      `Ad reward (${payload.event})`,
    );

    return {
      status: 'EVENT_RECORDED',
      rewarded: true,
      amount: reward,
    };
  }

  /**
   * Reward mapping by event type
   */
  private calculateReward(
    event: 'VIEW' | 'CLICK' | 'COMPLETE',
  ): number {
    switch (event) {
      case 'VIEW':
        return 0.01;
      case 'CLICK':
        return 0.05;
      case 'COMPLETE':
        return 0.1;
      default:
        return 0;
    }
  }
}
