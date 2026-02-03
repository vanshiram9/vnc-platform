// backend/src/app.module.ts

import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';

import { AppController } from './app.controller';
import { AppService } from './app.service';

/**
 * Bootstrap & Config
 */
import { ConfigSchema } from './config/config.schema';
import { EnvLoader } from './config/env.loader';
import { ConfigModule as AppConfigModule } from './config/config.module';

/**
 * Auth & Security
 */
import { AuthModule } from './auth/auth.module';

/**
 * Core Domain Modules
 */
import { UsersModule } from './users/users.module';
import { KycModule } from './kyc/kyc.module';
import { WalletModule } from './wallet/wallet.module';
import { MiningModule } from './mining/mining.module';
import { AdsModule } from './ads/ads.module';
import { TradeModule } from './trade/trade.module';
import { ImportExportModule } from './import_export/ie.module';
import { MerchantModule } from './merchant/merchant.module';
import { FaqModule } from './faq/faq.module';
import { SupportModule } from './support/support.module';

/**
 * Admin / Owner
 */
import { AdminModule } from './admin/admin.module';
import { OwnerModule } from './owner/owner.module';

/**
 * Compliance & Security Layers
 */
import { ComplianceModule } from './compliance/compliance.module';
import { SecurityModule } from './security/security.module';

@Module({
  imports: [
    /**
     * Global Config
     * Loads env → validates → freezes
     */
    ConfigModule.forRoot({
      isGlobal: true,
      load: [EnvLoader],
      validationSchema: ConfigSchema,
      cache: true,
      expandVariables: true,
    }),

    AppConfigModule,

    /**
     * Security / Auth
     */
    AuthModule,
    SecurityModule,

    /**
     * Core Business Domains
     */
    UsersModule,
    KycModule,
    WalletModule,
    MiningModule,
    AdsModule,
    TradeModule,
    ImportExportModule,
    MerchantModule,

    /**
     * Support & Content
     */
    FaqModule,
    SupportModule,

    /**
     * Admin / Owner Control Planes
     */
    AdminModule,
    OwnerModule,

    /**
     * Compliance & Regulatory
     */
    ComplianceModule,
  ],

  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
