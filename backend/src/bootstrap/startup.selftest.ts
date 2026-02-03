// backend/src/bootstrap/startup.selftest.ts

import * as fs from 'fs';
import * as path from 'path';

export interface SelfTestResult {
  ok: boolean;
  checks: Record<string, boolean>;
  timestamp: string;
}

export class StartupSelfTest {
  /**
   * Execute all startup self-tests.
   * Any failed critical check MUST abort startup.
   */
  static run(): SelfTestResult {
    const checks: Record<string, boolean> = {};

    /**
     * 1) Required Root Files
     */
    checks.architecture_lock_present = this.fileExists(
      'architecture.lock.json',
    );
    checks.audit_hashes_present = this.fileExists('audit.hashes.json');
    checks.env_example_present = this.fileExists('.env.example');

    if (
      !checks.architecture_lock_present ||
      !checks.audit_hashes_present
    ) {
      throw new Error(
        'SELFTEST_FAIL: Required lock/audit files missing',
      );
    }

    /**
     * 2) Hard-Lock Integrity
     */
    const archLock = this.readJson('architecture.lock.json');
    checks.hard_lock_enabled = archLock?.hard_lock === true;

    if (!checks.hard_lock_enabled) {
      throw new Error(
        'SELFTEST_FAIL: Hard-lock flag disabled or missing',
      );
    }

    /**
     * 3) Version Consistency
     */
    checks.version_declared = Boolean(archLock?.version);
    if (!checks.version_declared) {
      throw new Error(
        'SELFTEST_FAIL: Version not declared in architecture.lock.json',
      );
    }

    /**
     * 4) Audit Hashes Sanity
     * (Structure check only — cryptographic validation handled elsewhere)
     */
    const auditHashes = this.readJson('audit.hashes.json');
    checks.audit_hashes_valid =
      typeof auditHashes === 'object' &&
      Object.keys(auditHashes).length > 0;

    if (!checks.audit_hashes_valid) {
      throw new Error(
        'SELFTEST_FAIL: audit.hashes.json invalid or empty',
      );
    }

    /**
     * 5) Directory Structure Sanity (non-exhaustive)
     */
    checks.backend_src_present = this.dirExists('backend/src');
    checks.docs_present = this.dirExists('docs');
    checks.infra_present = this.dirExists('infra');

    if (!checks.backend_src_present || !checks.docs_present) {
      throw new Error(
        'SELFTEST_FAIL: Critical directories missing',
      );
    }

    /**
     * 6) Passed All Critical Checks
     */
    return {
      ok: true,
      checks,
      timestamp: new Date().toISOString(),
    };
  }

  /* ----------------------- */
  /* Internal helper methods */
  /* ----------------------- */

  private static fileExists(relativePath: string): boolean {
    const p = path.resolve(process.cwd(), relativePath);
    return fs.existsSync(p) && fs.statSync(p).isFile();
  }

  private static dirExists(relativePath: string): boolean {
    const p = path.resolve(process.cwd(), relativePath);
    return fs.existsSync(p) && fs.statSync(p).isDirectory();
  }

  private static readJson(relativePath: string): any {
    const p = path.resolve(process.cwd(), relativePath);
    const raw = fs.readFileSync(p, 'utf-8');
    return JSON.parse(raw);
  }
}
