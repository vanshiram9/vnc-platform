// backend/src/ads/ads.antifraud.ts

/**
 * VNC PLATFORM — ADS ANTI-FRAUD
 * FINAL & HARD-LOCKED
 *
 * Purpose:
 * - Validate ad interaction events
 * - Reject obvious abuse patterns deterministically
 *
 * IMPORTANT:
 * - Stateless (no persistence)
 * - No external lookups
 * - Caller provides all required context
 */

interface AdEventPayload {
  adId: string;
  event: 'VIEW' | 'CLICK' | 'COMPLETE';
  metadata?: Record<string, any>;
}

/**
 * Simple in-memory rolling window (process-scoped)
 * NOTE:
 * - Acceptable per tree (no persistence defined)
 * - Protects against burst abuse
 */
type Window = { count: number; resetAt: number };
const EVENT_WINDOW_MS = 60_000; // 1 minute
const MAX_EVENTS_PER_MINUTE = 120;

const perUserWindow = new Map<string, Window>();
const perAdWindow = new Map<string, Window>();

function checkWindow(key: string, store: Map<string, Window>): boolean {
  const now = Date.now();
  const win = store.get(key);

  if (!win || now > win.resetAt) {
    store.set(key, { count: 1, resetAt: now + EVENT_WINDOW_MS });
    return true;
  }

  if (win.count >= MAX_EVENTS_PER_MINUTE) {
    return false;
  }

  win.count += 1;
  return true;
}

/**
 * AdsAntiFraud
 * Deterministic validation helpers
 */
export class AdsAntiFraud {
  /**
   * Validate ad event for a user
   */
  validateEvent(userId: string, payload: AdEventPayload): boolean {
    // Basic sanity
    if (!userId || !payload?.adId || !payload?.event) {
      return false;
    }

    // Rate limits
    if (!checkWindow(`u:${userId}`, perUserWindow)) {
      return false;
    }
    if (!checkWindow(`a:${payload.adId}`, perAdWindow)) {
      return false;
    }

    // Sequencing heuristic:
    // COMPLETE without prior VIEW/CLICK is suspicious
    const seq = payload.metadata?.sequence as
      | 'VIEW'
      | 'CLICK'
      | 'COMPLETE'
      | undefined;

    if (payload.event === 'COMPLETE' && !seq) {
      return false;
    }

    // Known bad metadata flags (caller-provided hints)
    if (payload.metadata?.emulated === true) {
      return false;
    }

    return true;
  }
}
