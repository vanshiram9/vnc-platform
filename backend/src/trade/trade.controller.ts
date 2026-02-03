// backend/src/trade/trade.controller.ts

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
import { TradeService } from './trade.service';

interface CreateTradeRequest {
  type: 'BUY' | 'SELL';
  asset: string;
  amount: number;
  price: number;
}

@Controller('trade')
@UseGuards(JwtAuthGuard, AuthGuards)
export class TradeController {
  constructor(
    private readonly tradeService: TradeService,
  ) {}

  /**
   * Create a new trade order
   */
  @Post('create')
  @HttpCode(HttpStatus.CREATED)
  async createTrade(
    @Req() req: Request,
    @Body() body: CreateTradeRequest,
  ) {
    const identity = req.user as { identifier: string };

    return this.tradeService.createTrade(
      identity.identifier,
      body,
    );
  }

  /**
   * Get current user's trade orders
   */
  @Get('me')
  @HttpCode(HttpStatus.OK)
  async getMyTrades(@Req() req: Request) {
    const identity = req.user as { identifier: string };

    return this.tradeService.getTradesByIdentifier(
      identity.identifier,
    );
  }

  /**
   * Get escrow / settlement status for a trade
   */
  @Get('escrow/:tradeId')
  @HttpCode(HttpStatus.OK)
  async getEscrowStatus(
    @Param('tradeId') tradeId: string,
  ) {
    return this.tradeService.getEscrowStatus(
      tradeId,
    );
  }
}
