// ============================================================
// VNC PLATFORM — MERCHANT SERVICE (FRONTEND)
// File: lib/services/merchant_service.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'api_client.dart';

/// MerchantService
/// ----------------
/// Frontend merchant API bridge.
/// IMPORTANT:
/// - Payments, settlements, limits handled by backend
/// - Frontend only sends intents & displays results
class MerchantService {
  final ApiClient _api;

  MerchantService(this._api);

  /* ---------------------------------------------------------- */
  /* DASHBOARD                                                  */
  /* ---------------------------------------------------------- */

  /// Fetch merchant dashboard snapshot
  ///
  /// Example backend response:
  /// {
  ///   "totalSales": 12000,
  ///   "pendingSettlement": 340,
  ///   "status": "ACTIVE"
  /// }
  Future<Map<String, dynamic>> getDashboard() async {
    final res = await _api.get('/merchant');
    if (res.isEmpty) {
      throw StateError('MERCHANT_DASHBOARD_EMPTY');
    }
    return res;
  }

  /* ---------------------------------------------------------- */
  /* QR PAYMENT                                                 */
  /* ---------------------------------------------------------- */

  /// Generate merchant QR payload
  Future<Map<String, dynamic>> generateQr() async {
    final res = await _api.get('/merchant/qr');
    if (res.isEmpty) {
      throw StateError('MERCHANT_QR_EMPTY');
    }
    return res;
  }

  /* ---------------------------------------------------------- */
  /* SETTLEMENT                                                 */
  /* ---------------------------------------------------------- */

  /// Fetch settlement history
  Future<List<dynamic>> getSettlements() async {
    final res = await _api.get('/merchant/settlements');
    final list = res['settlements'];
    if (list is List) {
      return list;
    }
    throw StateError('SETTLEMENTS_INVALID');
  }

  /* ---------------------------------------------------------- */
  /* KYC                                                       */
  /* ---------------------------------------------------------- */

  /// Fetch merchant KYC status
  Future<Map<String, dynamic>> getKycStatus() async {
    final res = await _api.get('/merchant/kyc');
    if (res.isEmpty) {
      throw StateError('MERCHANT_KYC_EMPTY');
    }
    return res;
  }
}
