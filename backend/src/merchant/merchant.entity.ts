// backend/src/merchant/merchant.entity.ts

import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

/**
 * MERCHANT TABLE
 * Represents merchant/business accounts on VNC platform.
 */
@Entity({ name: 'merchants' })
export class Merchant {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  /**
   * User reference (users.id)
   */
  @Index({ unique: true })
  @Column({ type: 'uuid' })
  userId!: string;

  /**
   * Merchant display / legal name
   */
  @Column({ type: 'varchar', length: 191 })
  name!: string;

  /**
   * Business category/type
   */
  @Column({ type: 'varchar', length: 128 })
  businessType!: string;

  /**
   * Website or primary URL
   */
  @Column({ type: 'varchar', length: 255 })
  website!: string;

  /**
   * Merchant active flag
   * Disabled merchants cannot trade / advertise
   */
  @Column({ type: 'boolean', default: true })
  active!: boolean;

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
