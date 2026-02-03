// backend/src/compliance/judicial.response.ts

/**
 * VNC PLATFORM — JUDICIAL RESPONSE
 * FINAL & HARD-LOCKED
 *
 * Purpose:
 * - Prepare structured responses to court / legal requests
 * - Ensure traceability, completeness, and auditability
 *
 * IMPORTANT:
 * - No persistence
 * - No transmission logic
 * - Data assembly only
 */

export interface JudicialCaseRequest {
  caseId: string;
  authority: string;
  periodStart: Date;
  periodEnd: Date;
}

export interface JudicialUserSnapshot {
  userId: string;
  kycStatus: 'PENDING' | 'APPROVED' | 'REJECTED';
  walletBalance: number;
  trades: {
    tradeId: string;
    asset: string;
    amount: number;
    price: number;
    status: string;
  }[];
  riskFlags: string[];
}

export interface JudicialResponse {
  responseId: string;
  caseId: string;
  authority: string;
  generatedAt: Date;
  periodStart: Date;
  periodEnd: Date;
  users: JudicialUserSnapshot[];
}

function generateId(): string {
  return 'jud_' + Math.random().toString(36).slice(2, 12);
}

/**
 * Build judicial response payload
 */
export function generateJudicialResponse(input: {
  request: JudicialCaseRequest;
  users: {
    userId: string;
    kycStatus: 'PENDING' | 'APPROVED' | 'REJECTED';
    walletBalance: number;
    trades: {
      tradeId: string;
      asset: string;
      amount: number;
      price: number;
      status: string;
    }[];
    riskFlags?: string[];
  }[];
}): JudicialResponse {
  return {
    responseId: generateId(),
    caseId: input.request.caseId,
    authority: input.request.authority,
    generatedAt: new Date(),
    periodStart: input.request.periodStart,
    periodEnd: input.request.periodEnd,
    users: input.users.map((u) => ({
      userId: u.userId,
      kycStatus: u.kycStatus,
      walletBalance: u.walletBalance,
      trades: u.trades,
      riskFlags: u.riskFlags ?? [],
    })),
  };
}
