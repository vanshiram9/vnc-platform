// backend/src/support/support.service.ts

import {
  Injectable,
  BadRequestException,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { SupportTicket } from './ticket.entity';
import { UsersService } from '../users/users.service';

interface CreateTicketPayload {
  subject: string;
  message: string;
  category?: string;
}

@Injectable()
export class SupportService {
  constructor(
    @InjectRepository(SupportTicket)
    private readonly ticketRepo: Repository<SupportTicket>,
    private readonly usersService: UsersService,
  ) {}

  /**
   * Create a new support ticket
   */
  async createTicket(
    identifier: string,
    payload: CreateTicketPayload,
  ): Promise<SupportTicket> {
    if (!payload.subject || !payload.message) {
      throw new BadRequestException(
        'INVALID_TICKET_PAYLOAD',
      );
    }

    const user = await this.usersService.getByIdentifier(
      identifier,
    );

    const ticket = this.ticketRepo.create({
      userId: user.id,
      subject: payload.subject,
      message: payload.message,
      category: payload.category ?? 'GENERAL',
      status: 'OPEN',
    });

    return this.ticketRepo.save(ticket);
  }

  /**
   * Get all tickets for a user
   */
  async getTicketsByIdentifier(
    identifier: string,
  ): Promise<SupportTicket[]> {
    const user = await this.usersService.getByIdentifier(
      identifier,
    );

    return this.ticketRepo.find({
      where: { userId: user.id },
      order: { createdAt: 'DESC' },
    });
  }

  /**
   * Get ticket status (user-isolated)
   */
  async getTicketStatus(
    identifier: string,
    ticketId: string,
  ): Promise<SupportTicket> {
    const user = await this.usersService.getByIdentifier(
      identifier,
    );

    const ticket = await this.ticketRepo.findOne({
      where: { id: ticketId },
    });

    if (!ticket) {
      throw new NotFoundException(
        'TICKET_NOT_FOUND',
      );
    }

    if (ticket.userId !== user.id) {
      throw new ForbiddenException(
        'ACCESS_DENIED',
      );
    }

    return ticket;
  }
}
