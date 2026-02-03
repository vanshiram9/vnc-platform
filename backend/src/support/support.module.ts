// backend/src/support/support.module.ts

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { SupportController } from './support.controller';
import { SupportService } from './support.service';
import { SupportTicket } from './ticket.entity';

import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    /**
     * Entity registration
     */
    TypeOrmModule.forFeature([SupportTicket]),

    /**
     * Dependencies
     */
    UsersModule,
  ],
  controllers: [SupportController],
  providers: [SupportService],
  exports: [
    /**
     * Export service for admin visibility
     */
    SupportService,
  ],
})
export class SupportModule {}
