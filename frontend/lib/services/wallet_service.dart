// ============================================================
// VNC PLATFORM — WALLET SERVICE (FRONTEND)
// File: lib/services/wallet_service.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'api_client.dart';

/// WalletService
/// -------------
/// Frontend wallet API bridge.
/// IMPORTANT:
/// - Backend enforces balances, locks, limits
/// - Frontend only forwards requests
/// - No client-side math or assumptions
class WalletService {
  final ApiClient _api;

  WalletService(this._api);

  /* ---------------------------------------------------------- */
  /* WALLET                                                     */
  /* ---------------------------------------------------------- */

  /// Fetch current wallet snapshot
  ///
  /// Expected backend response example:
  /// {
  ///   "balance": 1000,
  ///   "lockedBalance": 200,
  ///   "frozen": false
  /// }
  Future<Map<String, dynamic>> getWallet() async {
    final res = await _api.get('/wallet');
    if (res.isEmpty) {
      throw StateError('WALLET_EMPTY');
    }
    return res;
  }

  /* ---------------------------------------------------------- */
  /* LEDGER                                                     */
  /* ---------------------------------------------------------- */

  /// Fetch wallet ledger entries
  Future<List<dynamic>> getLedger() async {
    final res = await _api.get('/wallet/ledger');

    final entries = res['entries'];
    if (entries is List) {
      return entries;
    }
    throw StateError('LEDGER_INVALID');
  }

  /* ---------------------------------------------------------- */
  /* ACTIONS                                                    */
  /* ---------------------------------------------------------- */

  /// Lock coins (staking / escrow)
  Future<void> lockCoins({
    required num amount,
  }) async {
    await _api.post(
      '/wallet/lock',
      data: {
        'amount': amount,
      },
    );
  }

  /// Withdraw coins
  Future<void> withdraw({
    required num amount,
  }) async {
    await _api.post(
      '/wallet/withdraw',
      data: {
        'amount': amount,
      },
    );
  }
}
