// ============================================================
// VNC PLATFORM — TRADE STATE (FRONTEND)
// File: lib/state/trade_state.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/foundation.dart';

import '../models/trade_model.dart';

/// TradeState
/// ----------
/// Frontend holder for trade / order snapshots.
/// IMPORTANT:
/// - Trade execution & settlement handled by backend
/// - State is read-only mirror
class TradeState extends ChangeNotifier {
  List<TradeModel> _orders = [];

  List<TradeModel> get orders => List.unmodifiable(_orders);

  bool get hasOrders => _orders.isNotEmpty;

  /* ---------------------------------------------------------- */
  /* UPDATE                                                     */
  /* ---------------------------------------------------------- */

  /// Replace full trade history snapshot
  void setOrders(List<TradeModel> orders) {
    _orders = List.unmodifiable(orders);
    notifyListeners();
  }

  /// Clear trades on logout / reset
  void clear() {
    _orders = [];
    notifyListeners();
  }
}
