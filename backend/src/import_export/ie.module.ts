// backend/src/import_export/ie.module.ts

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { IeController } from './ie.controller';
import { IeService } from './ie.service';
import { EscrowLcLogic } from './escrow.lc.logic';

import { TradeModule } from '../trade/trade.module';
import { WalletModule } from '../wallet/wallet.module';
import { KycModule } from '../kyc/kyc.module';

@Module({
  imports: [
    /**
     * Dependencies
     */
    TradeModule,
    WalletModule,
    KycModule,

    /**
     * No separate entity defined for IE in tree
     * Uses trade + escrow logic
     */
    TypeOrmModule.forFeature([]),
  ],
  controllers: [IeController],
  providers: [
    IeService,
    EscrowLcLogic,
  ],
  exports: [
    /**
     * Export service for admin / compliance
     */
    IeService,
  ],
})
export class IeModule {}
