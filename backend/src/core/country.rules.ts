// backend/src/core/country.rules.ts

/**
 * VNC PLATFORM — COUNTRY RULES
 * FINAL & HARD-LOCKED
 *
 * Purpose:
 * - Define country-level access controls
 * - Drive feature availability, KYC strictness, and risk posture
 *
 * IMPORTANT:
 * - No runtime mutation
 * - No external lookups
 * - Evaluated using boot-time snapshots
 */

/**
 * Country Policy
 */
export enum CountryPolicy {
  ALLOW = 'ALLOW',
  RESTRICT = 'RESTRICT',
  BLOCK = 'BLOCK',
}

/**
 * Country Rule Definition
 */
export interface CountryRule {
  policy: CountryPolicy;

  /**
   * Feature toggles overridden at country level.
   * Missing key = inherit default feature state.
   */
  featureOverrides?: Partial<Record<string, boolean>>;

  /**
   * KYC requirements for the country.
   */
  kyc: {
    required: boolean;
    level: 'BASIC' | 'ENHANCED' | 'FULL';
  };

  /**
   * Risk posture hint used by risk.matrix.ts
   */
  risk: 'LOW' | 'MEDIUM' | 'HIGH';
}

/**
 * DEFAULT COUNTRY RULES
 * ISO-3166-1 alpha-2 country codes.
 *
 * NOTE:
 * - Keep list minimal and explicit
 * - BLOCK only where legally required
 */
export const COUNTRY_RULES: Record<string, CountryRule> = {
  /**
   * India
   */
  IN: {
    policy: CountryPolicy.ALLOW,
    kyc: {
      required: true,
      level: 'FULL',
    },
    risk: 'MEDIUM',
  },

  /**
   * United States
   */
  US: {
    policy: CountryPolicy.RESTRICT,
    kyc: {
      required: true,
      level: 'FULL',
    },
    risk: 'HIGH',
  },

  /**
   * Default fallback (handled by helper)
   * Countries not listed explicitly inherit this.
   */
};

/**
 * DEFAULT RULE (for countries not explicitly listed)
 */
export const DEFAULT_COUNTRY_RULE: CountryRule = {
  policy: CountryPolicy.RESTRICT,
  kyc: {
    required: true,
    level: 'BASIC',
  },
  risk: 'MEDIUM',
};

/**
 * Resolve country rule by country code.
 * Always returns a rule (never undefined).
 */
export function getCountryRule(
  countryCode: string,
): CountryRule {
  const code = (countryCode || '').toUpperCase();
  return COUNTRY_RULES[code] ?? DEFAULT_COUNTRY_RULE;
}

/**
 * Helper: is country blocked
 */
export function isCountryBlocked(
  countryCode: string,
): boolean {
  return (
    getCountryRule(countryCode).policy ===
    CountryPolicy.BLOCK
  );
}

/**
 * Helper: is feature allowed in country
 * If override exists → it wins
 * Else → inherit provided default
 */
export function isFeatureAllowedInCountry(
  countryCode: string,
  featureKey: string,
  defaultEnabled: boolean,
): boolean {
  const rule = getCountryRule(countryCode);
  const override = rule.featureOverrides?.[featureKey];
  return typeof override === 'boolean'
    ? override
    : defaultEnabled;
}
