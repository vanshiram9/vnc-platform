// ============================================================
// VNC PLATFORM — IMPORT / EXPORT SERVICE
// File: backend/src/import_export/ie.service.ts
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

import { IEContract } from './ie.entity';
import { Wallet } from '../wallet/wallet.entity';
import { LedgerEntry } from '../wallet/ledger.entry';

import { UsersService } from '../users/users.service';
import { ZeroTrustGate } from '../security/zero.trust';
import { KillSwitch } from '../owner/kill.switch';

@Injectable()
export class IEService {
  constructor(
    @InjectRepository(IEContract)
    private readonly ieRepo: Repository<IEContract>,
    @InjectRepository(Wallet)
    private readonly walletRepo: Repository<Wallet>,
    private readonly usersService: UsersService,
    private readonly killSwitch: KillSwitch,
  ) {}

  /* ---------------------------------------------------------- */
  /* CREATE IE CONTRACT                                         */
  /* ---------------------------------------------------------- */

  async createContract(
    importerId: string,
    importerWalletId: string,
    exporterId: string,
    exporterWalletId: string,
    asset: string,
    amount: number,
    expiryAt: Date,
  ): Promise<IEContract> {
    if (amount <= 0) {
      throw new BadRequestException('INVALID_AMOUNT');
    }

    const importer = await this.usersService.findById(
      importerId,
    );
    const exporter = await this.usersService.findById(
      exporterId,
    );

    if (!importer || !exporter) {
      throw new NotFoundException('USER_NOT_FOUND');
    }

    const importerWallet =
      await this.walletRepo.findOne({
        where: { id: importerWalletId, userId: importer.id },
      });

    if (!importerWallet) {
      throw new NotFoundException(
        'IMPORTER_WALLET_NOT_FOUND',
      );
    }

    // 🔒 ZERO TRUST — CONTRACT CREATION
    const zt = new ZeroTrustGate(this.killSwitch);
    const decision = zt.verify({
      userId: importer.id,
      role: importer.role,
      userFrozen: importer.isFrozen,
      walletFrozen: importerWallet.isFrozen,
      action: 'IMPORT_EXPORT',
    });

    if (!decision.allowed) {
      throw new ForbiddenException(decision.reason);
    }

    // 🔐 LOCK FUNDS (LC ESCROW)
    const balance = await LedgerEntry.deriveBalance(
      importerWallet.id,
    );
    if (balance < amount) {
      throw new ForbiddenException(
        'INSUFFICIENT_BALANCE',
      );
    }

    await LedgerEntry.append({
      walletId: importerWallet.id,
      type: 'LOCK',
      amount,
      referenceType: 'IE_ESCROW',
      referenceId: importer.id,
    });

    const contract = this.ieRepo.create({
      importerId: importer.id,
      exporterId: exporter.id,
      importerWalletId,
      exporterWalletId,
      asset,
      amount,
      status: 'ESCROW_LOCKED',
      expiryAt,
    });

    return this.ieRepo.save(contract);
  }

  /* ---------------------------------------------------------- */
  /* RELEASE IE ESCROW (CONDITIONS MET)                          */
  /* ---------------------------------------------------------- */

  async releaseEscrow(
    contractId: string,
    operatorId: string,
  ): Promise<void> {
    const contract = await this.ieRepo.findOne({
      where: { id: contractId },
    });
    if (!contract) {
      throw new NotFoundException('CONTRACT_NOT_FOUND');
    }

    if (contract.status !== 'ESCROW_LOCKED') {
      throw new ForbiddenException(
        'ESCROW_NOT_RELEASABLE',
      );
    }

    const operator = await this.usersService.findById(
      operatorId,
    );
    if (!operator) {
      throw new NotFoundException('OPERATOR_NOT_FOUND');
    }

    // 🔒 ZERO TRUST — RELEASE
    const zt = new ZeroTrustGate(this.killSwitch);
    const decision = zt.verify({
      userId: operator.id,
      role: operator.role,
      userFrozen: operator.isFrozen,
      action: 'IMPORT_EXPORT',
    });

    if (!decision.allowed) {
      throw new ForbiddenException(decision.reason);
    }

    // 🔓 RELEASE TO EXPORTER
    await LedgerEntry.append({
      walletId: contract.exporterWalletId,
      type: 'CREDIT',
      amount: contract.amount,
      referenceType: 'IE_RELEASE',
      referenceId: contract.id,
    });

    contract.status = 'RELEASED';
    await this.ieRepo.save(contract);
  }

  /* ---------------------------------------------------------- */
  /* EXPIRE CONTRACT                                            */
  /* ---------------------------------------------------------- */

  async expireContract(
    contractId: string,
  ): Promise<void> {
    const contract = await this.ieRepo.findOne({
      where: { id: contractId },
    });
    if (!contract) return;

    if (contract.status !== 'ESCROW_LOCKED') return;

    // 🔁 RETURN FUNDS TO IMPORTER
    await LedgerEntry.append({
      walletId: contract.importerWalletId,
      type: 'UNLOCK',
      amount: contract.amount,
      referenceType: 'IE_EXPIRE',
      referenceId: contract.id,
    });

    contract.status = 'EXPIRED';
    await this.ieRepo.save(contract);
  }
}
