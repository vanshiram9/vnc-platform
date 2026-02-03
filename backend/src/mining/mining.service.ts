// backend/src/mining/mining.service.ts

import {
  Injectable,
  ForbiddenException,
} from '@nestjs/common';

import { WalletService } from '../wallet/wallet.service';
import { UsersService } from '../users/users.service';
import { MiningRules } from './mining.rules';
import { RiskAction, evaluateRisk } from '../core/risk.matrix';
import { FeatureFlag } from '../core/feature.flags';
import { getCountryRule } from '../core/country.rules';

/**
 * In-memory session snapshot (boot-scoped)
 * NOTE:
 * - Tree does not define persistence for mining sessions
 * - This snapshot is used only for runtime status visibility
 */
interface MiningSession {
  startedAt: Date;
  lastRewardAt: Date | null;
  totalRewarded: number;
}

@Injectable()
export class MiningService {
  private readonly sessions = new Map<string, MiningSession>();

  constructor(
    private readonly walletService: WalletService,
    private readonly usersService: UsersService,
    private readonly miningRules: MiningRules,
  ) {}

  /**
   * Start mining session for user
   */
  async startMining(identifier: string) {
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

    if (!this.sessions.has(user.id)) {
      this.sessions.set(user.id, {
        startedAt: new Date(),
        lastRewardAt: null,
        totalRewarded: 0,
      });
    }

    return {
      status: 'MINING_ACTIVE',
      startedAt: this.sessions.get(user.id)!.startedAt,
    };
  }

  /**
   * Get current mining status
   */
  async getStatus(identifier: string) {
    const user = await this.usersService.getByIdentifier(
      identifier,
    );

    const session = this.sessions.get(user.id);

    if (!session) {
      return { status: 'NOT_MINING' };
    }

    return {
      status: 'MINING_ACTIVE',
      startedAt: session.startedAt,
      lastRewardAt: session.lastRewardAt,
      totalRewarded: session.totalRewarded,
    };
  }

  /**
   * Get mining reward history
   * (Derived from wallet ledger)
   */
  async getHistory(identifier: string) {
    // Wallet service exposes ledger
    return this.walletService.getLedgerByIdentifier(
      identifier,
    );
  }

  /**
   * Internal tick (called by scheduler / cron)
   * Credits rewards if eligible
   */
  async processMiningTick(userId: string) {
    const session = this.sessions.get(userId);
    if (!session) return;

    const reward = this.miningRules.calculateReward(
      session.startedAt,
      session.lastRewardAt,
    );

    if (reward <= 0) return;

    // Credit reward via wallet (ledger append)
    await this.walletService['appendLedger'](
      userId,
      'REWARD',
      reward,
      'Mining reward',
    );

    session.lastRewardAt = new Date();
    session.totalRewarded += reward;
  }
}
