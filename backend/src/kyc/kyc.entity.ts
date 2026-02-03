// backend/src/kyc/kyc.entity.ts

import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

/**
 * KYC TABLE
 * Stores verification records for users.
 */
@Entity({ name: 'kyc' })
export class Kyc {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  /**
   * User reference (users.id)
   */
  @Index({ unique: true })
  @Column({ type: 'uuid' })
  userId!: string;

  /**
   * Document type (e.g., AADHAAR, PASSPORT, PAN)
   */
  @Column({ type: 'varchar', length: 64 })
  documentType!: string;

  /**
   * Document number / identifier
   */
  @Column({ type: 'varchar', length: 128 })
  documentNumber!: string;

  /**
   * Optional structured document metadata
   * (hashes, provider refs, OCR data)
   */
  @Column({ type: 'json', nullable: true })
  documentData?: Record<string, any>;

  /**
   * KYC status lifecycle
   */
  @Column({
    type: 'enum',
    enum: ['PENDING', 'APPROVED', 'REJECTED'],
    default: 'PENDING',
  })
  status!: 'PENDING' | 'APPROVED' | 'REJECTED';

  /**
   * Reviewer notes (admin/compliance)
   */
  @Column({ type: 'text', nullable: true })
  reviewNotes?: string;

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
