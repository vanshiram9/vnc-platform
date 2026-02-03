// backend/src/trade/trade.service.ts

import {
  Injectable,
  BadRequestException,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Trade } from './trade.entity';
import { WalletService } from '../wallet/wallet.service';
import { UsersService } from '../users/users.service';
import { KycService } from '../kyc/kyc.service';
import { RiskAction, evaluateRisk } from '../core/risk.matrix';
import { FeatureFlag } from '../core/feature.flags';
import { getCountryRule } from '../core/country.rules';

interface CreateTradePayload {
  type: 'BUY' | 'SELL';
  asset: string;
  amount: number;
  price: number;
}

@Injectable()
export class TradeService {
  constructor(
    @InjectRepository(Trade)
    private readonly tradeRepo: Repository<Trade>,
    private readonly walletService: WalletService,
    private readonly usersService: UsersService,
    private readonly kycService: KycService,
  ) {}

  /**
   * Create a new trade order
   */
  async createTrade(
    identifier: string,
    payload: CreateTradePayload,
  ): Promise<Trade> {
    if (
      payload.amount <= 0 ||
      payload.price <= 0
    ) {
      throw new BadRequestException('INVALID_TRADE_PARAMS');
    }

    const user = await this.usersService.getByIdentifier(
      identifier,
    );

    // KYC gate
    const kyc = await this.kycService.getByIdentifier(
      identifier,
    );
    if (kyc.status !== 'APPROVED') {
      throw new ForbiddenException('KYC_REQUIRED');
    }

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

    // Escrow lock (simplified)
    const escrowAmount =
      payload.type === 'SELL'
        ? payload.amount
        : payload.amount * payload.price;

    await this.walletService.lockCoins(
      identifier,
      escrowAmount,
    );

    const trade = this.tradeRepo.create({
      userId: user.id,
      type: payload.type,
      asset: payload.asset,
      amount: payload.amount,
      price: payload.price,
      status: 'OPEN',
    });

    return this.tradeRepo.save(trade);
  }

  /**
   * Get trades for a user
   */
  async getTradesByIdentifier(
    identifier: string,
  ): Promise<Trade[]> {
    const user = await this.usersService.getByIdentifier(
      identifier,
    );

    return this.tradeRepo.find({
      where: { userId: user.id },
      order: { createdAt: 'DESC' },
    });
  }

  /**
   * Get escrow / settlement status
   */
  async getEscrowStatus(
    tradeId: string,
  ): Promise<Trade> {
    const trade = await this.tradeRepo.findOne({
      where: { id: tradeId },
    });

    if (!trade) {
      throw new NotFoundException('TRADE_NOT_FOUND');
    }

    return trade;
  }
}
