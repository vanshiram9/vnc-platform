// ============================================================
// VNC PLATFORM — FEATURE FLAGS (UI ONLY)
// File: lib/core/feature.flags.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/// Feature flags as reported by backend.
/// IMPORTANT:
/// - UI visibility hint only
/// - Backend Zero-Trust is final authority
/// - Never enable/disable logic based on client flags alone
enum FeatureFlag {
  auth,
  wallet,
  mining,
  ads,
  trade,
  importExport,
  merchant,
  kyc,
  support,
  admin,
  owner,
}

/// Parse backend wire key to [FeatureFlag].
/// Unknown keys are ignored safely.
FeatureFlag? parseFeatureFlag(String key) {
  switch (key) {
    case 'AUTH':
      return FeatureFlag.auth;
    case 'WALLET':
      return FeatureFlag.wallet;
    case 'MINING':
      return FeatureFlag.mining;
    case 'ADS':
      return FeatureFlag.ads;
    case 'TRADE':
      return FeatureFlag.trade;
    case 'IMPORT_EXPORT':
      return FeatureFlag.importExport;
    case 'MERCHANT':
      return FeatureFlag.merchant;
    case 'KYC':
      return FeatureFlag.kyc;
    case 'SUPPORT':
      return FeatureFlag.support;
    case 'ADMIN':
      return FeatureFlag.admin;
    case 'OWNER':
      return FeatureFlag.owner;
    default:
      return null;
  }
}

/// Convert [FeatureFlag] to backend wire key.
/// Used only for diagnostics / logs.
String featureFlagToWire(FeatureFlag flag) {
  switch (flag) {
    case FeatureFlag.auth:
      return 'AUTH';
    case FeatureFlag.wallet:
      return 'WALLET';
    case FeatureFlag.mining:
      return 'MINING';
    case FeatureFlag.ads:
      return 'ADS';
    case FeatureFlag.trade:
      return 'TRADE';
    case FeatureFlag.importExport:
      return 'IMPORT_EXPORT';
    case FeatureFlag.merchant:
      return 'MERCHANT';
    case FeatureFlag.kyc:
      return 'KYC';
    case FeatureFlag.support:
      return 'SUPPORT';
    case FeatureFlag.admin:
      return 'ADMIN';
    case FeatureFlag.owner:
      return 'OWNER';
  }
}

/// UI helpers (NO authority)
extension FeatureFlagX on FeatureFlag {
  String get label {
    switch (this) {
      case FeatureFlag.auth:
        return 'Authentication';
      case FeatureFlag.wallet:
        return 'Wallet';
      case FeatureFlag.mining:
        return 'Mining';
      case FeatureFlag.ads:
        return 'Ads';
      case FeatureFlag.trade:
        return 'Trade';
      case FeatureFlag.importExport:
        return 'Import / Export';
      case FeatureFlag.merchant:
        return 'Merchant';
      case FeatureFlag.kyc:
        return 'KYC';
      case FeatureFlag.support:
        return 'Support';
      case FeatureFlag.admin:
        return 'Admin';
      case FeatureFlag.owner:
        return 'Owner';
    }
  }
}
