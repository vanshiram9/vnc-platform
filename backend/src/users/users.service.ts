// backend/src/users/users.service.ts

import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { User } from './user.entity';
import { SystemRole } from '../core/roles.states';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {}

  /**
   * Fetch user by identifier (phone/email)
   * Throws if not found.
   */
  async getByIdentifier(identifier: string): Promise<User> {
    const user = await this.userRepo.findOne({
      where: { identifier },
    });

    if (!user) {
      throw new NotFoundException('USER_NOT_FOUND');
    }

    return user;
  }

  /**
   * Ensure user exists.
   * Creates a minimal USER record if absent.
   * Used by auth/bootstrap flows.
   */
  async ensureUser(identifier: string): Promise<User> {
    let user = await this.userRepo.findOne({
      where: { identifier },
    });

    if (!user) {
      user = this.userRepo.create({
        identifier,
        role: SystemRole.USER,
        active: true,
      });
      await this.userRepo.save(user);
    }

    return user;
  }

  /**
   * Update last active timestamp
   * Lightweight, optional call by downstream modules
   */
  async touch(userId: string): Promise<void> {
    await this.userRepo.update(
      { id: userId },
      { lastActiveAt: new Date() },
    );
  }
}
