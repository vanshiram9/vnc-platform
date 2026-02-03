// backend/src/ai/anomaly.detect.ts

/**
 * VNC PLATFORM — ANOMALY DETECTION
 * FINAL & HARD-LOCKED
 *
 * Purpose:
 * - Detect abnormal behavior patterns
 * - Produce explainable anomaly flags
 *
 * IMPORTANT:
 * - No ML / probabilistic models
 * - Deterministic & auditable
 */

export interface ActivitySnapshot {
  averageAmount: number;
  currentAmount: number;
  averageFrequencyPerHour: number;
  currentFrequencyPerHour: number;
  geoDeviation?: boolean;
}

/**
 * Detect anomalies in user activity
 */
export function detectAnomaly(
  snapshot: ActivitySnapshot,
): {
  anomalous: boolean;
  reasons: string[];
} {
  const reasons: string[] = [];

  // Amount spike detection
  if (
    snapshot.averageAmount > 0 &&
    snapshot.currentAmount >
      snapshot.averageAmount * 3
  ) {
    reasons.push('AMOUNT_SPIKE');
  }

  // Frequency spike detection
  if (
    snapshot.averageFrequencyPerHour > 0 &&
    snapshot.currentFrequencyPerHour >
      snapshot.averageFrequencyPerHour * 4
  ) {
    reasons.push('FREQUENCY_SPIKE');
  }

  // Geographic deviation
  if (snapshot.geoDeviation === true) {
    reasons.push('GEO_DEVIATION');
  }

  return {
    anomalous: reasons.length > 0,
    reasons,
  };
}
