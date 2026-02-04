// ============================================================
// VNC PLATFORM — APP ROUTER
// File: lib/routing/app_router.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import 'route_names.dart';
import 'route_guards.dart';

/* ------------------------------------------------------------ */
/* SCREENS                                                      */
/* ------------------------------------------------------------ */

// Splash / System
import '../screens/splash/splash_screen.dart';
import '../screens/splash/maintenance_screen.dart';
import '../screens/splash/version_block_screen.dart';

// Auth
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/device_verify_screen.dart';
import '../screens/auth/blocked_screen.dart';

// Home
import '../screens/home/home_screen.dart';

// Wallet
import '../screens/wallet/wallet_screen.dart';
import '../screens/wallet/ledger_screen.dart';
import '../screens/wallet/lock_coins_screen.dart';
import '../screens/wallet/unlock_status_screen.dart';
import '../screens/wallet/withdraw_screen.dart';
import '../screens/wallet/qr_pay_screen.dart';

// Mining
import '../screens/mining/mining_screen.dart';
import '../screens/mining/boost_screen.dart';
import '../screens/mining/referral_screen.dart';
import '../screens/mining/mining_history_screen.dart';

// Trade
import '../screens/trade/trade_home_screen.dart';
import '../screens/trade/buy_sell_screen.dart';
import '../screens/trade/order_history_screen.dart';
import '../screens/trade/escrow_status_screen.dart';

// Merchant
import '../screens/merchant/merchant_dashboard_screen.dart';
import '../screens/merchant/merchant_qr_screen.dart';
import '../screens/merchant/merchant_settlement_screen.dart';
import '../screens/merchant/merchant_kyc_screen.dart';

// Import / Export
import '../screens/import_export/ie_dashboard_screen.dart';
import '../screens/import_export/ie_create_contract_screen.dart';
import '../screens/import_export/ie_escrow_status_screen.dart';
import '../screens/import_export/ie_compliance_screen.dart';

// FAQ / Support
import '../screens/faq/faq_screen.dart';
import '../screens/faq/faq_detail_screen.dart';
import '../screens/support/support_home_screen.dart';
import '../screens/support/ticket_create_screen.dart';
import '../screens/support/ticket_status_screen.dart';

// Admin
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/user_moderation_screen.dart';
import '../screens/admin/kyc_review_screen.dart';
import '../screens/admin/transaction_review_screen.dart';
import '../screens/admin/fraud_alert_screen.dart';
import '../screens/admin/audit_log_screen.dart';

// Owner
import '../screens/owner/owner_dashboard_screen.dart';
import '../screens/owner/feature_toggle_screen.dart';
import '../screens/owner/country_rule_screen.dart';
import '../screens/owner/system_control_screen.dart';
import '../screens/owner/emergency_kill_screen.dart';

/* ------------------------------------------------------------ */
/* ROUTER                                                       */
/* ------------------------------------------------------------ */

class AppRouter {
  static Route<dynamic> generate(RouteSettings settings) {
    final String? name = settings.name;

    switch (name) {
      /* ---------------- SPLASH / SYSTEM ---------------- */

      case RouteNames.splash:
        return _page(const SplashScreen());

      case RouteNames.maintenance:
        return _page(const MaintenanceScreen());

      case RouteNames.versionBlock:
        return _page(const VersionBlockScreen());

      /* ---------------- AUTH ---------------- */

      case RouteNames.login:
        return _page(const LoginScreen());

      case RouteNames.otp:
        return _page(const OtpScreen());

      case RouteNames.deviceVerify:
        return _page(const DeviceVerifyScreen());

      case RouteNames.blocked:
        return _page(const BlockedScreen());

      /* ---------------- HOME ---------------- */

      case RouteNames.home:
        return RouteGuards.authenticated(
          settings,
          const HomeScreen(),
        );

      /* ---------------- WALLET ---------------- */

      case RouteNames.wallet:
        return RouteGuards.authenticated(
          settings,
          const WalletScreen(),
        );

      case RouteNames.ledger:
        return RouteGuards.authenticated(
          settings,
          const LedgerScreen(),
        );

      case RouteNames.lockCoins:
        return RouteGuards.authenticated(
          settings,
          const LockCoinsScreen(),
        );

      case RouteNames.unlockStatus:
        return RouteGuards.authenticated(
          settings,
          const UnlockStatusScreen(),
        );

      case RouteNames.withdraw:
        return RouteGuards.authenticated(
          settings,
          const WithdrawScreen(),
        );

      case RouteNames.qrPay:
        return RouteGuards.authenticated(
          settings,
          const QrPayScreen(),
        );

      /* ---------------- MINING ---------------- */

      case RouteNames.mining:
        return RouteGuards.authenticated(
          settings,
          const MiningScreen(),
        );

      case RouteNames.miningBoost:
        return RouteGuards.authenticated(
          settings,
          const BoostScreen(),
        );

      case RouteNames.miningReferral:
        return RouteGuards.authenticated(
          settings,
          const ReferralScreen(),
        );

      case RouteNames.miningHistory:
        return RouteGuards.authenticated(
          settings,
          const MiningHistoryScreen(),
        );

      /* ---------------- TRADE ---------------- */

      case RouteNames.tradeHome:
        return RouteGuards.authenticated(
          settings,
          const TradeHomeScreen(),
        );

      case RouteNames.buySell:
        return RouteGuards.authenticated(
          settings,
          const BuySellScreen(),
        );

      case RouteNames.orderHistory:
        return RouteGuards.authenticated(
          settings,
          const OrderHistoryScreen(),
        );

      case RouteNames.escrowStatus:
        return RouteGuards.authenticated(
          settings,
          const EscrowStatusScreen(),
        );

      /* ---------------- MERCHANT ---------------- */

      case RouteNames.merchantDashboard:
        return RouteGuards.authenticated(
          settings,
          const MerchantDashboardScreen(),
        );

      case RouteNames.merchantQr:
        return RouteGuards.authenticated(
          settings,
          const MerchantQrScreen(),
        );

      case RouteNames.merchantSettlement:
        return RouteGuards.authenticated(
          settings,
          const MerchantSettlementScreen(),
        );

      case RouteNames.merchantKyc:
        return RouteGuards.authenticated(
          settings,
          const MerchantKycScreen(),
        );

      /* ---------------- IMPORT / EXPORT ---------------- */

      case RouteNames.ieDashboard:
        return RouteGuards.authenticated(
          settings,
          const IEDashboardScreen(),
        );

      case RouteNames.ieCreateContract:
        return RouteGuards.authenticated(
          settings,
          const IECreateContractScreen(),
        );

      case RouteNames.ieEscrowStatus:
        return RouteGuards.authenticated(
          settings,
          const IEEscrowStatusScreen(),
        );

      case RouteNames.ieCompliance:
        return RouteGuards.authenticated(
          settings,
          const IEComplianceScreen(),
        );

      /* ---------------- FAQ / SUPPORT ---------------- */

      case RouteNames.faq:
        return RouteGuards.authenticated(
          settings,
          const FaqScreen(),
        );

      case RouteNames.faqDetail:
        return RouteGuards.authenticated(
          settings,
          const FaqDetailScreen(),
        );

      case RouteNames.supportHome:
        return RouteGuards.authenticated(
          settings,
          const SupportHomeScreen(),
        );

      case RouteNames.supportCreate:
        return RouteGuards.authenticated(
          settings,
          const TicketCreateScreen(),
        );

      case RouteNames.supportStatus:
        return RouteGuards.authenticated(
          settings,
          const TicketStatusScreen(),
        );

      /* ---------------- ADMIN ---------------- */

      case RouteNames.adminDashboard:
        return RouteGuards.adminOnly(
          settings,
          const AdminDashboardScreen(),
        );

      case RouteNames.userModeration:
        return RouteGuards.adminOnly(
          settings,
          const UserModerationScreen(),
        );

      case RouteNames.kycReview:
        return RouteGuards.adminOnly(
          settings,
          const KycReviewScreen(),
        );

      case RouteNames.transactionReview:
        return RouteGuards.adminOnly(
          settings,
          const TransactionReviewScreen(),
        );

      case RouteNames.fraudAlerts:
        return RouteGuards.adminOnly(
          settings,
          const FraudAlertScreen(),
        );

      case RouteNames.auditLogs:
        return RouteGuards.adminOnly(
          settings,
          const AuditLogScreen(),
        );

      /* ---------------- OWNER ---------------- */

      case RouteNames.ownerDashboard:
        return RouteGuards.ownerOnly(
          settings,
          const OwnerDashboardScreen(),
        );

      case RouteNames.featureToggle:
        return RouteGuards.ownerOnly(
          settings,
          const FeatureToggleScreen(),
        );

      case RouteNames.countryRule:
        return RouteGuards.ownerOnly(
          settings,
          const CountryRuleScreen(),
        );

      case RouteNames.systemControl:
        return RouteGuards.ownerOnly(
          settings,
          const SystemControlScreen(),
        );

      case RouteNames.emergencyKill:
        return RouteGuards.ownerOnly(
          settings,
          const EmergencyKillScreen(),
        );

      /* ---------------- FALLBACK ---------------- */

      default:
        return unknown();
    }
  }

  static Route<dynamic> unknown() {
    return _page(
      const Scaffold(
        body: Center(
          child: Text('Page not found'),
        ),
      ),
    );
  }

  static Route<dynamic> _page(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }
}
