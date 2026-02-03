// backend/src/import_export/escrow.lc.logic.ts

/**
 * VNC PLATFORM — ESCROW / LC LOGIC
 * FINAL & HARD-LOCKED
 *
 * Purpose:
 * - Manage Letter of Credit (LC) backed escrow contracts
 * - Deterministic state transitions
 *
 * IMPORTANT:
 * - Tree does not define a persistent IE entity
 * - Hence this logic maintains an in-memory registry
 * - Persistence (if ever required) must be introduced
 *   ONLY via tree update (not here)
 */

export type EscrowStatus =
  | 'CREATED'
  | 'FUNDS_LOCKED'
  | 'SHIPPED'
  | 'DELIVERED'
  | 'SETTLED'
  | 'CANCELLED';

export interface EscrowContract {
  id: string;
  userId: string;
  tradeId: string;

  importerCountry: string;
  exporterCountry: string;

  goodsDescription: string;
  value: number;

  status: EscrowStatus;

  createdAt: Date;
  updatedAt: Date;
}

/**
 * In-memory escrow registry
 * Keyed by contractId
 */
const contracts = new Map<string, EscrowContract>();

function generateId(): string {
  return 'lc_' + Math.random().toString(36).slice(2, 12);
}

/**
 * EscrowLcLogic
 * Deterministic LC-backed escrow state machine
 */
export class EscrowLcLogic {
  /**
   * Create a new LC-backed escrow contract
   */
  createLcContract(input: {
    userId: string;
    tradeId: string;
    importerCountry: string;
    exporterCountry: string;
    goodsDescription: string;
    value: number;
  }): EscrowContract {
    const now = new Date();

    const contract: EscrowContract = {
      id: generateId(),
      userId: input.userId,
      tradeId: input.tradeId,
      importerCountry: input.importerCountry,
      exporterCountry: input.exporterCountry,
      goodsDescription: input.goodsDescription,
      value: input.value,
      status: 'CREATED',
      createdAt: now,
      updatedAt: now,
    };

    contracts.set(contract.id, contract);

    return contract;
  }

  /**
   * Transition escrow status
   * Enforces valid state progression only
   */
  updateStatus(
    contractId: string,
    nextStatus: EscrowStatus,
  ): EscrowContract | null {
    const contract = contracts.get(contractId);
    if (!contract) return null;

    const allowed = this.isTransitionAllowed(
      contract.status,
      nextStatus,
    );

    if (!allowed) return null;

    contract.status = nextStatus;
    contract.updatedAt = new Date();

    return contract;
  }

  /**
   * Get escrow contract by id
   */
  getContract(
    contractId: string,
  ): EscrowContract | null {
    return contracts.get(contractId) ?? null;
  }

  /**
   * Get all contracts for a user
   */
  getContractsForUser(
    userId: string,
  ): EscrowContract[] {
    return Array.from(contracts.values()).filter(
      (c) => c.userId === userId,
    );
  }

  /* ----------------------- */
  /* Internal helpers        */
  /* ----------------------- */

  private isTransitionAllowed(
    current: EscrowStatus,
    next: EscrowStatus,
  ): boolean {
    const transitions: Record<
      EscrowStatus,
      EscrowStatus[]
    > = {
      CREATED: ['FUNDS_LOCKED', 'CANCELLED'],
      FUNDS_LOCKED: ['SHIPPED', 'CANCELLED'],
      SHIPPED: ['DELIVERED', 'CANCELLED'],
      DELIVERED: ['SETTLED'],
      SETTLED: [],
      CANCELLED: [],
    };

    return transitions[current]?.includes(next) ?? false;
  }
}
