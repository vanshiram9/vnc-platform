// backend/src/app.controller.ts

import {
  Controller,
  Get,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  /**
   * Liveness Probe
   * Used by load balancer / container runtime
   */
  @Get('/health')
  @HttpCode(HttpStatus.OK)
  health() {
    return {
      status: 'ok',
      service: 'VNC-PLATFORM',
      timestamp: new Date().toISOString(),
    };
  }

  /**
   * Readiness Probe
   * Confirms system is bootstrapped and safe to receive traffic
   */
  @Get('/ready')
  @HttpCode(HttpStatus.OK)
  readiness() {
    return this.appService.readiness();
  }

  /**
   * Version & Build Metadata
   * Audit / regulator / admin visibility
   */
  @Get('/version')
  @HttpCode(HttpStatus.OK)
  version() {
    return this.appService.version();
  }

  /**
   * Root Endpoint
   * No sensitive data, no debug leakage
   */
  @Get('/')
  @HttpCode(HttpStatus.OK)
  root() {
    return {
      platform: 'VNC PLATFORM',
      status: 'running',
    };
  }
}
