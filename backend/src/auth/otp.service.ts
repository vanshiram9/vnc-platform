// backend/src/auth/otp.service.ts

import { Injectable } from '@nestjs/common';
import * as crypto from 'crypto';

/**
 * In-memory OTP store
 * NOTE:
 * - This is process-local by design.
 * - In production scale, this can be replaced by Redis
 *   WITHOUT changing AuthService or controller.
 */
type OtpRecord = {
  hash: string;
  expiresAt: number;
  attempts: number;
};

const OTP_TTL_MS = 5 * 60 * 1000; // 5 minutes
const MAX_ATTEMPTS = 5;

@Injectable()
export class OtpService {
  private readonly store = new Map<string, OtpRecord>();

  /**
   * Generate & send OTP
   */
  async sendOtp(identifier: string): Promise<void> {
    const otp = this.generateOtp();
    const hash = this.hashOtp(otp);

    const record: OtpRecord = {
      hash,
      expiresAt: Date.now() + OTP_TTL_MS,
      attempts: 0,
    };

    this.store.set(identifier, record);

    /**
     * Delivery abstraction
     * Actual SMS / Email provider is injected later
     * (no hard dependency here)
     */
    // eslint-disable-next-line no-console
    console.info(
      `[VNC PLATFORM][OTP] Sent OTP to ${identifier}: ${otp}`,
    );
  }

  /**
   * Verify OTP
   */
  async verifyOtp(
    identifier: string,
    otp: string,
  ): Promise<boolean> {
    const record = this.store.get(identifier);

    if (!record) {
      return false;
    }

    // Expired
    if (Date.now() > record.expiresAt) {
      this.store.delete(identifier);
      return false;
    }

    // Attempt limit
    if (record.attempts >= MAX_ATTEMPTS) {
      this.store.delete(identifier);
      return false;
    }

    record.attempts += 1;

    const incomingHash = this.hashOtp(otp);

    if (incomingHash !== record.hash) {
      return false;
    }

    // Success → consume OTP
    this.store.delete(identifier);
    return true;
  }

  /* ----------------------- */
  /* Internal helpers        */
  /* ----------------------- */

  private generateOtp(): string {
    // 6-digit numeric OTP
    return crypto.randomInt(100000, 999999).toString();
  }

  private hashOtp(otp: string): string {
    return crypto
      .createHash('sha256')
      .update(otp)
      .digest('hex');
  }
}
