// ============================================================
// VNC PLATFORM — TRADE SERVICE (FRONTEND)
// File: lib/services/trade_service.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'api_client.dart';

/// TradeService
/// ------------
/// Frontend trade API bridge.
/// IMPORTANT:
/// - Pricing, escrow, settlement handled by backend
/// - Frontend never calculates or assumes outcomes
class TradeService {
  final ApiClient _api;

  TradeService(this._api);

  /* ---------------------------------------------------------- */
  /* CREATE TRADE                                               */
  /* ---------------------------------------------------------- */

  /// Create buy or sell order
  ///
  /// Payload example:
  /// {
  ///   "type": "BUY" | "SELL",
  ///   "asset": "VNC",
  ///   "amount": 10,
  ///   "price": 25
  /// }
  Future<void> createTrade({
    required String type,
    required String asset,
    required num amount,
    required num price,
  }) async {
    await _api.post(
      '/trade',
      data: {
        'type': type,
        'asset': asset,
        'amount': amount,
        'price': price,
      },
    );
  }

  /* ---------------------------------------------------------- */
  /* ORDERS                                                     */
  /* ---------------------------------------------------------- */

  /// Fetch user's trade history
  Future<List<dynamic>> getOrders() async {
    final res = await _api.get('/trade/history');
    final list = res['orders'];
    if (list is List) {
      return list;
    }
    throw StateError('TRADE_HISTORY_INVALID');
  }

  /* ---------------------------------------------------------- */
  /* ESCROW                                                     */
  /* ---------------------------------------------------------- */

  /// Fetch escrow / settlement status
  Future<Map<String, dynamic>> getEscrowStatus({
    required String tradeId,
  }) async {
    final res = await _api.get(
      '/trade/escrow',
      query: {'id': tradeId},
    );
    if (res.isEmpty) {
      throw StateError('ESCROW_EMPTY');
    }
    return res;
  }
}
