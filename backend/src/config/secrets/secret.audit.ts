// backend/src/config/secrets/secret.audit.ts

import { Injectable } from '@nestjs/common';

export type SecretAuditAction =
  | 'ACCESS'
  | 'ROTATION_INTENT'
  | 'ROTATION_VALIDATE'
  | 'ROTATION_FAIL';

export interface SecretAuditEvent {
  secret: string;
  action: SecretAuditAction;
  actor: string;
  reason?: string;
  timestamp: string;
}

@Injectable()
export class SecretAudit {
  /**
   * Record an audit event related to secrets.
   * NOTE: Never logs secret values.
   */
  record(event: Omit<SecretAuditEvent, 'timestamp'>): void {
    const payload: SecretAuditEvent = {
      ...event,
      timestamp: new Date().toISOString(),
    };

    /**
     * Minimal, append-only audit output.
     * Routed to centralized log pipeline by infra.
     */
    // eslint-disable-next-line no-console
    console.info('[VNC PLATFORM][SECRET_AUDIT]', payload);
  }

  /**
   * Helper: audit secret access
   */
  access(secret: string, actor: string): void {
    this.record({
      secret,
      action: 'ACCESS',
      actor,
    });
  }

  /**
   * Helper: audit rotation intent
   */
  rotationIntent(
    secret: string,
    actor: string,
    reason?: string,
  ): void {
    this.record({
      secret,
      action: 'ROTATION_INTENT',
      actor,
      reason,
    });
  }

  /**
   * Helper: audit rotation validation failure
   */
  rotationFail(
    secret: string,
    actor: string,
    reason: string,
  ): void {
    this.record({
      secret,
      action: 'ROTATION_FAIL',
      actor,
      reason,
    });
  }
}
