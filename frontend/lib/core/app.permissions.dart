// ============================================================
// VNC PLATFORM — APP PERMISSIONS (UI ONLY)
// File: lib/core/app.permissions.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/// Permission keys as reported by backend.
/// IMPORTANT:
/// - UI visibility/enablement hints only
/// - Backend Zero-Trust is the final authority
/// - Never grant access based solely on client permissions
enum AppPermission {
  viewWallet,
  withdraw,
  trade,
  mine,
  viewAds,
  merchantPay,
  importExport,
  supportCreate,
  adminReview,
  ownerControl,
}

/// Parse backend wire key to [AppPermission].
/// Unknown keys are ignored (fail-safe).
AppPermission? parseAppPermission(String key) {
  switch (key) {
    case 'VIEW_WALLET':
      return AppPermission.viewWallet;
    case 'WITHDRAW':
      return AppPermission.withdraw;
    case 'TRADE':
      return AppPermission.trade;
    case 'MINE':
      return AppPermission.mine;
    case 'VIEW_ADS':
      return AppPermission.viewAds;
    case 'MERCHANT_PAY':
      return AppPermission.merchantPay;
    case 'IMPORT_EXPORT':
      return AppPermission.importExport;
    case 'SUPPORT_CREATE':
      return AppPermission.supportCreate;
    case 'ADMIN_REVIEW':
      return AppPermission.adminReview;
    case 'OWNER_CONTROL':
      return AppPermission.ownerControl;
    default:
      return null;
  }
}

/// Convert [AppPermission] to backend wire key.
/// Used only for diagnostics/logs (never authority).
String appPermissionToWire(AppPermission p) {
  switch (p) {
    case AppPermission.viewWallet:
      return 'VIEW_WALLET';
    case AppPermission.withdraw:
      return 'WITHDRAW';
    case AppPermission.trade:
      return 'TRADE';
    case AppPermission.mine:
      return 'MINE';
    case AppPermission.viewAds:
      return 'VIEW_ADS';
    case AppPermission.merchantPay:
      return 'MERCHANT_PAY';
    case AppPermission.importExport:
      return 'IMPORT_EXPORT';
    case AppPermission.supportCreate:
      return 'SUPPORT_CREATE';
    case AppPermission.adminReview:
      return 'ADMIN_REVIEW';
    case AppPermission.ownerControl:
      return 'OWNER_CONTROL';
  }
}

/// UI helpers (NO authority)
extension AppPermissionX on AppPermission {
  String get label {
    switch (this) {
      case AppPermission.viewWallet:
        return 'View Wallet';
      case AppPermission.withdraw:
        return 'Withdraw';
      case AppPermission.trade:
        return 'Trade';
      case AppPermission.mine:
        return 'Mining';
      case AppPermission.viewAds:
        return 'Ads';
      case AppPermission.merchantPay:
        return 'Merchant Payment';
      case AppPermission.importExport:
        return 'Import / Export';
      case AppPermission.supportCreate:
        return 'Support';
      case AppPermission.adminReview:
        return 'Admin Review';
      case AppPermission.ownerControl:
        return 'Owner Control';
    }
  }
}
