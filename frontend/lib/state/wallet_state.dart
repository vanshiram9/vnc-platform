// ============================================================
// VNC PLATFORM — WALLET STATE (FRONTEND)
// File: lib/state/wallet_state.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/foundation.dart';

import '../models/wallet_model.dart';

/// WalletState
/// -----------
/// Frontend holder for wallet snapshot.
/// IMPORTANT:
/// - Backend is single source of truth
/// - State is read-only mirror
class WalletState extends ChangeNotifier {
  WalletModel? _wallet;

  WalletModel? get wallet => _wallet;

  bool get hasWallet => _wallet != null;

  bool get isFrozen => _wallet?.frozen ?? false;

  num get balance => _wallet?.balance ?? 0;
  num get lockedBalance => _wallet?.lockedBalance ?? 0;

  /* ---------------------------------------------------------- */
  /* UPDATE                                                     */
  /* ---------------------------------------------------------- */

  /// Update wallet snapshot after fetch
  void setWallet(WalletModel wallet) {
    _wallet = wallet;
    notifyListeners();
  }

  /// Clear wallet on logout / reset
  void clear() {
    _wallet = null;
    notifyListeners();
  }
}
