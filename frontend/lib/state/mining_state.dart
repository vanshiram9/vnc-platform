// ============================================================
// VNC PLATFORM — MINING STATE (FRONTEND)
// File: lib/state/mining_state.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/foundation.dart';

import '../models/mining_model.dart';

/// MiningState
/// -----------
/// Frontend holder for mining snapshot.
/// IMPORTANT:
/// - Mining rules & rewards enforced by backend
/// - State is read-only mirror
class MiningState extends ChangeNotifier {
  MiningModel? _mining;

  MiningModel? get mining => _mining;

  bool get hasMining => _mining != null;

  bool get boostActive => _mining?.boostActive ?? false;

  num get rate => _mining?.rate ?? 0;
  num get minedToday => _mining?.minedToday ?? 0;
  num get totalMined => _mining?.totalMined ?? 0;

  /* ---------------------------------------------------------- */
  /* UPDATE                                                     */
  /* ---------------------------------------------------------- */

  /// Update mining snapshot after fetch
  void setMining(MiningModel mining) {
    _mining = mining;
    notifyListeners();
  }

  /// Clear mining state on logout / reset
  void clear() {
    _mining = null;
    notifyListeners();
  }
}
