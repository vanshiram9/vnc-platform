// backend/src/wallet/wallet.service.ts

import {
  Injectable,
  BadRequestException,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Wallet } from './wallet.entity';
import { LedgerEntry } from './ledger.entry';

import { UsersService } from '../users/users.service';
import { KycService } from '../kyc/kyc.service';
import { RiskAction, evaluateRisk } from '../core/risk.matrix';
import { FeatureFlag } from '../core/feature.flags';
import { getCountryRule } from '../core/country.rules';

@Injectable()
export class WalletService {
  constructor(
    @InjectRepository(Wallet)
    private readonly walletRepo: Repository<Wallet>,
    @InjectRepository(LedgerEntry)
    private readonly ledgerRepo: Repository<LedgerEntry>,
    private readonly usersService: UsersService,
    private readonly kycService: KycService,
  ) {}

  /**
   * Fetch wallet by user identifier
   * Ensures wallet existence
   */
  async getWalletByIdentifier(identifier: string): Promise<Wallet> {
    const user = await this.usersService.getByIdentifier(identifier);

    let wallet = await this.walletRepo.findOne({
      where: { userId: user.id },
    });

    if (!wallet) {
      wallet = this.walletRepo.create({
        userId: user.id,
        balance: 0,
        lockedBalance: 0,
        frozen: false,
      });
      wallet = await this.walletRepo.save(wallet);
    }

    return wallet;
  }

  /**
   * Fetch ledger entries for a user
   */
  async getLedgerByIdentifier(
    identifier: string,
  ): Promise<LedgerEntry[]> {
    const user = await this.usersService.getByIdentifier(identifier);

    return this.ledgerRepo.find({
      where: { userId: user.id },
      order: { createdAt: 'DESC' },
    });
  }

  /**
   * Lock coins (staking / time-lock)
   */
  async lockCoins(
    identifier: string,
    amount: number,
  ): Promise<Wallet> {
    if (amount <= 0) {
      throw new BadRequestException('INVALID_AMOUNT');
    }

    const user = await this.usersService.getByIdentifier(identifier);
    const wallet = await this.getWalletByIdentifier(identifier);

    this.assertWalletUsable(user, wallet);

    if (wallet.balance < amount) {
      throw new BadRequestException('INSUFFICIENT_BALANCE');
    }

    wallet.balance -= amount;
    wallet.lockedBalance += amount;

    await this.walletRepo.save(wallet);

    await this.appendLedger(
      user.id,
      'LOCK',
      amount,
      'Coins locked',
    );

    return wallet;
  }

  /**
   * Withdraw coins
   */
  async withdraw(
    identifier: string,
    amount: number,
  ): Promise<Wallet> {
    if (amount <= 0) {
      throw new BadRequestException('INVALID_AMOUNT');
    }

    const user = await this.usersService.getByIdentifier(identifier);
    const wallet = await this.getWalletByIdentifier(identifier);

    this.assertWalletUsable(user, wallet);

    if (wallet.balance < amount) {
      throw new BadRequestException('INSUFFICIENT_BALANCE');
    }

    wallet.balance -= amount;

    await this.walletRepo.save(wallet);

    await this.appendLedger(
      user.id,
      'WITHDRAW',
      amount,
      'Coins withdrawn',
    );

    return wallet;
  }

  /* ----------------------- */
  /* Internal helpers        */
  /* ----------------------- */

  /**
   * Wallet usability gate
   * Applies country rules, KYC, and risk matrix
   */
  private async assertWalletUsable(
    user: { id: string; frozen?: boolean; countryCode?: string },
    wallet: Wallet,
  ): Promise<void> {
    if (user.frozen || wallet.frozen) {
      throw new ForbiddenException('WALLET_FROZEN');
    }

    // Country rule
    const countryRule = getCountryRule(user.countryCode || '');

    // KYC signal
    let kycVerified = true;
    try {
      const kyc = await this.kycService.getByIdentifier(
        user.id,
      );
      kycVerified = kyc.status === 'APPROVED';
    } catch {
      kycVerified = false;
    }

    const risk = evaluateRisk({
      countryRule,
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
      signals: {
        kycVerified,
      },
    });

    if (risk.action === RiskAction.FREEZE) {
      throw new ForbiddenException('RISK_FREEZE');
    }
  }

  /**
   * Append immutable ledger entry
   */
  private async appendLedger(
    userId: string,
    type: 'LOCK' | 'WITHDRAW',
    amount: number,
    note: string,
  ): Promise<void> {
    const entry = this.ledgerRepo.create({
      userId,
      type,
      amount,
      note,
    });

    await this.ledgerRepo.save(entry);
  }
    }
