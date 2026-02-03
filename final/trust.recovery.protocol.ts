// final/trust.recovery.protocol.ts

/**
 * VNC PLATFORM — TRUST RECOVERY PROTOCOL
 * Final Master Hard-Lock Version: v6.7.0.4
 *
 * Purpose:
 * - Define how trust is restored after a security incident
 * - Ensure recovery is deliberate, auditable, and controlled
 *
 * NOTE:
 * - No runtime side-effects
 * - Governance-level protocol only
 */

export type RecoveryStage =
  | 'INCIDENT_CONTAINED'
  | 'FORENSIC_REVIEW'
  | 'ROOT_CAUSE_CONFIRMED'
  | 'REMEDIATION_VERIFIED'
  | 'CONTROLLED_RESTORE';

export interface RecoveryRecord {
  stage: RecoveryStage;
  completed: boolean;
  verifiedBy: 'OWNER';
  timestamp: Date;
  notes?: string;
}

export interface TrustRecoveryState {
  active: boolean;
  records: RecoveryRecord[];
}

/**
 * Initialize recovery after a freeze
 */
export function initializeRecovery(): TrustRecoveryState {
  return {
    active: true,
    records: []
  };
}

/**
 * Append a verified recovery stage
 */
export function appendRecoveryStage(
  state: TrustRecoveryState,
  record: RecoveryRecord
): TrustRecoveryState {
  if (record.verifiedBy !== 'OWNER') {
    throw new Error('ONLY_OWNER_CAN_VERIFY_RECOVERY');
  }

  return {
    active: true,
    records: [...state.records, record]
  };
}

/**
 * Check if system is eligible for controlled restore
 */
export function isRestoreAllowed(
  state: TrustRecoveryState
): {
  allowed: boolean;
  missingStages?: RecoveryStage[];
} {
  const requiredStages: RecoveryStage[] = [
    'INCIDENT_CONTAINED',
    'FORENSIC_REVIEW',
    'ROOT_CAUSE_CONFIRMED',
    'REMEDIATION_VERIFIED'
  ];

  const completedStages = state.records
    .filter(r => r.completed)
    .map(r => r.stage);

  const missingStages = requiredStages.filter(
    s => !completedStages.includes(s)
  );

  if (missingStages.length > 0) {
    return {
      allowed: false,
      missingStages
    };
  }

  return { allowed: true };
}

/**
 * Final controlled restore marker
 */
export function markControlledRestore(
  state: TrustRecoveryState
): TrustRecoveryState {
  const eligibility = isRestoreAllowed(state);

  if (!eligibility.allowed) {
    throw new Error(
      'RECOVERY_STAGES_INCOMPLETE'
    );
  }

  return {
    active: false,
    records: [
      ...state.records,
      {
        stage: 'CONTROLLED_RESTORE',
        completed: true,
        verifiedBy: 'OWNER',
        timestamp: new Date(),
        notes: 'System restored under controlled governance'
      }
    ]
  };
}
