// ============================================================
// VNC PLATFORM — AUTH SERVICE
// Phase-1 CORE (OTP + USER WIRING)
// ============================================================

import {
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

import { UsersService } from '../users/users.service';
import { User } from '../users/user.entity';

/* ----------------------------------------------------------- */
/* SIMPLE IN-MEMORY OTP STORE (PHASE-1 ONLY)                   */
/* ----------------------------------------------------------- */

interface OtpRecord {
  code: string;
  expiresAt: number;
}

@Injectable()
export class AuthService {
  private readonly otpStore = new Map<
    string,
    OtpRecord
  >();

  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
  ) {}

  /* --------------------------------------------------------- */
  /* OTP GENERATION                                            */
  /* --------------------------------------------------------- */

  async requestOtp(
    phone: string,
  ): Promise<{ success: true }> {
    if (!phone) {
      throw new UnauthorizedException(
        'PHONE_REQUIRED',
      );
    }

    // Ensure user exists (idempotent)
    await this.usersService.createUser(phone);

    const code = this.generateOtp();
    const expiresAt =
      Date.now() + 5 * 60 * 1000; // 5 min

    this.otpStore.set(phone, {
      code,
      expiresAt,
    });

    // NOTE:
    // In Phase-1 we DO NOT send SMS.
    // OTP delivery is out of scope here.

    return { success: true };
  }

  /* --------------------------------------------------------- */
  /* OTP VERIFICATION + TOKEN                                  */
  /* --------------------------------------------------------- */

  async verifyOtpAndIssueToken(
    phone: string,
    code: string,
  ): Promise<{ accessToken: string }> {
    const record = this.otpStore.get(phone);

    if (
      !record ||
      record.code !== code ||
      record.expiresAt < Date.now()
    ) {
      throw new UnauthorizedException(
        'INVALID_OTP',
      );
    }

    const user =
      await this.usersService.findByPhone(phone);

    if (!user) {
      throw new UnauthorizedException(
        'USER_NOT_FOUND',
      );
    }

    // OTP used → invalidate
    this.otpStore.delete(phone);

    const payload = {
      sub: user.id,
      role: user.role,
    };

    const accessToken =
      this.jwtService.sign(payload);

    return { accessToken };
  }

  /* --------------------------------------------------------- */
  /* INTERNAL HELPERS                                          */
  /* --------------------------------------------------------- */

  private generateOtp(): string {
    return Math.floor(
      100000 + Math.random() * 900000,
    ).toString();
  }
}
