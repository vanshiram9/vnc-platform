// backend/src/wallet/wallet.controller.ts

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

import { WalletService } from './wallet.service';
import { JwtAuthGuard, AuthGuards } from '../auth/guards';

interface LockCoinsRequest {
  amount: number;
}

interface WithdrawRequest {
  amount: number;
}

@Controller('wallet')
@UseGuards(JwtAuthGuard, AuthGuards)
export class WalletController {
  constructor(
    private readonly walletService: WalletService,
  ) {}

  /**
   * Get current user's wallet summary
   */
  @Get('me')
  @HttpCode(HttpStatus.OK)
  async getMyWallet(@Req() req: Request) {
    const identity = req.user as { identifier: string };

    return this.walletService.getWalletByIdentifier(
      identity.identifier,
    );
  }

  /**
   * Get current user's ledger entries
   */
  @Get('ledger')
  @HttpCode(HttpStatus.OK)
  async getMyLedger(@Req() req: Request) {
    const identity = req.user as { identifier: string };

    return this.walletService.getLedgerByIdentifier(
      identity.identifier,
    );
  }

  /**
   * Lock coins (staking / time-lock)
   */
  @Post('lock')
  @HttpCode(HttpStatus.OK)
  async lockCoins(
    @Req() req: Request,
    @Body() body: LockCoinsRequest,
  ) {
    const identity = req.user as { identifier: string };

    return this.walletService.lockCoins(
      identity.identifier,
      body.amount,
    );
  }

  /**
   * Withdraw coins
   */
  @Post('withdraw')
  @HttpCode(HttpStatus.OK)
  async withdraw(
    @Req() req: Request,
    @Body() body: WithdrawRequest,
  ) {
    const identity = req.user as { identifier: string };

    return this.walletService.withdraw(
      identity.identifier,
      body.amount,
    );
  }
}
