// backend/src/wallet/ledger.entry.ts

import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
} from 'typeorm';

/**
 * LEDGER ENTRIES TABLE
 * Immutable financial event log.
 */
@Entity({ name: 'ledger_entries' })
export class LedgerEntry {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  /**
   * User reference (users.id)
   */
  @Index()
  @Column({ type: 'uuid' })
  userId!: string;

  /**
   * Entry type
   * LOCK, UNLOCK, CREDIT, DEBIT, WITHDRAW, REWARD, AD_PAYOUT, TRADE_SETTLEMENT
   */
  @Index()
  @Column({ type: 'varchar', length: 32 })
  type!:
    | 'LOCK'
    | 'UNLOCK'
    | 'CREDIT'
    | 'DEBIT'
    | 'WITHDRAW'
    | 'REWARD'
    | 'AD_PAYOUT'
    | 'TRADE_SETTLEMENT';

  /**
   * Amount involved in the entry
   * Always positive; direction implied by type
   */
  @Column({ type: 'decimal', precision: 20, scale: 8 })
  amount!: number;

  /**
   * Optional human-readable note
   */
  @Column({ type: 'varchar', length: 255, nullable: true })
  note?: string;

  /**
   * Record creation timestamp (append-only)
   */
  @CreateDateColumn({ type: 'timestamp' })
  createdAt!: Date;
}
