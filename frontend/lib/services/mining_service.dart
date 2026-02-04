// ============================================================
// VNC PLATFORM — MINING SERVICE (FRONTEND)
// File: lib/services/mining_service.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'api_client.dart';

/// MiningService
/// -------------
/// Frontend mining API bridge.
/// IMPORTANT:
/// - Mining rules, rates, anti-abuse handled by backend
/// - Frontend only triggers actions & displays data
class MiningService {
  final ApiClient _api;

  MiningService(this._api);

  /* ---------------------------------------------------------- */
  /* SNAPSHOT                                                   */
  /* ---------------------------------------------------------- */

  /// Fetch current mining state
  ///
  /// Example backend response:
  /// {
  ///   "rate": 1.5,
  ///   "boostActive": false,
  ///   "minedToday": 12.3
  /// }
  Future<Map<String, dynamic>> getStatus() async {
    final res = await _api.get('/mining');
    if (res.isEmpty) {
      throw StateError('MINING_EMPTY');
    }
    return res;
  }

  /* ---------------------------------------------------------- */
  /* ACTIONS                                                    */
  /* ---------------------------------------------------------- */

  /// Start mining session
  Future<void> start() async {
    await _api.post('/mining/start');
  }

  /// Stop mining session
  Future<void> stop() async {
    await _api.post('/mining/stop');
  }

  /// Activate mining boost
  Future<void> activateBoost() async {
    await _api.post('/mining/boost');
  }

  /* ---------------------------------------------------------- */
  /* HISTORY / REFERRAL                                         */
  /* ---------------------------------------------------------- */

  /// Fetch mining history
  Future<List<dynamic>> getHistory() async {
    final res = await _api.get('/mining/history');
    final list = res['history'];
    if (list is List) {
      return list;
    }
    throw StateError('MINING_HISTORY_INVALID');
  }

  /// Fetch referral summary
  Future<Map<String, dynamic>> getReferral() async {
    return _api.get('/mining/referral');
  }
}
