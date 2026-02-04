// ============================================================
// VNC PLATFORM — WALLET MODEL (FRONTEND)
// File: lib/models/wallet_model.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/// WalletModel
/// -----------
/// Immutable frontend representation of wallet state.
/// IMPORTANT:
/// - Backend is the single source of truth
/// - No calculations or enforcement on client
class WalletModel {
  final num balance;
  final num lockedBalance;
  final bool frozen;

  const WalletModel({
    required this.balance,
    required this.lockedBalance,
    required this.frozen,
  });

  /* ---------------------------------------------------------- */
  /* FACTORY                                                    */
  /* ---------------------------------------------------------- */

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final num balance =
        json['balance'] is num ? json['balance'] as num : 0;

    final num locked =
        json['lockedBalance'] is num
            ? json['lockedBalance'] as num
            : 0;

    final bool frozen =
        json['frozen'] == true;

    return WalletModel(
      balance: balance,
      lockedBalance: locked,
      frozen: frozen,
    );
  }

  /* ---------------------------------------------------------- */
  /* DERIVED (UI ONLY)                                          */
  /* ---------------------------------------------------------- */

  num get availableBalance => balance;
}
