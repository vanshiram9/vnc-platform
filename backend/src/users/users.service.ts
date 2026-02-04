// ============================================================
// VNC PLATFORM — USERS SERVICE
// Grade: BANK + GOVERNMENT + ZERO-TRUST
// Phase-1 CORE (AUTHORITATIVE SERVICE)
// ============================================================

import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { User, UserRole, UserStatus } from './user.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {}

  /* ---------------------------------------------------------- */
  /* CREATE / FETCH                                             */
  /* ---------------------------------------------------------- */

  async findById(userId: string): Promise<User> {
    const user = await this.userRepo.findOne({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundException('USER_NOT_FOUND');
    }

    return user;
  }

  async findByPhone(phone: string): Promise<User | null> {
    return this.userRepo.findOne({
      where: { phone },
    });
  }

  async createUser(
    phone: string,
    role: UserRole = 'USER',
  ): Promise<User> {
    if (!phone) {
      throw new BadRequestException('PHONE_REQUIRED');
    }

    const existing = await this.findByPhone(phone);
    if (existing) {
      return existing;
    }

    const user = this.userRepo.create({
      phone,
      role,
      status: 'ACTIVE',
      frozen: false,
      riskFlag: false,
      kycVerified: false,
    });

    return this.userRepo.save(user);
  }

  /* ---------------------------------------------------------- */
  /* STATE MANAGEMENT                                           */
  /* ---------------------------------------------------------- */

  async freezeUser(userId: string): Promise<User> {
    const user = await this.findById(userId);

    user.status = 'FROZEN';
    user.frozen = true;

    return this.userRepo.save(user);
  }

  async unfreezeUser(userId: string): Promise<User> {
    const user = await this.findById(userId);

    user.status = 'ACTIVE';
    user.frozen = false;

    return this.userRepo.save(user);
  }

  async blockUser(userId: string): Promise<User> {
    const user = await this.findById(userId);

    user.status = 'BLOCKED';
    user.frozen = true;

    return this.userRepo.save(user);
  }

  /* ---------------------------------------------------------- */
  /* ROLE MANAGEMENT                                            */
  /* ---------------------------------------------------------- */

  async setRole(
    userId: string,
    role: UserRole,
  ): Promise<User> {
    const user = await this.findById(userId);
    user.role = role;
    return this.userRepo.save(user);
  }

  /* ---------------------------------------------------------- */
  /* COMPLIANCE FLAGS                                           */
  /* ---------------------------------------------------------- */

  async markKycVerified(
    userId: string,
  ): Promise<User> {
    const user = await this.findById(userId);
    user.kycVerified = true;
    return this.userRepo.save(user);
  }

  /* ---------------------------------------------------------- */
  /* ADMIN / AUDIT                                              */
  /* ---------------------------------------------------------- */

  async getAll(): Promise<User[]> {
    return this.userRepo.find({
      order: { createdAt: 'DESC' },
    });
  }

  async countAll(): Promise<number> {
    return this.userRepo.count();
  }
}
