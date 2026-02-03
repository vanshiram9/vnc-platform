// backend/src/admin/moderation.logic.ts

import { Injectable } from '@nestjs/common';

import { UsersService } from '../users/users.service';
import { WalletService } from '../wallet/wallet.service';
import { RiskAction } from '../core/risk.matrix';

/**
 * MODERATION LOGIC
 * Applies irreversible or high-impact admin decisions.
 */
@Injectable()
export class ModerationLogic {
  constructor(
    private readonly usersService: UsersService,
    private readonly walletService: WalletService,
  ) {}

  /**
   * Freeze or unfreeze a user account
   * - Freezing disables wallet operations
   * - Unfreezing restores normal operations
   */
  async applyFreeze(
    userId: string,
    freeze: boolean,
  ) {
    // Update user state
    await this.usersService.setFrozen(
      userId,
      freeze,
    );

    // Enforce wallet freeze as well
    await this.walletService.setFrozen(
      userId,
      freeze,
    );

    return {
      userId,
      action: freeze
        ? RiskAction.FREEZE
        : RiskAction.UNFREEZE,
      timestamp: new Date(),
    };
  }
}
