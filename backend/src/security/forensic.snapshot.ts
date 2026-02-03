// backend/src/security/forensic.snapshot.ts

/**
 * VNC PLATFORM — FORENSIC SNAPSHOT
 * FINAL & HARD-LOCKED
 *
 * Purpose:
 * - Capture point-in-time state during incidents
 * - Ensure legal-grade, auditable snapshots
 *
 * IMPORTANT:
 * - No persistence
 * - No transmission
 * - Snapshot generation only
 */

export interface ForensicUserState {
  userId: string;
  frozen: boolean;
  role: string;
  kycStatus?: 'PENDING' | 'APPROVED' | 'REJECTED';
}

export interface ForensicWalletState {
  userId: string;
  balance: number;
  frozen: boolean;
}

export interface ForensicTradeSnapshot {
  tradeId: string;
  asset: string;
  amount: number;
  price: number;
  status: string;
  createdAt: Date;
}

export interface ForensicSnapshot {
  snapshotId: string;
  capturedAt: Date;
  reason: string;
  user?: ForensicUserState;
  wallet?: ForensicWalletState;
  trades?: ForensicTradeSnapshot[];
  riskSignals?: string[];
}

function generateId(): string {
  return (
    'fs_' +
    Date.now().toString(36) +
    Math.random().toString(36).slice(2, 8)
  );
}

/**
 * Build forensic snapshot payload
 */
export function buildForensicSnapshot(input: {
  reason: string;
  user?: ForensicUserState;
  wallet?: ForensicWalletState;
  trades?: ForensicTradeSnapshot[];
  riskSignals?: string[];
}): ForensicSnapshot {
  return {
    snapshotId: generateId(),
    capturedAt: new Date(),
    reason: input.reason,
    user: input.user,
    wallet: input.wallet,
    trades: input.trades ?? [],
    riskSignals: input.riskSignals ?? [],
  };
}
