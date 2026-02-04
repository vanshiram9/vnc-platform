// ============================================================
// VNC PLATFORM — TRADE SERVICE
// File: backend/src/trade/trade.service.ts
// Grade: BANK + MILITARY + RBI
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import {
  Injectable,
  ForbiddenException,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Trade } from './trade.entity';
import { Wallet } from '../wallet/wallet.entity';
import { LedgerEntry } from '../wallet/ledger.entry';

import { UsersService } from '../users/users.service';
import { ZeroTrustGate } from '../security/zero.trust';
import { KillSwitch } from '../owner/kill.switch';

@Injectable()
export class TradeService {
  constructor(
    @InjectRepository(Trade)
    private readonly tradeRepo: Repository<Trade>,
    @InjectRepository(Wallet)
    private readonly walletRepo: Repository<Wallet>,
    private readonly usersService: UsersService,
    private readonly killSwitch: KillSwitch,
  ) {}

  /* ---------------------------------------------------------- */
  /* CREATE TRADE                                               */
  /* ---------------------------------------------------------- */

  async createTrade(
    userId: string,
    walletId: string,
    side: 'BUY' | 'SELL',
    asset: string,
    quantity: number,
    price: number,
  ): Promise<Trade> {
    if (quantity <= 0 || price <= 0) {
      throw new BadRequestException('INVALID_TRADE_PARAMS');
    }

    const user = await this.usersService.findById(userId);
    if (!user) throw new NotFoundException('USER_NOT_FOUND');

    const wallet = await this.walletRepo.findOne({
      where: { id: walletId, userId: user.id },
    });
    if (!wallet) throw new NotFoundException('WALLET_NOT_FOUND');

    // 🔒 ZERO TRUST — TRADE ENTRY
    const zt = new ZeroTrustGate(this.killSwitch);
    const decision = zt.verify({
      userId: user.id,
      role: user.role,
      userFrozen: user.isFrozen,
      walletFrozen: wallet.isFrozen,
      action: 'TRADE',
    });

    if (!decision.allowed) {
      throw new ForbiddenException(decision.reason);
    }

    // 🔐 SELL requires escrow lock via ledger
    if (side === 'SELL') {
      const balance = await LedgerEntry.deriveBalance(
        wallet.id,
      );

      if (balance < quantity) {
        throw new ForbiddenException(
          'INSUFFICIENT_BALANCE',
        );
      }

      await LedgerEntry.append({
        walletId: wallet.id,
        type: 'LOCK',
        amount: quantity,
        referenceType: 'TRADE_ESCROW',
        referenceId: user.id,
      });
    }

    const trade = this.tradeRepo.create({
      userId: user.id,
      walletId: wallet.id,
      side,
      asset,
      quantity,
      price,
      status: 'OPEN',
    });

    return this.tradeRepo.save(trade);
  }

  /* ---------------------------------------------------------- */
  /* CANCEL TRADE                                               */
  /* ---------------------------------------------------------- */

  async cancelTrade(
    userId: string,
    tradeId: string,
  ): Promise<void> {
    const trade = await this.tradeRepo.findOne({
      where: { id: tradeId, userId },
    });
    if (!trade) throw new NotFoundException('TRADE_NOT_FOUND');

    // 🔒 ZERO TRUST — CANCEL
    const zt = new ZeroTrustGate(this.killSwitch);
    const decision = zt.verify({
      userId,
      action: 'TRADE',
    });

    if (!decision.allowed) {
      throw new ForbiddenException(decision.reason);
    }

    if (trade.status !== 'OPEN') {
      throw new ForbiddenException(
        'TRADE_NOT_CANCELLABLE',
      );
    }

    trade.status = 'CANCELLED';
    await this.tradeRepo.save(trade);

    // 🔓 Unlock escrow if SELL
    if (trade.side === 'SELL') {
      await LedgerEntry.append({
        walletId: trade.walletId,
        type: 'UNLOCK',
        amount: trade.quantity,
        referenceType: 'TRADE_CANCEL',
        referenceId: trade.id,
      });
    }
  }
  }
