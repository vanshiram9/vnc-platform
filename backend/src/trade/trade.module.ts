// backend/src/trade/trade.module.ts

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { TradeController } from './trade.controller';
import { TradeService } from './trade.service';
import { Trade } from './trade.entity';

import { WalletModule } from '../wallet/wallet.module';
import { UsersModule } from '../users/users.module';
import { KycModule } from '../kyc/kyc.module';

@Module({
  imports: [
    /**
     * Entity registration
     */
    TypeOrmModule.forFeature([Trade]),

    /**
     * Dependencies
     */
    WalletModule,
    UsersModule,
    KycModule,
  ],
  controllers: [TradeController],
  providers: [TradeService],
  exports: [
    /**
     * Export service for admin / import_export
     */
    TradeService,
  ],
})
export class TradeModule {}
