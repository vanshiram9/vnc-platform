// ============================================================
// VNC PLATFORM — AUTH SERVICE
// File: backend/src/auth/auth.service.ts
// Grade: BANK + MILITARY + RBI
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

import { ZeroTrustGate } from '../security/zero.trust';
import { UsersService } from '../users/users.service';
import { OtpService } from './otp.service';
import { KillSwitch } from '../owner/kill.switch';

@Injectable()
export class AuthService {
  constructor(
    private readonly usersService: UsersService,
    private readonly otpService: OtpService,
    private readonly jwtService: JwtService,
    private readonly killSwitch: KillSwitch,
  ) {}

  /* ---------------------------------------------------------- */
  /* AUTH ENTRY — LOGIN REQUEST                                  */
  /* ---------------------------------------------------------- */

  async requestLogin(phone: string): Promise<void> {
    // 🔒 ZERO TRUST — AUTH ENTRY
    const zt = new ZeroTrustGate(this.killSwitch);
    const decision = zt.verify({
      userId: phone,
      action: 'AUTH',
    });

    if (!decision.allowed) {
      throw new UnauthorizedException(decision.reason);
    }

    // Validate phone existence
    const user = await this.usersService.findByPhone(phone);
    if (!user) {
      throw new UnauthorizedException('USER_NOT_FOUND');
    }

    // OTP generation (rate + retry limits enforced inside service)
    await this.otpService.generateOtp(user.id);
  }

  /* ---------------------------------------------------------- */
  /* AUTH VERIFY — OTP CONFIRM                                  */
  /* ---------------------------------------------------------- */

  async verifyOtp(
    phone: string,
    otp: string,
  ): Promise<{ accessToken: string }> {
    const user = await this.usersService.findByPhone(phone);
    if (!user) {
      throw new UnauthorizedException('USER_NOT_FOUND');
    }

    // 🔒 ZERO TRUST — PRE-AUTH DECISION
    const zt = new ZeroTrustGate(this.killSwitch);
    const decision = zt.verify({
      userId: user.id,
      role: user.role,
      userFrozen: user.isFrozen,
      action: 'AUTH',
    });

    if (!decision.allowed) {
      throw new UnauthorizedException(decision.reason);
    }

    // OTP validation
    const valid = await this.otpService.verifyOtp(user.id, otp);
    if (!valid) {
      throw new UnauthorizedException('INVALID_OTP');
    }

    // JWT issue (short-lived, stateless)
    const payload = {
      sub: user.id,
      role: user.role,
    };

    const accessToken = await this.jwtService.signAsync(payload);

    return { accessToken };
  }
}
