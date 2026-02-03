// backend/src/kyc/kyc.controller.ts

import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Req,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { Request } from 'express';

import { JwtAuthGuard, AuthGuards } from '../auth/guards';
import { KycService } from './kyc.service';

interface KycSubmitRequest {
  documentType: string;
  documentNumber: string;
  documentData?: Record<string, any>;
}

@Controller('kyc')
@UseGuards(JwtAuthGuard, AuthGuards)
export class KycController {
  constructor(private readonly kycService: KycService) {}

  /**
   * Submit or update KYC for current user
   */
  @Post('submit')
  @HttpCode(HttpStatus.OK)
  async submitKyc(
    @Req() req: Request,
    @Body() body: KycSubmitRequest,
  ) {
    const identity = req.user as { identifier: string };

    return this.kycService.submitKyc(
      identity.identifier,
      body,
    );
  }

  /**
   * Get current user's KYC status
   */
  @Get('me')
  @HttpCode(HttpStatus.OK)
  async getMyKyc(@Req() req: Request) {
    const identity = req.user as { identifier: string };

    return this.kycService.getByIdentifier(
      identity.identifier,
    );
  }

  /**
   * Get KYC record by user identifier
   * Used by admin / compliance flows
   */
  @Get(':identifier')
  @HttpCode(HttpStatus.OK)
  async getKycByIdentifier(
    @Param('identifier') identifier: string,
  ) {
    return this.kycService.getByIdentifier(identifier);
  }
}
