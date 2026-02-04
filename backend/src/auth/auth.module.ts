// ============================================================
// VNC PLATFORM — AUTH MODULE
// Phase-1 CORE WIRING
// ============================================================

import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';

import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';

import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    UsersModule,

    JwtModule.register({
      secret: process.env.JWT_SECRET || 'DEV_SECRET_ONLY',
      signOptions: {
        expiresIn: '15m',
      },
    }),
  ],

  providers: [
    AuthService,
  ],

  controllers: [
    AuthController,
  ],

  exports: [
    AuthService,
  ],
})
export class AuthModule {}
