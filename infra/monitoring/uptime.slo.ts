// infra/monitoring/uptime.slo.ts

/**
 * VNC PLATFORM — UPTIME & LATENCY SLO
 * Final Master Hard-Lock Version: v6.7.0.4
 *
 * Purpose:
 * - Define measurable SLOs
 * - Provide clear error budgets
 * - Avoid ambiguous availability claims
 *
 * NOTE:
 * - This file contains no runtime side-effects
 * - Consumed by monitoring/alert rules
 */

export type TimeWindow = '30d' | '7d' | '24h';

export interface SLODefinition {
  name: string;
  description: string;
  objective: number; // percentage (e.g. 99.9)
  window: TimeWindow;
  burnRateThreshold: number;
}

export const UPTIME_SLOS: SLODefinition[] = [
  {
    name: 'api-availability',
    description: 'HTTP API availability for backend services',
    objective: 99.9,
    window: '30d',
    burnRateThreshold: 2
  },
  {
    name: 'auth-availability',
    description: 'Authentication and OTP service availability',
    objective: 99.95,
    window: '30d',
    burnRateThreshold: 1.5
  }
];

export const LATENCY_SLOS: SLODefinition[] = [
  {
    name: 'api-latency-p95',
    description: '95th percentile API response latency',
    objective: 95, // % of requests under threshold
    window: '7d',
    burnRateThreshold: 2
  }
];

/**
 * Error budget calculator
 */
export function calculateErrorBudget(
  slo: SLODefinition,
  totalRequests: number,
  failedRequests: number
): {
  errorBudget: number;
  consumed: number;
  remaining: number;
} {
  const allowedFailures =
    totalRequests * (1 - slo.objective / 100);

  const consumed = Math.min(
    failedRequests,
    allowedFailures
  );

  const remaining = Math.max(
    allowedFailures - consumed,
    0
  );

  return {
    errorBudget: allowedFailures,
    consumed,
    remaining
  };
}
