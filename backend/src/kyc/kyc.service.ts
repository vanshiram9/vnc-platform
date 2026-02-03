// backend/src/kyc/kyc.service.ts

import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Kyc } from './kyc.entity';
import { UsersService } from '../users/users.service';
import {
  getCountryRule,
} from '../core/country.rules';

interface KycSubmitPayload {
  documentType: string;
  documentNumber: string;
  documentData?: Record<string, any>;
}

@Injectable()
export class KycService {
  constructor(
    @InjectRepository(Kyc)
    private readonly kycRepo: Repository<Kyc>,
    private readonly usersService: UsersService,
  ) {}

  /**
   * Submit or update KYC for a user
   */
  async submitKyc(
    identifier: string,
    payload: KycSubmitPayload,
  ): Promise<Kyc> {
    const user = await this.usersService.getByIdentifier(
      identifier,
    );

    // Country rule enforcement (basic gate)
    const countryRule = getCountryRule(
      user.countryCode,
    );

    if (countryRule.policy === 'BLOCK') {
      throw new ForbiddenException(
        'KYC_NOT_ALLOWED_IN_COUNTRY',
      );
    }

    let record = await this.kycRepo.findOne({
      where: { userId: user.id },
    });

    if (!record) {
      record = this.kycRepo.create({
        userId: user.id,
        documentType: payload.documentType,
        documentNumber: payload.documentNumber,
        documentData: payload.documentData,
        status: 'PENDING',
      });
    } else {
      record.documentType = payload.documentType;
      record.documentNumber = payload.documentNumber;
      record.documentData = payload.documentData;
      record.status = 'PENDING';
    }

    return this.kycRepo.save(record);
  }

  /**
   * Fetch KYC by user identifier
   */
  async getByIdentifier(
    identifier: string,
  ): Promise<Kyc> {
    const user = await this.usersService.getByIdentifier(
      identifier,
    );

    const record = await this.kycRepo.findOne({
      where: { userId: user.id },
    });

    if (!record) {
      throw new NotFoundException('KYC_NOT_FOUND');
    }

    return record;
  }
}
