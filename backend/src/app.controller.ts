// ============================================================
// VNC PLATFORM — APP CONTROLLER
// Phase-1 CORE (HEALTH + SANITY)
// ============================================================

import { Controller, Get } from '@nestjs/common';

@Controller()
export class AppController {
  private readonly startedAt = Date.now();

  /* --------------------------------------------------------- */
  /* BASIC HEALTH CHECK                                        */
  /* --------------------------------------------------------- */

  @Get('/')
  health(): {
    status: 'ok';
    service: 'vnc-backend';
    timestamp: string;
  } {
    return {
      status: 'ok',
      service: 'vnc-backend',
      timestamp: new Date().toISOString(),
    };
  }

  /* --------------------------------------------------------- */
  /* READINESS CHECK                                          */
  /* --------------------------------------------------------- */

  @Get('/ready')
  readiness(): {
    ready: true;
    uptime_ms: number;
  } {
    return {
      ready: true,
      uptime_ms: Date.now() - this.startedAt,
    };
  }

  /* --------------------------------------------------------- */
  /* VERSION CHECK                                            */
  /* --------------------------------------------------------- */

  @Get('/version')
  version(): {
    platform: 'VNC';
    version: string;
    phase: 'phase-1-core';
  } {
    return {
      platform: 'VNC',
      version: '6.7.0.4',
      phase: 'phase-1-core',
    };
  }
}
