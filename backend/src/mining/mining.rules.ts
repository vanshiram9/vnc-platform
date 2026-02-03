// backend/src/mining/mining.rules.ts

/**
 * VNC PLATFORM — MINING RULES
 * FINAL & HARD-LOCKED
 *
 * Purpose:
 * - Define reward calculation logic
 * - Keep all mining economics isolated here
 *
 * IMPORTANT:
 * - No persistence
 * - No side effects
 * - Deterministic math only
 */

/**
 * Mining constants
 * Tuned for stability and anti-abuse
 */
const BASE_REWARD_PER_HOUR = 1; // base units/hour
const MAX_IDLE_HOURS = 24; // cap rewards if user inactive
const MIN_TICK_INTERVAL_MINUTES = 10;

/**
 * MiningRules
 * Pure calculation utilities
 */
export class MiningRules {
  /**
   * Calculate reward based on time elapsed
   *
   * @param startedAt session start time
   * @param lastRewardAt last reward timestamp (nullable)
   */
  calculateReward(
    startedAt: Date,
    lastRewardAt: Date | null,
  ): number {
    const now = new Date();

    const from = lastRewardAt ?? startedAt;
    const diffMs = now.getTime() - from.getTime();

    if (diffMs <= 0) return 0;

    const diffMinutes = diffMs / (1000 * 60);

    // Enforce minimum tick interval
    if (diffMinutes < MIN_TICK_INTERVAL_MINUTES) {
      return 0;
    }

    const diffHours = diffMinutes / 60;

    // Cap idle accrual
    const effectiveHours = Math.min(
      diffHours,
      MAX_IDLE_HOURS,
    );

    const reward =
      effectiveHours * BASE_REWARD_PER_HOUR;

    // Normalize to 8 decimal places
    return Number(reward.toFixed(8));
  }
}
