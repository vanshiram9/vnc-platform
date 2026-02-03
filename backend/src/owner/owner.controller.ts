// backend/src/owner/owner.controller.ts

import {
  Controller,
  Get,
  Post,
  Body,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';

import { JwtAuthGuard, OwnerGuard } from '../auth/guards';
import { OwnerService } from './owner.service';

@Controller('owner')
@UseGuards(JwtAuthGuard, OwnerGuard)
export class OwnerController {
  constructor(
    private readonly ownerService: OwnerService,
  ) {}

  /**
   * Get system control snapshot
   */
  @Get('system')
  @HttpCode(HttpStatus.OK)
  async getSystemStatus() {
    return this.ownerService.getSystemStatus();
  }

  /**
   * Toggle platform feature
   */
  @Post('feature/toggle')
  @HttpCode(HttpStatus.OK)
  async toggleFeature(
    @Body()
    body: {
      feature: string;
      enabled: boolean;
    },
  ) {
    return this.ownerService.toggleFeature(
      body.feature,
      body.enabled,
    );
  }

  /**
   * Update country rule
   */
  @Post('country/rule')
  @HttpCode(HttpStatus.OK)
  async updateCountryRule(
    @Body()
    body: {
      countryCode: string;
      policy: 'ALLOW' | 'RESTRICT' | 'BLOCK';
    },
  ) {
    return this.ownerService.updateCountryRule(
      body.countryCode,
      body.policy,
    );
  }

  /**
   * Emergency kill switch
   */
  @Post('kill')
  @HttpCode(HttpStatus.OK)
  async triggerKillSwitch(
    @Body() body: { reason?: string },
  ) {
    return this.ownerService.triggerKillSwitch(
      body.reason,
    );
  }
}
