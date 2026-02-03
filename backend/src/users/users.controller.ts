// backend/src/users/users.controller.ts

import {
  Controller,
  Get,
  Param,
  Req,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { Request } from 'express';

import { UsersService } from './users.service';
import { JwtAuthGuard, AuthGuards } from '../auth/guards';

@Controller('users')
@UseGuards(JwtAuthGuard, AuthGuards)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  /**
   * Get current authenticated user profile
   */
  @Get('me')
  @HttpCode(HttpStatus.OK)
  async getMe(@Req() req: Request) {
    const identity = req.user as { identifier: string };

    return this.usersService.getByIdentifier(
      identity.identifier,
    );
  }

  /**
   * Get user profile by identifier
   * Used by admin/support flows (guarded at service level)
   */
  @Get(':identifier')
  @HttpCode(HttpStatus.OK)
  async getByIdentifier(
    @Param('identifier') identifier: string,
  ) {
    return this.usersService.getByIdentifier(identifier);
  }
}
