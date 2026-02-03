// backend/src/wallet/wallet.entity.ts

import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

/**
 * WALLET TABLE
 * Stores financial balances for users.
 */
@Entity({ name: 'wallets' })
export class Wallet {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  /**
   * User reference (users.id)
   */
  @Index({ unique: true })
  @Column({ type: 'uuid' })
  userId!: string;

  /**
   * Available balance
   */
  @Column({ type: 'decimal', precision: 20, scale: 8, default: 0 })
  balance!: number;

  /**
   * Locked balance (staking / escrow)
   */
  @Column({ type: 'decimal', precision: 20, scale: 8, default: 0 })
  lockedBalance!: number;

  /**
   * Wallet freeze flag
   * Enforced by risk / compliance
   */
  @Column({ type: 'boolean', default: false })
  frozen!: boolean;

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
