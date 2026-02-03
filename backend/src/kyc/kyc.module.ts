// backend/src/kyc/kyc.module.ts

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { KycController } from './kyc.controller';
import { KycService } from './kyc.service';
import { Kyc } from './kyc.entity';

import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    /**
     * Entity registration
     */
    TypeOrmModule.forFeature([Kyc]),

    /**
     * User identity dependency
     */
    UsersModule,
  ],
  controllers: [KycController],
  providers: [KycService],
  exports: [
    /**
     * Export service for wallet, trade, admin, compliance
     */
    KycService,
  ],
})
export class KycModule {}
