// ============================================================
// VNC PLATFORM — AUTH CONTROLLER
// Phase-1 CORE (COMPILE-SAFE)
// ============================================================

import {
  Controller,
  Post,
  Body,
} from '@nestjs/common';

import { AuthService } from './auth.service';

@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
  ) {}

  /* --------------------------------------------------------- */
  /* REQUEST OTP                                               */
  /* --------------------------------------------------------- */

  @Post('request-otp')
  async requestOtp(
    @Body('phone') phone: string,
  ): Promise<{ success: true }> {
    return this.authService.requestOtp(phone);
  }

  /* --------------------------------------------------------- */
  /* VERIFY OTP + ISSUE TOKEN                                  */
  /* --------------------------------------------------------- */

  @Post('verify-otp')
  async verifyOtp(
    @Body('phone') phone: string,
    @Body('code') code: string,
  ): Promise<{ accessToken: string }> {
    return this.authService.verifyOtpAndIssueToken(
      phone,
      code,
    );
  }
}
