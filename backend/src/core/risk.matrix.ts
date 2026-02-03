// backend/src/core/risk.matrix.ts

/**
 * VNC PLATFORM — RISK MATRIX
 * FINAL & HARD-LOCKED
 *
 * Purpose:
 * - Evaluate operational risk based on explicit inputs
 * - Produce deterministic actions (ALLOW / LIMIT / FREEZE)
 *
 * IMPORTANT:
 * - No side effects
 * - No external lookups
 * - All inputs must be provided by caller
 */

import {
  CountryPolicy,
  CountryRule,
} from './country.rules';
import {
  FeatureFlag,
} from './feature.flags';

/**
 * Risk Levels
 */
export type RiskLevel = 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';

/**
 * Risk Actions
 */
export enum RiskAction {
  ALLOW = 'ALLOW',
  LIMIT = 'LIMIT',
  FREEZE = 'FREEZE',
}

/**
 * Signals provided by caller (snapshot)
 * All fields are optional; absence means "unknown / neutral".
 */
export interface RiskSignals {
  failedAuthAttempts?: number;
  suspiciousActivity?: boolean;
  kycVerified?: boolean;
  recentChargebacks?: boolean;
  velocityAlert?: boolean;
}

/**
 * Evaluation Input
 */
export interface RiskInput {
  countryRule: CountryRule;
  featureSnapshot: Record<FeatureFlag, boolean>;
  signals?: RiskSignals;
}

/**
 * Evaluation Result
 */
export interface RiskResult {
  level: RiskLevel;
  action: RiskAction;
  reasons: string[];
}

/**
 * MAIN EVALUATOR
 * Deterministic mapping from inputs → result
 */
export function evaluateRisk(input: RiskInput): RiskResult {
  const reasons: string[] = [];

  // 1) Country policy hard gates
  if (input.countryRule.policy === CountryPolicy.BLOCK) {
    return {
      level: 'CRITICAL',
      action: RiskAction.FREEZE,
      reasons: ['COUNTRY_BLOCKED'],
    };
  }

  let level: RiskLevel = normalizeCountryRisk(
    input.countryRule.risk,
  );

  // 2) Feature snapshot sanity
  if (!input.featureSnapshot[FeatureFlag.AUTH]) {
    return {
      level: 'CRITICAL',
      action: RiskAction.FREEZE,
      reasons: ['AUTH_DISABLED'],
    };
  }

  // 3) KYC posture
  if (input.countryRule.kyc.required) {
    if (input.signals?.kycVerified === false) {
      level = escalate(level);
      reasons.push('KYC_NOT_VERIFIED');
    }
  }

  // 4) Behavioral signals
  if (input.signals?.failedAuthAttempts !== undefined) {
    if (input.signals.failedAuthAttempts >= 5) {
      level = escalate(level);
      reasons.push('AUTH_ATTEMPT_THRESHOLD');
    }
  }

  if (input.signals?.suspiciousActivity) {
    level = escalate(level);
    reasons.push('SUSPICIOUS_ACTIVITY');
  }

  if (input.signals?.velocityAlert) {
    level = escalate(level);
    reasons.push('VELOCITY_ALERT');
  }

  if (input.signals?.recentChargebacks) {
    level = escalate(level);
    reasons.push('CHARGEBACK_SIGNAL');
  }

  // 5) Map level → action
  const action = mapLevelToAction(level);

  return {
    level,
    action,
    reasons,
  };
}

/* ----------------------- */
/* Internal helpers        */
/* ----------------------- */

function normalizeCountryRisk(
  risk: 'LOW' | 'MEDIUM' | 'HIGH',
): RiskLevel {
  switch (risk) {
    case 'LOW':
      return 'LOW';
    case 'MEDIUM':
      return 'MEDIUM';
    case 'HIGH':
      return 'HIGH';
    default:
      return 'MEDIUM';
  }
}

function escalate(level: RiskLevel): RiskLevel {
  switch (level) {
    case 'LOW':
      return 'MEDIUM';
    case 'MEDIUM':
      return 'HIGH';
    case 'HIGH':
      return 'CRITICAL';
    case 'CRITICAL':
      return 'CRITICAL';
    default:
      return 'MEDIUM';
  }
}

function mapLevelToAction(level: RiskLevel): RiskAction {
  switch (level) {
    case 'LOW':
      return RiskAction.ALLOW;
    case 'MEDIUM':
      return RiskAction.LIMIT;
    case 'HIGH':
      return RiskAction.LIMIT;
    case 'CRITICAL':
      return RiskAction.FREEZE;
    default:
      return RiskAction.LIMIT;
  }
}
