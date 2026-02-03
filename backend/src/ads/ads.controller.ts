// backend/src/ads/ads.controller.ts

import {
  Controller,
  Post,
  Body,
  Req,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { Request } from 'express';

import { JwtAuthGuard, AuthGuards } from '../auth/guards';
import { AdsService } from './ads.service';

interface AdEventRequest {
  adId: string;
  event: 'VIEW' | 'CLICK' | 'COMPLETE';
  metadata?: Record<string, any>;
}

@Controller('ads')
@UseGuards(JwtAuthGuard, AuthGuards)
export class AdsController {
  constructor(
    private readonly adsService: AdsService,
  ) {}

  /**
   * Register ad interaction event
   * (view / click / completion)
   */
  @Post('event')
  @HttpCode(HttpStatus.OK)
  async registerEvent(
    @Req() req: Request,
    @Body() body: AdEventRequest,
  ) {
    const identity = req.user as { identifier: string };

    return this.adsService.handleAdEvent(
      identity.identifier,
      body,
    );
  }
}
