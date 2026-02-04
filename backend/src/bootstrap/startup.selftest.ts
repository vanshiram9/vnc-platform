// ============================================================
// VNC PLATFORM — STARTUP SELF TEST
// File: backend/src/bootstrap/startup.selftest.ts
// Grade: BANK + MILITARY + RBI
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import * as fs from 'fs';
import * as path from 'path';

import { KillSwitch } from '../owner/kill.switch';

export interface SelfTestResult {
  ok: boolean;
  checks: Record<string, boolean>;
  timestamp: string;
}

/**
 * StartupSelfTest
 * ----------------
 * - Runs BEFORE app accepts traffic
 * - Any failure MUST abort startup
 * - No degraded mode
 * - No auto-recovery
 */
export class StartupSelfTest {
  static run(
    killSwitch?: KillSwitch,
  ): SelfTestResult {
    const checks: Record<string, boolean> = {};

    /* -------------------------------------------------------- */
    /* 1) REQUIRED ROOT FILES                                   */
    /* -------------------------------------------------------- */

    checks.architecture_lock_present =
      this.fileExists('architecture.lock.json');
    checks.audit_hashes_present =
      this.fileExists('audit.hashes.json');
    checks.env_example_present =
      this.fileExists('.env.example');

    if (
      !checks.architecture_lock_present ||
      !checks.audit_hashes_present
    ) {
      throw new Error(
        'SELFTEST_FAIL: REQUIRED_LOCK_FILES_MISSING',
      );
    }

    /* -------------------------------------------------------- */
    /* 2) HARD-LOCK INTEGRITY                                   */
    /* -------------------------------------------------------- */

    const archLock = this.readJson(
      'architecture.lock.json',
    );

    checks.hard_lock_enabled =
      archLock?.hard_lock === true;

    if (!checks.hard_lock_enabled) {
      throw new Error(
        'SELFTEST_FAIL: HARD_LOCK_DISABLED',
      );
    }

    /* -------------------------------------------------------- */
    /* 3) VERSION CONSISTENCY                                   */
    /* -------------------------------------------------------- */

    checks.version_declared =
      archLock?.version === 'v6.7.0.4';

    if (!checks.version_declared) {
      throw new Error(
        'SELFTEST_FAIL: VERSION_MISMATCH',
      );
    }

    /* -------------------------------------------------------- */
    /* 4) AUDIT HASH SANITY                                     */
    /* -------------------------------------------------------- */

    const auditHashes = this.readJson(
      'audit.hashes.json',
    );

    checks.audit_hashes_valid =
      typeof auditHashes === 'object' &&
      Object.keys(auditHashes).length > 0;

    if (!checks.audit_hashes_valid) {
      throw new Error(
        'SELFTEST_FAIL: AUDIT_HASHES_INVALID',
      );
    }

    /* -------------------------------------------------------- */
    /* 5) DIRECTORY STRUCTURE                                   */
    /* -------------------------------------------------------- */

    checks.backend_src_present =
      this.dirExists('backend/src');
    checks.docs_present =
      this.dirExists('docs');
    checks.infra_present =
      this.dirExists('infra');

    if (
      !checks.backend_src_present ||
      !checks.docs_present
    ) {
      throw new Error(
        'SELFTEST_FAIL: CRITICAL_DIRECTORIES_MISSING',
      );
    }

    /* -------------------------------------------------------- */
    /* 6) KILL-SWITCH DOMINANCE                                  */
    /* -------------------------------------------------------- */

    if (killSwitch && killSwitch.isActive()) {
      throw new Error(
        'SELFTEST_FAIL: SYSTEM_FROZEN',
      );
    }

    /* -------------------------------------------------------- */
    /* ALL CHECKS PASSED                                        */
    /* -------------------------------------------------------- */

    return {
      ok: true,
      checks,
      timestamp: new Date().toISOString(),
    };
  }

  /* ----------------------- */
  /* INTERNAL HELPERS        */
  /* ----------------------- */

  private static fileExists(
    relativePath: string,
  ): boolean {
    const p = path.resolve(
      process.cwd(),
      relativePath,
    );
    return (
      fs.existsSync(p) &&
      fs.statSync(p).isFile()
    );
  }

  private static dirExists(
    relativePath: string,
  ): boolean {
    const p = path.resolve(
      process.cwd(),
      relativePath,
    );
    return (
      fs.existsSync(p) &&
      fs.statSync(p).isDirectory()
    );
  }

  private static readJson(
    relativePath: string,
  ): any {
    const p = path.resolve(
      process.cwd(),
      relativePath,
    );
    const raw = fs.readFileSync(p, 'utf-8');
    return JSON.parse(raw);
  }
}
