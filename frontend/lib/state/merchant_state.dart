// ============================================================
// VNC PLATFORM — MERCHANT STATE (FRONTEND)
// File: lib/state/merchant_state.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/foundation.dart';

import '../models/merchant_model.dart';

/// MerchantState
/// -------------
/// Frontend holder for merchant dashboard snapshot.
/// IMPORTANT:
/// - Settlement, limits, KYC enforced by backend
/// - State is read-only mirror
class MerchantState extends ChangeNotifier {
  MerchantModel? _merchant;

  MerchantModel? get merchant => _merchant;

  bool get hasMerchant => _merchant != null;

  bool get isActive => _merchant?.isActive ?? false;

  num get totalSales => _merchant?.totalSales ?? 0;
  num get pendingSettlement =>
      _merchant?.pendingSettlement ?? 0;

  /* ---------------------------------------------------------- */
  /* UPDATE                                                     */
  /* ---------------------------------------------------------- */

  /// Update merchant snapshot after fetch
  void setMerchant(MerchantModel merchant) {
    _merchant = merchant;
    notifyListeners();
  }

  /// Clear merchant state on logout / reset
  void clear() {
    _merchant = null;
    notifyListeners();
  }
}
