// backend/src/merchant/merchant.module.ts

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { MerchantController } from './merchant.controller';
import { MerchantService } from './merchant.service';
import { Merchant } from './merchant.entity';

import { UsersModule } from '../users/users.module';
import { WalletModule } from '../wallet/wallet.module';
import { KycModule } from '../kyc/kyc.module';

@Module({
  imports: [
    /**
     * Entity registration
     */
    TypeOrmModule.forFeature([Merchant]),

    /**
     * Dependencies
     */
    UsersModule,
    WalletModule,
    KycModule,
  ],
  controllers: [MerchantController],
  providers: [MerchantService],
  exports: [
    /**
     * Export service for trade / ads / admin
     */
    MerchantService,
  ],
})
export class MerchantModule {}
