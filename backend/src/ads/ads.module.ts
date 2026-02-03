// backend/src/ads/ads.module.ts

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { AdsController } from './ads.controller';
import { AdsService } from './ads.service';
import { AdsAntiFraud } from './ads.antifraud';

import { WalletModule } from '../wallet/wallet.module';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    /**
     * Dependencies
     */
    WalletModule,
    UsersModule,

    /**
     * No dedicated ads entity defined in tree.
     * Ads are event/reward driven with ledger effects.
     */
    TypeOrmModule.forFeature([]),
  ],
  controllers: [AdsController],
  providers: [
    AdsService,
    AdsAntiFraud,
  ],
  exports: [
    /**
     * Export service for admin / analytics
     */
    AdsService,
  ],
})
export class AdsModule {}
