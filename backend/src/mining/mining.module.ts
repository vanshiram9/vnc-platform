// backend/src/mining/mining.module.ts

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { MiningController } from './mining.controller';
import { MiningService } from './mining.service';
import { MiningRules } from './mining.rules';

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
     * (No mining entity defined in tree)
     * Mining is rule/logic driven with wallet ledger effects
     */
    TypeOrmModule.forFeature([]),
  ],
  controllers: [MiningController],
  providers: [
    MiningService,
    MiningRules,
  ],
  exports: [
    /**
     * Export service for ads / admin visibility
     */
    MiningService,
  ],
})
export class MiningModule {}
