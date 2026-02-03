// backend/src/admin/admin.module.ts

import { Module } from '@nestjs/common';

import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';
import { ModerationLogic } from './moderation.logic';

import { UsersModule } from '../users/users.module';
import { KycModule } from '../kyc/kyc.module';
import { WalletModule } from '../wallet/wallet.module';
import { TradeModule } from '../trade/trade.module';
import { SupportModule } from '../support/support.module';
import { FaqModule } from '../faq/faq.module';

@Module({
  imports: [
    /**
     * Dependencies
     */
    UsersModule,
    KycModule,
    WalletModule,
    TradeModule,
    SupportModule,
    FaqModule,
  ],
  controllers: [AdminController],
  providers: [
    AdminService,
    ModerationLogic,
  ],
  exports: [
    /**
     * Export service for owner / compliance
     */
    AdminService,
  ],
})
export class AdminModule {}
