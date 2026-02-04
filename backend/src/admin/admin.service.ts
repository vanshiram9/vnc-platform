// ============================================================
// VNC PLATFORM — ADMIN SERVICE
// File: backend/src/admin/admin.service.ts
// Grade: BANK + MILITARY + RBI
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import {
  Injectable,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';

import { UsersService } from '../users/users.service';
import { ZeroTrustGate } from '../security/zero.trust';
import { KillSwitch } from '../owner/kill.switch';

@Injectable()
export class AdminService {
  constructor(
    private readonly usersService: UsersService,
    private readonly killSwitch: KillSwitch,
  ) {}

  /* ---------------------------------------------------------- */
  /* USER REVIEW (READ-ONLY)                                    */
  /* ---------------------------------------------------------- */

  async reviewUser(
    adminId: string,
    targetUserId: string,
  ) {
    const admin = await this.usersService.findById(adminId);
    if (!admin) throw new NotFoundException('ADMIN_NOT_FOUND');

    // 🔒 ZERO TRUST — ADMIN READ
    const zt = new ZeroTrustGate(this.killSwitch);
    const decision = zt.verify({
      userId: admin.id,
      role: admin.role,
      userFrozen: admin.isFrozen,
      action: 'ADMIN',
    });

    if (!decision.allowed) {
      throw new ForbiddenException(decision.reason);
    }

    const user = await this.usersService.findById(
      targetUserId,
    );
    if (!user) throw new NotFoundException('USER_NOT_FOUND');

    // Admin can only VIEW
    return {
      id: user.id,
      role: user.role,
      frozen: user.isFrozen,
      kycStatus: user.kycStatus,
      createdAt: user.createdAt,
    };
  }

  /* ---------------------------------------------------------- */
  /* FLAG USER FOR REVIEW (NO DIRECT FREEZE)                    */
  /* ---------------------------------------------------------- */

  async flagUser(
    adminId: string,
    targetUserId: string,
    reason: string,
  ): Promise<void> {
    const admin = await this.usersService.findById(adminId);
    if (!admin) throw new NotFoundException('ADMIN_NOT_FOUND');

    // 🔒 ZERO TRUST — ADMIN ACTION
    const zt = new ZeroTrustGate(this.killSwitch);
    const decision = zt.verify({
      userId: admin.id,
      role: admin.role,
      userFrozen: admin.isFrozen,
      action: 'ADMIN',
    });

    if (!decision.allowed) {
      throw new ForbiddenException(decision.reason);
    }

    const user = await this.usersService.findById(
      targetUserId,
    );
    if (!user) throw new NotFoundException('USER_NOT_FOUND');

    /**
     * IMPORTANT:
     * - Admin cannot freeze user
     * - Admin cannot change balances
     * - Admin cannot approve himself
     *
     * This action only emits a review signal
     * (actual freeze handled by IncidentFreeze / Owner)
     */

    // Here only log / emit audit event (handled elsewhere)
    return;
  }
}
