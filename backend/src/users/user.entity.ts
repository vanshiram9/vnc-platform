// backend/src/users/user.entity.ts

import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

import { SystemRole } from '../core/roles.states';

/**
 * USERS TABLE
 * Represents every identity on the VNC platform.
 */
@Entity({ name: 'users' })
export class User {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  /**
   * Unique user identifier
   * (phone / email / external ID)
   */
  @Index({ unique: true })
  @Column({ type: 'varchar', length: 191 })
  identifier!: string;

  /**
   * System role
   * Derived strictly from roles.states.ts
   */
  @Column({
    type: 'enum',
    enum: SystemRole,
    default: SystemRole.USER,
  })
  role!: SystemRole;

  /**
   * Account active / suspended flag
   * Used by auth, risk, admin flows
   */
  @Column({ type: 'boolean', default: true })
  active!: boolean;

  /**
   * Soft risk / compliance freeze
   * (wallet, trade, mining respect this)
   */
  @Column({ type: 'boolean', default: false })
  frozen!: boolean;

  /**
   * Last activity timestamp
   * Updated opportunistically
   */
  @Column({ type: 'timestamp', nullable: true })
  lastActiveAt!: Date | null;

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
