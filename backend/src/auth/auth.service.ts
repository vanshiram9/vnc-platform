// backend/src/auth/auth.service.ts

import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

import { OtpService } from './otp.service';

/**
 * AuthService
 * Handles OTP-based authentication and JWT issuance.
 */
@Injectable()
export class AuthService {
  constructor(
    private readonly otpService: OtpService,
    private readonly jwtService: JwtService,
  ) {}

  /**
   * Step 1: Request OTP
   * Creates / refreshes OTP for identifier.
   */
  async requestOtp(identifier: string) {
    if (!identifier || identifier.trim().length === 0) {
      throw new UnauthorizedException('INVALID_IDENTIFIER');
    }

    await this.otpService.sendOtp(identifier);

    return {
      success: true,
      message: 'OTP_SENT',
    };
  }

  /**
   * Step 2: Verify OTP & Issue JWT
   */
  async verifyOtpAndIssueToken(
    identifier: string,
    otp: string,
  ) {
    const valid = await this.otpService.verifyOtp(
      identifier,
      otp,
    );

    if (!valid) {
      throw new UnauthorizedException('INVALID_OTP');
    }

    /**
     * JWT payload is minimal by design
     * Extended identity is fetched downstream when needed
     */
    const payload = {
      sub: identifier,
      iss: 'VNC-PLATFORM',
    };

    const token = await this.jwtService.signAsync(payload);

    return {
      success: true,
      token,
      token_type: 'Bearer',
    };
  }
}
