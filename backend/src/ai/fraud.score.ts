// backend/src/ai/fraud.score.ts

/**
 * VNC PLATFORM — FRAUD SCORE
 * FINAL & HARD-LOCKED
 *
 * Purpose:
 * - Produce a normalized fraud risk score (0 → 1)
 * - Deterministic, explainable, auditable
 *
 * IMPORTANT:
 * - No ML models (tree does not define them)
 * - No IO, no persistence
 */

export interface FraudSignals {
  rapidActions?: number;      // burst actions in short time
  ipChanges?: number;         // IP / device changes
  failedAttempts?: number;    // auth / verification failures
  abnormalAmounts?: boolean; // unusually large values
  flaggedCountry?: boolean;  // high-risk jurisdiction
}

/**
 * Compute fraud score
 * Returns value between 0 (safe) and 1 (high risk)
 */
export function computeFraudScore(
  signals: FraudSignals,
): number {
  let score = 0;

  if (signals.rapidActions) {
    score += Math.min(
      signals.rapidActions * 0.05,
      0.3,
    );
  }

  if (signals.ipChanges) {
    score += Math.min(
      signals.ipChanges * 0.1,
      0.2,
    );
  }

  if (signals.failedAttempts) {
    score += Math.min(
      signals.failedAttempts * 0.1,
      0.3,
    );
  }

  if (signals.abnormalAmounts) {
    score += 0.15;
  }

  if (signals.flaggedCountry) {
    score += 0.2;
  }

  // Clamp to [0,1]
  return Math.min(
    Math.max(Number(score.toFixed(3)), 0),
    1,
  );
}
