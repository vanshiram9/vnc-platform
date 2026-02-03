// backend/src/support/support.controller.ts

import {
  Controller,
  Get,
  Post,
  Body,
  Req,
  UseGuards,
  Param,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { Request } from 'express';

import { JwtAuthGuard, AuthGuards } from '../auth/guards';
import { SupportService } from './support.service';

interface CreateTicketRequest {
  subject: string;
  message: string;
  category?: string;
}

@Controller('support')
@UseGuards(JwtAuthGuard, AuthGuards)
export class SupportController {
  constructor(
    private readonly supportService: SupportService,
  ) {}

  /**
   * Create a new support ticket
   */
  @Post('ticket')
  @HttpCode(HttpStatus.CREATED)
  async createTicket(
    @Req() req: Request,
    @Body() body: CreateTicketRequest,
  ) {
    const identity = req.user as { identifier: string };

    return this.supportService.createTicket(
      identity.identifier,
      body,
    );
  }

  /**
   * Get all tickets for current user
   */
  @Get('me')
  @HttpCode(HttpStatus.OK)
  async getMyTickets(@Req() req: Request) {
    const identity = req.user as { identifier: string };

    return this.supportService.getTicketsByIdentifier(
      identity.identifier,
    );
  }

  /**
   * Get ticket status by ticket id
   */
  @Get('ticket/:ticketId')
  @HttpCode(HttpStatus.OK)
  async getTicketStatus(
    @Req() req: Request,
    @Param('ticketId') ticketId: string,
  ) {
    const identity = req.user as { identifier: string };

    return this.supportService.getTicketStatus(
      identity.identifier,
      ticketId,
    );
  }
}
