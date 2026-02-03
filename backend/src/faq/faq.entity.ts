// backend/src/faq/faq.entity.ts

import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

/**
 * FAQ TABLE
 * Stores frequently asked questions and answers.
 */
@Entity({ name: 'faqs' })
export class Faq {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  /**
   * FAQ question
   */
  @Column({ type: 'varchar', length: 512 })
  question!: string;

  /**
   * FAQ answer (rich text / markdown)
   */
  @Column({ type: 'text' })
  answer!: string;

  /**
   * Display order
   */
  @Index()
  @Column({ type: 'int', default: 0 })
  order!: number;

  /**
   * Active flag
   * Inactive FAQs are hidden from public
   */
  @Index()
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
