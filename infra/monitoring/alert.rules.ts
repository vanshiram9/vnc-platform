// infra/monitoring/alert.rules.ts

/**
 * VNC PLATFORM — ALERT RULES
 * Final Master Hard-Lock Version: v6.7.0.4
 *
 * Purpose:
 * - Convert SLO burn into actionable alerts
 * - Minimize false positives
 * - Provide clear on-call guidance
 *
 * NOTE:
 * - No side effects
 * - Pure configuration + evaluation helpers
 */

import {
  SLODefinition,
  calculateErrorBudget
} from './uptime.slo';

export type AlertSeverity = 'INFO' | 'WARNING' | 'CRITICAL';

export interface AlertRule {
  name: string;
  description: string;
  severity: AlertSeverity;
  window: '30d' | '7d' | '24h';
  condition: (params: {
    slo: SLODefinition;
    totalRequests: number;
    failedRequests: number;
  }) => boolean;
  runbook: string;
}

export const ALERT_RULES: AlertRule[] = [
  {
    name: 'api-availability-warning',
    description:
      'API availability SLO burn approaching threshold',
    severity: 'WARNING',
    window: '7d',
    condition: ({ slo, totalRequests, failedRequests }) => {
      const { remaining } = calculateErrorBudget(
        slo,
        totalRequests,
        failedRequests
      );
      // Warn when remaining budget < 50%
      const allowedFailures =
        totalRequests * (1 - slo.objective / 100);
      return remaining <= allowedFailures * 0.5;
    },
    runbook:
      'Check recent deploys, dependency health, and traffic anomalies.'
  },
  {
    name: 'api-availability-critical',
    description:
      'API availability SLO budget exhausted',
    severity: 'CRITICAL',
    window: '24h',
    condition: ({ slo, totalRequests, failedRequests }) => {
      const { remaining } = calculateErrorBudget(
        slo,
        totalRequests,
        failedRequests
      );
      return remaining === 0;
    },
    runbook:
      'Freeze risky operations, verify infra health, escalate to owner if required.'
  },
  {
    name: 'auth-availability-critical',
    description:
      'Authentication/OTP availability critically degraded',
    severity: 'CRITICAL',
    window: '24h',
    condition: ({ slo, totalRequests, failedRequests }) => {
      const { remaining } = calculateErrorBudget(
        slo,
        totalRequests,
        failedRequests
      );
      return remaining === 0;
    },
    runbook:
      'Investigate auth service, OTP provider, and database connectivity immediately.'
  }
];

/**
 * Evaluate all alert rules for a given SLO snapshot
 */
export function evaluateAlerts(input: {
  slo: SLODefinition;
  totalRequests: number;
  failedRequests: number;
}): AlertRule[] {
  return ALERT_RULES.filter(rule =>
    rule.condition({
      slo: input.slo,
      totalRequests: input.totalRequests,
      failedRequests: input.failedRequests
    })
  );
}
