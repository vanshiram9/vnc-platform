// backend/src/owner/owner.module.ts

import { Module } from '@nestjs/common';

import { OwnerController } from './owner.controller';
import { OwnerService } from './owner.service';
import { KillSwitch } from './kill.switch';

import { AdminModule } from '../admin/admin.module';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    /**
     * Dependencies
     */
    AdminModule,
    UsersModule,
  ],
  controllers: [OwnerController],
  providers: [
    OwnerService,
    KillSwitch,
  ],
  exports: [
    /**
     * Export service for system/final layer
     */
    OwnerService,
  ],
})
export class OwnerModule {}
