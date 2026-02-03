// backend/src/compliance/aml.report.ts

/**
 * VNC PLATFORM — AML REPORT
 * FINAL & HARD-LOCKED
 *
 * Purpose:
 * - Generate AML-compliant activity reports
 * - Provide structured, auditable output
 *
 * IMPORTANT:
 * - No persistence
 * - No external transmission
 * - Report generation only
 */

export interface AmlTransactionSummary {
  userId: string;
  totalVolume: number;
  transactionCount: number;
  highRiskFlags: string[];
}

export interface AmlReport {
  reportId: string;
  generatedAt: Date;
  periodStart: Date;
  periodEnd: Date;
  summaries: AmlTransactionSummary[];
}

function generateId(): string {
  return 'aml_' + Math.random().toString(36).slice(2, 12);
}

/**
 * Build AML report
 */
export function generateAmlReport(input: {
  periodStart: Date;
  periodEnd: Date;
  transactions: {
    userId: string;
    amount: number;
    flags?: string[];
  }[];
}): AmlReport {
  const map = new Map<string, AmlTransactionSummary>();

  for (const tx of input.transactions) {
    if (!map.has(tx.userId)) {
      map.set(tx.userId, {
        userId: tx.userId,
        totalVolume: 0,
        transactionCount: 0,
        highRiskFlags: [],
      });
    }

    const summary = map.get(tx.userId)!;
    summary.totalVolume += tx.amount;
    summary.transactionCount += 1;

    if (tx.flags?.length) {
      summary.highRiskFlags.push(...tx.flags);
    }
  }

  return {
    reportId: generateId(),
    generatedAt: new Date(),
    periodStart: input.periodStart,
    periodEnd: input.periodEnd,
    summaries: Array.from(map.values()),
  };
}
