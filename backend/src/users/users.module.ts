// backend/src/users/users.module.ts

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { UsersController } from './users.controller';
import { UsersService } from './users.service';
import { User } from './user.entity';

@Module({
  imports: [
    /**
     * Entity registration
     */
    TypeOrmModule.forFeature([User]),
  ],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [
    /**
     * Export service for cross-module usage
     * (auth, wallet, kyc, admin)
     */
    UsersService,
  ],
})
export class UsersModule {}
