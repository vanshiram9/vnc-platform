// ============================================================
// VNC PLATFORM — MERCHANT MODEL (FRONTEND)
// File: lib/models/merchant_model.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/// MerchantModel
/// -------------
/// Immutable frontend representation of merchant state.
/// IMPORTANT:
/// - Settlement, limits, risk enforced by backend
/// - Frontend only displays snapshot data
class MerchantModel {
  final String id;
  final String status; // ACTIVE | SUSPENDED | PENDING
  final num totalSales;
  final num pendingSettlement;
  final bool kycApproved;

  const MerchantModel({
    required this.id,
    required this.status,
    required this.totalSales,
    required this.pendingSettlement,
    required this.kycApproved,
  });

  /* ---------------------------------------------------------- */
  /* FACTORY                                                    */
  /* ---------------------------------------------------------- */

  factory MerchantModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final String id =
        json['id']?.toString() ?? '';

    final String status =
        json['status']?.toString() ?? 'UNKNOWN';

    final num totalSales =
        json['totalSales'] is num
            ? json['totalSales'] as num
            : 0;

    final num pendingSettlement =
        json['pendingSettlement'] is num
            ? json['pendingSettlement'] as num
            : 0;

    final bool kycApproved =
        json['kycApproved'] == true;

    return MerchantModel(
      id: id,
      status: status,
      totalSales: totalSales,
      pendingSettlement: pendingSettlement,
      kycApproved: kycApproved,
    );
  }

  /* ---------------------------------------------------------- */
  /* UI HELPERS (NO AUTHORITY)                                  */
  /* ---------------------------------------------------------- */

  bool get isActive => status == 'ACTIVE';
}
