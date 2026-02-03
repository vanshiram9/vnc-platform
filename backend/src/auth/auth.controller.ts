// backend/src/auth/auth.controller.ts

import {
  Body,
  Controller,
  HttpCode,
  HttpStatus,
  Post,
} from '@nestjs/common';

import { AuthService } from './auth.service';

interface LoginRequest {
  identifier: string; // phone / email
}

interface OtpVerifyRequest {
  identifier: string;
  otp: string;
}

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  /**
   * Step 1: Login / Register entry
   * Sends OTP to user identifier
   */
  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(@Body() body: LoginRequest) {
    const { identifier } = body;

    return this.authService.requestOtp(identifier);
  }

  /**
   * Step 2: Verify OTP
   * Issues JWT on success
   */
  @Post('verify-otp')
  @HttpCode(HttpStatus.OK)
  async verifyOtp(@Body() body: OtpVerifyRequest) {
    const { identifier, otp } = body;

    return this.authService.verifyOtpAndIssueToken(
      identifier,
      otp,
    );
  }
}
