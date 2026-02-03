// backend/src/admin/admin.service.ts

import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';

import { UsersService } from '../users/users.service';
import { KycService } from '../kyc/kyc.service';
import { WalletService } from '../wallet/wallet.service';
import { TradeService } from '../trade/trade.service';
import { SupportService } from '../support/support.service';

import { ModerationLogic } from './moderation.logic';

@Injectable()
export class AdminService {
  constructor(
    private readonly usersService: UsersService,
    private readonly kycService: KycService,
    private readonly walletService: WalletService,
    private readonly tradeService: TradeService,
    private readonly supportService: SupportService,
    private readonly moderation: ModerationLogic,
  ) {}

  /**
   * Platform overview (lightweight snapshot)
   */
  async getOverview() {
    return {
      users: await this.usersService.countAll(),
      wallets: await this.walletService.countAll(),
      trades: await this.tradeService.countAll(),
      timestamp: new Date(),
    };
  }

  /**
   * Get all users (admin visibility)
   */
  async getAllUsers() {
    return this.usersService.getAll();
  }

  /**
   * Freeze or unfreeze a user account
   */
  async setUserFreeze(
    userId: string,
    freeze: boolean,
  ) {
    const user = await this.usersService.getById(
      userId,
    );
    if (!user) {
      throw new NotFoundException('USER_NOT_FOUND');
    }

    return this.moderation.applyFreeze(
      userId,
      freeze,
    );
  }

  /**
   * Get pending KYC applications
   */
  async getPendingKyc() {
    return this.kycService.getPending();
  }

  /**
   * Review KYC application
   */
  async reviewKyc(
    kycId: string,
    decision: 'APPROVE' | 'REJECT',
  ) {
    if (
      decision !== 'APPROVE' &&
      decision !== 'REJECT'
    ) {
      throw new BadRequestException(
        'INVALID_DECISION',
      );
    }

    return this.kycService.review(
      kycId,
      decision,
    );
  }

  /**
   * Get recent trades (audit view)
   */
  async getRecentTrades() {
    return this.tradeService.getRecent();
  }

  /**
   * Get support tickets (admin view)
   */
  async getSupportTickets() {
    return this.supportService.getAllTickets();
  }
}
