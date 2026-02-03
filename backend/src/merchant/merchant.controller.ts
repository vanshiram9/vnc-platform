// backend/src/merchant/merchant.controller.ts

import {
  Controller,
  Get,
  Post,
  Body,
  Req,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { Request } from 'express';

import { JwtAuthGuard, AuthGuards } from '../auth/guards';
import { MerchantService } from './merchant.service';

interface MerchantProfileUpdateRequest {
  name?: string;
  businessType?: string;
  website?: string;
}

@Controller('merchant')
@UseGuards(JwtAuthGuard, AuthGuards)
export class MerchantController {
  constructor(
    private readonly merchantService: MerchantService,
  ) {}

  /**
   * Get current merchant profile
   */
  @Get('me')
  @HttpCode(HttpStatus.OK)
  async getMyProfile(@Req() req: Request) {
    const identity = req.user as { identifier: string };

    return this.merchantService.getByIdentifier(
      identity.identifier,
    );
  }

  /**
   * Update merchant profile
   */
  @Post('update')
  @HttpCode(HttpStatus.OK)
  async updateProfile(
    @Req() req: Request,
    @Body() body: MerchantProfileUpdateRequest,
  ) {
    const identity = req.user as { identifier: string };

    return this.merchantService.updateProfile(
      identity.identifier,
      body,
    );
  }
}
