// backend/src/faq/faq.service.ts

import {
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Faq } from './faq.entity';

@Injectable()
export class FaqService {
  constructor(
    @InjectRepository(Faq)
    private readonly faqRepo: Repository<Faq>,
  ) {}

  /**
   * Get all active FAQs (public)
   */
  async getAllActive(): Promise<Faq[]> {
    return this.faqRepo.find({
      where: { active: true },
      order: { order: 'ASC' },
    });
  }

  /**
   * Get FAQ by id (public)
   */
  async getById(id: string): Promise<Faq> {
    const faq = await this.faqRepo.findOne({
      where: { id },
    });

    if (!faq || !faq.active) {
      throw new NotFoundException('FAQ_NOT_FOUND');
    }

    return faq;
  }

  /**
   * Get all FAQs (admin/support)
   */
  async getAll(): Promise<Faq[]> {
    return this.faqRepo.find({
      order: { order: 'ASC' },
    });
  }
}
