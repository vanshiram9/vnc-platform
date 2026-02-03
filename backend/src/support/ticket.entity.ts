// backend/src/support/ticket.entity.ts

import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

/**
 * SUPPORT TICKETS TABLE
 * Stores user support/helpdesk issues.
 */
@Entity({ name: 'support_tickets' })
export class SupportTicket {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  /**
   * User reference (users.id)
   */
  @Index()
  @Column({ type: 'uuid' })
  userId!: string;

  /**
   * Ticket subject
   */
  @Column({ type: 'varchar', length: 255 })
  subject!: string;

  /**
   * Initial user message
   */
  @Column({ type: 'text' })
  message!: string;

  /**
   * Ticket category
   */
  @Index()
  @Column({ type: 'varchar', length: 64 })
  category!: string;

  /**
   * Ticket lifecycle status
   */
  @Index()
  @Column({
    type: 'enum',
    enum: ['OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED'],
    default: 'OPEN',
  })
  status!: 'OPEN' | 'IN_PROGRESS' | 'RESOLVED' | 'CLOSED';

  /**
   * Record creation timestamp
   */
  @CreateDateColumn({ type: 'timestamp' })
  createdAt!: Date;

  /**
   * Record update timestamp
   */
  @UpdateDateColumn({ type: 'timestamp' })
  updatedAt!: Date;
}
