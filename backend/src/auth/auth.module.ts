// backend/src/auth/auth.module.ts

import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';

import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { OtpService } from './otp.service';
import { JwtStrategy } from './jwt.strategy';
import { AuthGuards } from './guards';

import { SecretProvider } from '../config/secrets/secret.provider';

@Module({
  imports: [
    PassportModule.register({ defaultStrategy: 'jwt' }),

    JwtModule.registerAsync({
      inject: [SecretProvider],
      useFactory: async (secrets: SecretProvider) => ({
        secret: secrets.jwtSecret(),
        signOptions: {
          expiresIn: process.env.JWT_EXPIRES_IN,
        },
      }),
    }),
  ],
  controllers: [AuthController],
  providers: [
    AuthService,
    OtpService,
    JwtStrategy,
    AuthGuards,
  ],
  exports: [
    AuthService,
    JwtModule,
    PassportModule,
  ],
})
export class AuthModule {}
