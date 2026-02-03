// backend/src/merchant/merchant.service.ts

import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Merchant } from './merchant.entity';
import { UsersService } from '../users/users.service';
import { KycService } from '../kyc/kyc.service';
import { SystemRole } from '../core/roles.states';

interface MerchantProfileUpdate {
  name?: string;
  businessType?: string;
  website?: string;
}

@Injectable()
export class MerchantService {
  constructor(
    @InjectRepository(Merchant)
    private readonly merchantRepo: Repository<Merchant>,
    private readonly usersService: UsersService,
    private readonly kycService: KycService,
  ) {}

  /**
   * Get merchant by user identifier
   * Ensures merchant record exists
   */
  async getByIdentifier(identifier: string): Promise<Merchant> {
    const user = await this.usersService.getByIdentifier(
      identifier,
    );

    let merchant = await this.merchantRepo.findOne({
      where: { userId: user.id },
    });

    if (!merchant) {
      // Merchant role required
      if (user.role !== SystemRole.MERCHANT) {
        throw new ForbiddenException(
          'NOT_A_MERCHANT',
        );
      }

      merchant = this.merchantRepo.create({
        userId: user.id,
        name: '',
        businessType: '',
        website: '',
        active: true,
      });

      merchant = await this.merchantRepo.save(merchant);
    }

    return merchant;
  }

  /**
   * Update merchant profile
   */
  async updateProfile(
    identifier: string,
    payload: MerchantProfileUpdate,
  ): Promise<Merchant> {
    const user = await this.usersService.getByIdentifier(
      identifier,
    );

    if (user.role !== SystemRole.MERCHANT) {
      throw new ForbiddenException(
        'NOT_A_MERCHANT',
      );
    }

    // KYC gate for merchant updates
    const kyc = await this.kycService.getByIdentifier(
      identifier,
    );
    if (kyc.status !== 'APPROVED') {
      throw new ForbiddenException(
        'KYC_REQUIRED',
      );
    }

    const merchant = await this.getByIdentifier(
      identifier,
    );

    merchant.name =
      payload.name ?? merchant.name;
    merchant.businessType =
      payload.businessType ?? merchant.businessType;
    merchant.website =
      payload.website ?? merchant.website;

    return this.merchantRepo.save(merchant);
  }
}
