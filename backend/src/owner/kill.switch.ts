// backend/src/owner/kill.switch.ts

/**
 * VNC PLATFORM — EMERGENCY KILL SWITCH
 * FINAL & HARD-LOCKED
 *
 * Purpose:
 * - Instantly disable critical platform operations
 * - Used during security incidents, regulatory orders,
 *   or catastrophic failures
 *
 * IMPORTANT:
 * - In-memory state by tree definition
 * - Persistence requires explicit tree update
 */

export interface KillSwitchState {
  active: boolean;
  reason?: string;
  activatedAt?: Date;
}

/**
 * KillSwitch
 * Global emergency control
 */
export class KillSwitch {
  private state: KillSwitchState = {
    active: false,
  };

  /**
   * Activate kill switch
   */
  activate(reason?: string) {
    this.state = {
      active: true,
      reason,
      activatedAt: new Date(),
    };
  }

  /**
   * Deactivate kill switch
   * (use with extreme caution)
   */
  deactivate() {
    this.state = {
      active: false,
    };
  }

  /**
   * Get current kill switch state
   */
  getStatus(): KillSwitchState {
    return { ...this.state };
  }

  /**
   * Guard helper for critical paths
   */
  isActive(): boolean {
    return this.state.active === true;
  }
}
