// backend/src/faq/faq.module.ts

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { FaqController } from './faq.controller';
import { FaqService } from './faq.service';
import { Faq } from './faq.entity';

@Module({
  imports: [
    /**
     * Entity registration
     */
    TypeOrmModule.forFeature([Faq]),
  ],
  controllers: [FaqController],
  providers: [FaqService],
  exports: [
    /**
     * Export service for admin / support visibility
     */
    FaqService,
  ],
})
export class FaqModule {}
