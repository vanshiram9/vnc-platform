// backend/src/wallet/ledger.hashchain.ts

import * as crypto from 'crypto';
import { LedgerEntry } from './ledger.entry';

/**
 * HashChainEntry
 * Represents a ledger entry with its computed hash.
 */
export interface HashChainEntry {
  entryId: string;
  hash: string;
  prevHash: string | null;
  createdAt: Date;
}

/**
 * Compute a deterministic hash for a ledger entry.
 * NOTE:
 * - Amount is stringified to avoid floating precision ambiguity
 * - Field order is fixed to ensure consistency
 */
export function computeLedgerHash(
  entry: LedgerEntry,
  prevHash: string | null,
): string {
  const payload = [
    entry.id,
    entry.userId,
    entry.type,
    entry.amount.toString(),
    entry.note ?? '',
    entry.createdAt.toISOString(),
    prevHash ?? '',
  ].join('|');

  return crypto
    .createHash('sha256')
    .update(payload)
    .digest('hex');
}

/**
 * Build a hash chain from ordered ledger entries.
 * Entries MUST be sorted by createdAt ASC before passing.
 */
export function buildHashChain(
  entries: LedgerEntry[],
): HashChainEntry[] {
  const chain: HashChainEntry[] = [];

  let prevHash: string | null = null;

  for (const entry of entries) {
    const hash = computeLedgerHash(entry, prevHash);

    chain.push({
      entryId: entry.id,
      hash,
      prevHash,
      createdAt: entry.createdAt,
    });

    prevHash = hash;
  }

  return chain;
}

/**
 * Verify integrity of a hash chain.
 * Returns false on first mismatch.
 */
export function verifyHashChain(
  entries: LedgerEntry[],
  chain: HashChainEntry[],
): boolean {
  if (entries.length !== chain.length) {
    return false;
  }

  let prevHash: string | null = null;

  for (let i = 0; i < entries.length; i++) {
    const expected = computeLedgerHash(
      entries[i],
      prevHash,
    );

    if (chain[i].hash !== expected) {
      return false;
    }

    prevHash = chain[i].hash;
  }

  return true;
}
