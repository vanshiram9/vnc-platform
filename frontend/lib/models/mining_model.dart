// ============================================================
// VNC PLATFORM — MINING MODEL (FRONTEND)
// File: lib/models/mining_model.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/// MiningModel
/// -----------
/// Immutable frontend representation of mining state.
/// IMPORTANT:
/// - Mining rules, rates, caps enforced by backend
/// - Frontend only displays snapshot
class MiningModel {
  final num rate; // coins per hour / unit
  final bool boostActive;
  final num minedToday;
  final num totalMined;

  const MiningModel({
    required this.rate,
    required this.boostActive,
    required this.minedToday,
    required this.totalMined,
  });

  /* ---------------------------------------------------------- */
  /* FACTORY                                                    */
  /* ---------------------------------------------------------- */

  factory MiningModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final num rate =
        json['rate'] is num ? json['rate'] as num : 0;

    final bool boostActive =
        json['boostActive'] == true;

    final num minedToday =
        json['minedToday'] is num
            ? json['minedToday'] as num
            : 0;

    final num totalMined =
        json['totalMined'] is num
            ? json['totalMined'] as num
            : 0;

    return MiningModel(
      rate: rate,
      boostActive: boostActive,
      minedToday: minedToday,
      totalMined: totalMined,
    );
  }
}
