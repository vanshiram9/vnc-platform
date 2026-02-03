// backend/src/wallet/wallet.module.ts

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { WalletController } from './wallet.controller';
import { WalletService } from './wallet.service';

import { Wallet } from './wallet.entity';
import { LedgerEntry } from './ledger.entry';

import { UsersModule } from '../users/users.module';
import { KycModule } from '../kyc/kyc.module';

@Module({
  imports: [
    /**
     * Entity registration
     */
    TypeOrmModule.forFeature([
      Wallet,
      LedgerEntry,
    ]),

    /**
     * Identity & compliance dependencies
     */
    UsersModule,
    KycModule,
  ],
  controllers: [WalletController],
  providers: [WalletService],
  exports: [
    /**
     * Export wallet service for mining, trade, ads
     */
    WalletService,
  ],
})
export class WalletModule {}
