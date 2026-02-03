// backend/src/faq/faq.controller.ts

import {
  Controller,
  Get,
  Param,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';

import { JwtAuthGuard } from '../auth/guards';
import { FaqService } from './faq.service';

@Controller('faq')
export class FaqController {
  constructor(private readonly faqService: FaqService) {}

  /**
   * Get all active FAQs
   * Public endpoint (no auth required)
   */
  @Get()
  @HttpCode(HttpStatus.OK)
  async getAll() {
    return this.faqService.getAllActive();
  }

  /**
   * Get FAQ by id
   * Public endpoint
   */
  @Get(':id')
  @HttpCode(HttpStatus.OK)
  async getById(@Param('id') id: string) {
    return this.faqService.getById(id);
  }

  /**
   * Get all FAQs (including inactive)
   * Admin / support usage
   */
  @Get('admin/all')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  async getAllForAdmin() {
    return this.faqService.getAll();
  }
}
