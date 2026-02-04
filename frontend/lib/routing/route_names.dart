// ============================================================
// VNC PLATFORM — ROUTE NAMES
// File: lib/routing/route_names.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/// Centralized route name definitions.
/// IMPORTANT:
/// - No hardcoded strings elsewhere
/// - Guards decide access, not routes
abstract class RouteNames {
  RouteNames._();

  /* ---------------------------------------------------------- */
  /* SPLASH / SYSTEM                                           */
  /* ---------------------------------------------------------- */

  static const String splash = '/';
  static const String maintenance = '/maintenance';
  static const String versionBlock = '/version-block';

  /* ---------------------------------------------------------- */
  /* AUTH                                                       */
  /* ---------------------------------------------------------- */

  static const String login = '/login';
  static const String otp = '/otp';
  static const String deviceVerify = '/device-verify';
  static const String blocked = '/blocked';

  /* ---------------------------------------------------------- */
  /* HOME                                                       */
  /* ---------------------------------------------------------- */

  static const String home = '/home';

  /* ---------------------------------------------------------- */
  /* WALLET                                                     */
  /* ---------------------------------------------------------- */

  static const String wallet = '/wallet';
  static const String ledger = '/wallet/ledger';
  static const String lockCoins = '/wallet/lock';
  static const String unlockStatus = '/wallet/unlock-status';
  static const String withdraw = '/wallet/withdraw';
  static const String qrPay = '/wallet/qr-pay';

  /* ---------------------------------------------------------- */
  /* MINING                                                     */
  /* ---------------------------------------------------------- */

  static const String mining = '/mining';
  static const String miningBoost = '/mining/boost';
  static const String miningReferral = '/mining/referral';
  static const String miningHistory = '/mining/history';

  /* ---------------------------------------------------------- */
  /* TRADE                                                      */
  /* ---------------------------------------------------------- */

  static const String tradeHome = '/trade';
  static const String buySell = '/trade/buy-sell';
  static const String orderHistory = '/trade/history';
  static const String escrowStatus = '/trade/escrow';

  /* ---------------------------------------------------------- */
  /* MERCHANT                                                   */
  /* ---------------------------------------------------------- */

  static const String merchantDashboard = '/merchant';
  static const String merchantQr = '/merchant/qr';
  static const String merchantSettlement = '/merchant/settlement';
  static const String merchantKyc = '/merchant/kyc';

  /* ---------------------------------------------------------- */
  /* IMPORT / EXPORT                                            */
  /* ---------------------------------------------------------- */

  static const String ieDashboard = '/ie';
  static const String ieCreateContract = '/ie/create';
  static const String ieEscrowStatus = '/ie/escrow';
  static const String ieCompliance = '/ie/compliance';

  /* ---------------------------------------------------------- */
  /* FAQ / SUPPORT                                              */
  /* ---------------------------------------------------------- */

  static const String faq = '/faq';
  static const String faqDetail = '/faq/detail';

  static const String supportHome = '/support';
  static const String supportCreate = '/support/create';
  static const String supportStatus = '/support/status';

  /* ---------------------------------------------------------- */
  /* ADMIN                                                      */
  /* ---------------------------------------------------------- */

  static const String adminDashboard = '/admin';
  static const String userModeration = '/admin/users';
  static const String kycReview = '/admin/kyc';
  static const String transactionReview = '/admin/transactions';
  static const String fraudAlerts = '/admin/fraud';
  static const String auditLogs = '/admin/audit';

  /* ---------------------------------------------------------- */
  /* OWNER                                                      */
  /* ---------------------------------------------------------- */

  static const String ownerDashboard = '/owner';
  static const String featureToggle = '/owner/features';
  static const String countryRule = '/owner/countries';
  static const String systemControl = '/owner/system';
  static const String emergencyKill = '/owner/emergency';
}
