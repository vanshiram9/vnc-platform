// backend/src/trade/trade.entity.ts

import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

/**
 * TRADE TABLE
 * Represents buy/sell orders and their escrow state.
 */
@Entity({ name: 'trades' })
export class Trade {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  /**
   * User reference (users.id)
   */
  @Index()
  @Column({ type: 'uuid' })
  userId!: string;

  /**
   * Trade type
   */
  @Column({
    type: 'enum',
    enum: ['BUY', 'SELL'],
  })
  type!: 'BUY' | 'SELL';

  /**
   * Asset symbol / identifier
   */
  @Column({ type: 'varchar', length: 64 })
  asset!: string;

  /**
   * Asset amount
   */
  @Column({ type: 'decimal', precision: 20, scale: 8 })
  amount!: number;

  /**
   * Price per unit
   */
  @Column({ type: 'decimal', precision: 20, scale: 8 })
  price!: number;

  /**
   * Trade lifecycle status
   */
  @Index()
  @Column({
    type: 'enum',
    enum: ['OPEN', 'MATCHED', 'SETTLED', 'CANCELLED'],
    default: 'OPEN',
  })
  status!: 'OPEN' | 'MATCHED' | 'SETTLED' | 'CANCELLED';

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
