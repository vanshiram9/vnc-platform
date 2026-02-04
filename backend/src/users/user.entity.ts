// ============================================================
// VNC PLATFORM — USER ENTITY
// Grade: BANK + GOVERNMENT + ZERO-TRUST
// Phase-1 CORE (COMPILE-SAFE)
// ============================================================

import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

export type UserRole =
  | 'USER'
  | 'ADMIN'
  | 'OWNER';

export type UserStatus =
  | 'ACTIVE'
  | 'FROZEN'
  | 'BLOCKED';

@Entity({ name: 'users' })
export class User {
  /* ---------------------------------------------------------- */
  /* PRIMARY ID                                                 */
  /* ---------------------------------------------------------- */

  @PrimaryGeneratedColumn('uuid')
  id!: string;

  /* ---------------------------------------------------------- */
  /* IDENTITY                                                   */
  /* ---------------------------------------------------------- */

  @Index({ unique: true })
  @Column({ type: 'varchar', length: 20 })
  phone!: string;

  @Column({ type: 'varchar', length: 100, nullable: true })
  email?: string;

  /* ---------------------------------------------------------- */
  /* ROLE & STATE                                               */
  /* ---------------------------------------------------------- */

  @Column({
    type: 'enum',
    enum: ['USER', 'ADMIN', 'OWNER'],
    default: 'USER',
  })
  role!: UserRole;

  @Column({
    type: 'enum',
    enum: ['ACTIVE', 'FROZEN', 'BLOCKED'],
    default: 'ACTIVE',
  })
  status!: UserStatus;

  /* ---------------------------------------------------------- */
  /* COMPLIANCE                                                 */
  /* ---------------------------------------------------------- */

  @Column({ type: 'varchar', length: 3, default: 'IN' })
  countryCode!: string;

  @Column({ type: 'boolean', default: false })
  kycVerified!: boolean;

  /* ---------------------------------------------------------- */
  /* SECURITY FLAGS                                             */
  /* ---------------------------------------------------------- */

  @Column({ type: 'boolean', default: false })
  frozen!: boolean;

  @Column({ type: 'boolean', default: false })
  riskFlag!: boolean;

  /* ---------------------------------------------------------- */
  /* AUDIT                                                     */
  /* ---------------------------------------------------------- */

  @CreateDateColumn({ type: 'timestamptz' })
  createdAt!: Date;

  @UpdateDateColumn({ type: 'timestamptz' })
  updatedAt!: Date;
}
