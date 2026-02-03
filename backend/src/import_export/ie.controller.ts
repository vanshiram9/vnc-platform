// backend/src/import_export/ie.controller.ts

import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Req,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { Request } from 'express';

import { JwtAuthGuard, AuthGuards } from '../auth/guards';
import { IeService } from './ie.service';

interface CreateIeContractRequest {
  tradeId: string;
  importerCountry: string;
  exporterCountry: string;
  goodsDescription: string;
  value: number;
}

@Controller('import-export')
@UseGuards(JwtAuthGuard, AuthGuards)
export class IeController {
  constructor(
    private readonly ieService: IeService,
  ) {}

  /**
   * Create an import/export contract (LC-backed)
   */
  @Post('create')
  @HttpCode(HttpStatus.CREATED)
  async createContract(
    @Req() req: Request,
    @Body() body: CreateIeContractRequest,
  ) {
    const identity = req.user as { identifier: string };

    return this.ieService.createContract(
      identity.identifier,
      body,
    );
  }

  /**
   * Get IE dashboard for current user
   */
  @Get('me')
  @HttpCode(HttpStatus.OK)
  async getMyDashboard(@Req() req: Request) {
    const identity = req.user as { identifier: string };

    return this.ieService.getDashboard(
      identity.identifier,
    );
  }

  /**
   * Get escrow / LC status for a contract
   */
  @Get('escrow/:contractId')
  @HttpCode(HttpStatus.OK)
  async getEscrowStatus(
    @Param('contractId') contractId: string,
  ) {
    return this.ieService.getEscrowStatus(
      contractId,
    );
  }
}
