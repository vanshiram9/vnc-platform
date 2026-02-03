// backend/src/admin/admin.controller.ts

import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';

import { JwtAuthGuard, AdminGuard } from '../auth/guards';
import { AdminService } from './admin.service';

@Controller('admin')
@UseGuards(JwtAuthGuard, AdminGuard)
export class AdminController {
  constructor(
    private readonly adminService: AdminService,
  ) {}

  /**
   * Get platform overview (users, wallets, trades, flags)
   */
  @Get('overview')
  @HttpCode(HttpStatus.OK)
  async getOverview() {
    return this.adminService.getOverview();
  }

  /**
   * Get all users (admin visibility)
   */
  @Get('users')
  @HttpCode(HttpStatus.OK)
  async getAllUsers() {
    return this.adminService.getAllUsers();
  }

  /**
   * Freeze or unfreeze a user account
   */
  @Post('user/:userId/freeze')
  @HttpCode(HttpStatus.OK)
  async toggleUserFreeze(
    @Param('userId') userId: string,
    @Body() body: { freeze: boolean },
  ) {
    return this.adminService.setUserFreeze(
      userId,
      body.freeze,
    );
  }

  /**
   * Get pending KYC applications
   */
  @Get('kyc/pending')
  @HttpCode(HttpStatus.OK)
  async getPendingKyc() {
    return this.adminService.getPendingKyc();
  }

  /**
   * Approve or reject KYC
   */
  @Post('kyc/:kycId/review')
  @HttpCode(HttpStatus.OK)
  async reviewKyc(
    @Param('kycId') kycId: string,
    @Body() body: { decision: 'APPROVE' | 'REJECT' },
  ) {
    return this.adminService.reviewKyc(
      kycId,
      body.decision,
    );
  }

  /**
   * Get recent trades (audit view)
   */
  @Get('trades')
  @HttpCode(HttpStatus.OK)
  async getTrades() {
    return this.adminService.getRecentTrades();
  }

  /**
   * Get support tickets (admin view)
   */
  @Get('support/tickets')
  @HttpCode(HttpStatus.OK)
  async getSupportTickets() {
    return this.adminService.getSupportTickets();
  }
}
