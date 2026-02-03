// ============================================================
// VNC PLATFORM — WALLET SERVICE
// File: backend/src/wallet/wallet.service.ts
// Grade: BANK + MILITARY + RBI
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import {
  Injectable,
  ForbiddenException,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Wallet } from './wallet.entity';
import { LedgerEntry } from './ledger.entry';

import { UsersService } from '../users/users.service';
import { ZeroTrustGate } from '../security/zero.trust';
import { KillSwitch } from '../owner/kill.switch';

@Injectable()
export class WalletService {
  constructor(
    @InjectRepository(Wallet)
    private readonly walletRepo: Repository<Wallet>,
    @InjectRepository(LedgerEntry)
    private readonly ledgerRepo: Repository<LedgerEntry>,
    private readonly usersService: UsersService,
    private readonly killSwitch: KillSwitch,
  ) {}

  /* ---------------------------------------------------------- */
  /* WALLET FETCH (NO AUTO-MUTATION)                             */
  /* ---------------------------------------------------------- */

  async getWallet(
    userId: string,
    currency: string,
  ): Promise<Wallet> {
    const user = await this.usersService.findById(userId);
    if (!user) throw new NotFoundException('USER_NOT_FOUND');

    // 🔒 ZERO TRUST — READ ALSO VERIFIED
    const zt = new ZeroTrustGate(this.killSwitch);
    const decision = zt.verify({
      userId: user.id,
      role: user.role,
      userFrozen: user.isFrozen,
      action: 'WALLET',
    });

    if (!decision.allowed) {
      throw new ForbiddenException(decision.reason);
    }

    const wallet = await this.walletRepo.findOne({
      where: { userId: user.id, currency },
    });

    if (!wallet) {
      throw new NotFoundException('WALLET_NOT_FOUND');
    }

    return wallet;
  }

  /* ---------------------------------------------------------- */
  /* BALANCE DERIVATION (LEDGER ONLY)                            */
  /* ---------------------------------------------------------- */

  async deriveBalance(walletId: string): Promise<number> {
    const entries = await this.ledgerRepo.find({
      where: { walletId },
      order: { createdAt: 'ASC' },
    });

    let balance = 0;

    for (const e of entries) {
      switch (e.type) {
        case 'CREDIT':
        case 'UNLOCK':
          balance += Number(e.amount);
          break;
        case 'DEBIT':
        case 'LOCK':
        case 'FEE':
          balance -= Number(e.amount);
          break;
      }
    }

    return balance;
  }

  /* ---------------------------------------------------------- */
  /* LOCK COINS (STAKING / TIME-LOCK)                            */
  /* ---------------------------------------------------------- */

  async lockCoins(
    userId: string,
    walletId: string,
    amount: number,
  ): Promise<void> {
    if (amount <= 0) {
      throw new BadRequestException('INVALID_AMOUNT');
    }

    const user = await this.usersService.findById(userId);
    if (!user) throw new NotFoundException('USER_NOT_FOUND');

    const wallet = await this.walletRepo.findOne({
      where: { id: walletId, userId: user.id },
    });
    if (!wallet) throw new NotFoundException('WALLET_NOT_FOUND');

    // 🔒 ZERO TRUST — FINANCIAL ACTION
    const zt = new ZeroTrustGate(this.killSwitch);
    const decision = zt.verify({
      userId: user.id,
      role: user.role,
      userFrozen: user.isFrozen,
      walletFrozen: wallet.isFrozen,
      action: 'WALLET',
    });

    if (!decision.allowed) {
      throw new ForbiddenException(decision.reason);
    }

    const balance = await this.deriveBalance(wallet.id);
    if (balance < amount) {
      throw new ForbiddenException('INSUFFICIENT_BALANCE');
    }

    await LedgerEntry.append({
      walletId: wallet.id,
      type: 'LOCK',
      amount,
      referenceType: 'STAKING',
      referenceId: user.id,
    });
  }

  /* ---------------------------------------------------------- */
  /* WITHDRAW                                                   */
  /* ---------------------------------------------------------- */

  async withdraw(
    userId: string,
    walletId: string,
    amount: number,
  ): Promise<void> {
    if (amount <= 0) {
      throw new BadRequestException('INVALID_AMOUNT');
    }

    const user = await this.usersService.findById(userId);
    if (!user) throw new NotFoundException('USER_NOT_FOUND');

    const wallet = await this.walletRepo.findOne({
      where: { id: walletId, userId: user.id },
    });
    if (!wallet) throw new NotFoundException('WALLET_NOT_FOUND');

    // 🔒 ZERO TRUST — WITHDRAW
    const zt = new ZeroTrustGate(this.killSwitch);
    const decision = zt.verify({
      userId: user.id,
      role: user.role,
      userFrozen: user.isFrozen,
      walletFrozen: wallet.isFrozen,
      action: 'WITHDRAW',
    });

    if (!decision.allowed) {
      throw new ForbiddenException(decision.reason);
    }

    const balance = await this.deriveBalance(wallet.id);
    if (balance < amount) {
      throw new ForbiddenException('INSUFFICIENT_BALANCE');
    }

    await LedgerEntry.append({
      walletId: wallet.id,
      type: 'DEBIT',
      amount,
      referenceType: 'WITHDRAW',
      referenceId: user.id,
    });
  }
}
