// backend/src/config/secrets/secret.rotation.ts

import { Injectable } from '@nestjs/common';
import { SecretProvider } from './secret.provider';

/**
 * SecretRotationPolicy
 * Encapsulates rules & validation around secret rotation.
 * Execution is explicit — never automatic.
 */
@Injectable()
export class SecretRotationPolicy {
  constructor(private readonly secrets: SecretProvider) {}

  /**
   * Validate that a new secret is acceptable
   * before rotation is applied.
   */
  validateNewSecret(
    name: string,
    newValue: string,
  ): void {
    if (!newValue || newValue.trim().length === 0) {
      throw new Error(`ROTATION_INVALID: ${name} is empty`);
    }

    if (newValue.length < 32) {
      throw new Error(
        `ROTATION_INVALID: ${name} too short`,
      );
    }
  }

  /**
   * Dry-run rotation check
   * Confirms both old and new secrets are valid.
   */
  dryRun(name: string, newValue: string): boolean {
    // Existing secret must be present
    this.secrets.get(name);

    // New secret must satisfy policy
    this.validateNewSecret(name, newValue);

    return true;
  }

  /**
   * Rotation intent marker
   * Actual rotation is performed outside this class
   * (CI/CD, ops pipeline, or secure control plane).
   */
  markRotationIntent(name: string): void {
    // eslint-disable-next-line no-console
    console.warn(
      `[VNC PLATFORM] Secret rotation intent recorded for: ${name}`,
    );
  }
}
