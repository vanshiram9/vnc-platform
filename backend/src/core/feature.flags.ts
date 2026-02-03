// backend/src/core/feature.flags.ts

/**
 * VNC PLATFORM — FEATURE FLAGS
 * Defined strictly from existing backend modules & flows.
 */

export enum FeatureFlag {
  AUTH = 'AUTH',
  WALLET = 'WALLET',
  MINING = 'MINING',
  ADS = 'ADS',
  TRADE = 'TRADE',
  IMPORT_EXPORT = 'IMPORT_EXPORT',
  MERCHANT = 'MERCHANT',
  KYC = 'KYC',
  SUPPORT = 'SUPPORT',
  ADMIN = 'ADMIN',
}

/**
 * Default feature state
 * Loaded at boot and treated as immutable snapshot.
 */
export const DEFAULT_FEATURE_FLAGS: Record<FeatureFlag, boolean> =
  {
    [FeatureFlag.AUTH]: true,
    [FeatureFlag.WALLET]: true,
    [FeatureFlag.MINING]: true,
    [FeatureFlag.ADS]: true,
    [FeatureFlag.TRADE]: true,
    [FeatureFlag.IMPORT_EXPORT]: true,
    [FeatureFlag.MERCHANT]: true,
    [FeatureFlag.KYC]: true,
    [FeatureFlag.SUPPORT]: true,
    [FeatureFlag.ADMIN]: true,
  };

/**
 * Helper: check if feature is enabled
 * Uses provided snapshot (no global mutation).
 */
export function isFeatureEnabled(
  snapshot: Record<FeatureFlag, boolean>,
  feature: FeatureFlag,
): boolean {
  return snapshot[feature] === true;
}
