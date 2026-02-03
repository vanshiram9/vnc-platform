// backend/src/app.service.ts

import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class AppService {
  private readonly bootTime: number;
  private readonly versionMeta: Record<string, any>;

  constructor(private readonly configService: ConfigService) {
    this.bootTime = Date.now();
    this.versionMeta = this.loadVersionMetadata();
  }

  /**
   * Readiness Check
   * Confirms core system state is healthy enough to receive traffic.
   * No business logic, no DB mutation, no side effects.
   */
  readiness() {
    const uptimeMs = Date.now() - this.bootTime;

    return {
      ready: true,
      service: 'VNC-PLATFORM',
      environment: this.configService.get<string>('NODE_ENV') || 'unknown',
      uptime_ms: uptimeMs,
      timestamp: new Date().toISOString(),
    };
  }

  /**
   * Version Metadata
   * Used by:
   * - Admin panels
   * - Audit tools
   * - Regulators
   * - CI/CD verification
   */
  version() {
    return {
      platform: 'VNC-PLATFORM',
      version: this.versionMeta.version,
      hard_lock: this.versionMeta.hard_lock,
      build_time: this.versionMeta.build_time,
      git_commit: this.versionMeta.git_commit,
    };
  }

  /**
   * Internal helper
   * Loads immutable version metadata from root config.
   */
  private loadVersionMetadata(): Record<string, any> {
    try {
      const filePath = path.resolve(process.cwd(), 'architecture.lock.json');
      const raw = fs.readFileSync(filePath, 'utf-8');
      const parsed = JSON.parse(raw);

      return {
        version: parsed.version || 'unknown',
        hard_lock: parsed.hard_lock || false,
        build_time: parsed.build_time || null,
        git_commit: parsed.git_commit || null,
      };
    } catch (err) {
      // Fail-safe: never crash app for version lookup
      return {
        version: 'unknown',
        hard_lock: false,
        build_time: null,
        git_commit: null,
      };
    }
  }
}
