// backend/src/mining/mining.controller.ts

import {
  Controller,
  Get,
  Post,
  Req,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { Request } from 'express';

import { JwtAuthGuard, AuthGuards } from '../auth/guards';
import { MiningService } from './mining.service';

@Controller('mining')
@UseGuards(JwtAuthGuard, AuthGuards)
export class MiningController {
  constructor(
    private readonly miningService: MiningService,
  ) {}

  /**
   * Start mining session
   */
  @Post('start')
  @HttpCode(HttpStatus.OK)
  async startMining(@Req() req: Request) {
    const identity = req.user as { identifier: string };

    return this.miningService.startMining(
      identity.identifier,
    );
  }

  /**
   * Get current mining status
   */
  @Get('status')
  @HttpCode(HttpStatus.OK)
  async getStatus(@Req() req: Request) {
    const identity = req.user as { identifier: string };

    return this.miningService.getStatus(
      identity.identifier,
    );
  }

  /**
   * Get mining reward history
   */
  @Get('history')
  @HttpCode(HttpStatus.OK)
  async getHistory(@Req() req: Request) {
    const identity = req.user as { identifier: string };

    return this.miningService.getHistory(
      identity.identifier,
    );
  }
}
