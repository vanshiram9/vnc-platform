// backend/src/import_export/ie.service.ts

import {
  Injectable,
  BadRequestException,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';

import { UsersService } from '../users/users.service';
import { TradeService } from '../trade/trade.service';
import { KycService } from '../kyc/kyc.service';
import { WalletService } from '../wallet/wallet.service';

import { EscrowLcLogic } from './escrow.lc.logic';
import { getCountryRule } from '../core/country.rules';
import { RiskAction, evaluateRisk } from '../core/risk.matrix';
import { FeatureFlag } from '../core/feature.flags';

interface CreateIeContractPayload {
  tradeId: string;
  importerCountry: string;
  exporterCountry: string;
  goodsDescription: string;
  value: number;
}

@Injectable()
export class IeService {
  constructor(
    private readonly usersService: UsersService,
    private readonly tradeService: TradeService,
    private readonly kycService: KycService,
    private readonly walletService: WalletService,
    private readonly escrowLogic: EscrowLcLogic,
  ) {}

  /**
   * Create an import/export contract backed by LC escrow
   */
  async createContract(
    identifier: string,
    payload: CreateIeContractPayload,
  ) {
    if (!payload.tradeId || payload.value <= 0) {
      throw new BadRequestException('INVALID_IE_PARAMS');
    }

    const user = await this.usersService.getByIdentifier(
      identifier,
    );

    // KYC gate
    const kyc = await this.kycService.getByIdentifier(
      identifier,
    );
    if (kyc.status !== 'APPROVED') {
      throw new ForbiddenException('KYC_REQUIRED');
    }

    // Country rules gate (importer & exporter)
    const importerRule = getCountryRule(
      payload.importerCountry,
    );
    const exporterRule = getCountryRule(
      payload.exporterCountry,
    );

    if (
      importerRule.policy === 'BLOCK' ||
      exporterRule.policy === 'BLOCK'
    ) {
      throw new ForbiddenException(
        'COUNTRY_BLOCKED',
      );
    }

    // Risk gate
    const risk = evaluateRisk({
      countryRule: importerRule,
      featureSnapshot: {
        [FeatureFlag.AUTH]: true,
        [FeatureFlag.WALLET]: true,
        [FeatureFlag.MINING]: true,
        [FeatureFlag.ADS]: true,
        [FeatureFlag.TRADE]: true,
        [FeatureFlag.IMPORT_EXPORT]: true,
        [FeatureFlag.MERCHANT]: true,
        [FeatureFlag.KYC]: true,
        [FeatureFlag.SUPPORT]: true,
        [FeatureFlag.ADMIN]: true,
      },
      signals: {},
    });

    if (risk.action === RiskAction.FREEZE) {
      throw new ForbiddenException('RISK_FREEZE');
    }

    // Fetch underlying trade (must exist)
    const trade = await this.tradeService.getEscrowStatus(
      payload.tradeId,
    );

    // Lock funds in wallet for IE value
    await this.walletService.lockCoins(
      identifier,
      payload.value,
    );

    // Create LC-backed escrow contract
    return this.escrowLogic.createLcContract({
      userId: user.id,
      tradeId: trade.id,
      importerCountry: payload.importerCountry,
      exporterCountry: payload.exporterCountry,
      goodsDescription: payload.goodsDescription,
      value: payload.value,
    });
  }

  /**
   * Get IE dashboard for user
   * (derived from escrow logic)
   */
  async getDashboard(identifier: string) {
    const user = await this.usersService.getByIdentifier(
      identifier,
    );

    return this.escrowLogic.getContractsForUser(
      user.id,
    );
  }

  /**
   * Get escrow / LC status
   */
  async getEscrowStatus(contractId: string) {
    const contract =
      await this.escrowLogic.getContract(
        contractId,
      );

    if (!contract) {
      throw new NotFoundException(
        'IE_CONTRACT_NOT_FOUND',
      );
    }

    return contract;
  }
}b
