// ============================================================
// VNC PLATFORM — IMPORT / EXPORT SERVICE (FRONTEND)
// File: lib/services/import_export_service.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'api_client.dart';

/// ImportExportService
/// -------------------
/// Frontend IE (Import/Export) API bridge.
/// IMPORTANT:
/// - Contracts, LC, escrow, compliance enforced by backend
/// - Frontend only submits intents & renders state
class ImportExportService {
  final ApiClient _api;

  ImportExportService(this._api);

  /* ---------------------------------------------------------- */
  /* DASHBOARD                                                  */
  /* ---------------------------------------------------------- */

  /// Fetch IE dashboard snapshot
  ///
  /// Example backend response:
  /// {
  ///   "activeContracts": 3,
  ///   "pendingCompliance": 1
  /// }
  Future<Map<String, dynamic>> getDashboard() async {
    final res = await _api.get('/import-export');
    if (res.isEmpty) {
      throw StateError('IE_DASHBOARD_EMPTY');
    }
    return res;
  }

  /* ---------------------------------------------------------- */
  /* CONTRACTS                                                  */
  /* ---------------------------------------------------------- */

  /// Create new import/export contract
  Future<void> createContract({
    required Map<String, dynamic> payload,
  }) async {
    await _api.post(
      '/import-export/contract',
      data: payload,
    );
  }

  /// Fetch contracts list
  Future<List<dynamic>> getContracts() async {
    final res = await _api.get('/import-export/contracts');
    final list = res['contracts'];
    if (list is List) {
      return list;
    }
    throw StateError('IE_CONTRACTS_INVALID');
  }

  /* ---------------------------------------------------------- */
  /* ESCROW / COMPLIANCE                                        */
  /* ---------------------------------------------------------- */

  /// Fetch escrow status for a contract
  Future<Map<String, dynamic>> getEscrowStatus({
    required String contractId,
  }) async {
    final res = await _api.get(
      '/import-export/escrow',
      query: {'id': contractId},
    );
    if (res.isEmpty) {
      throw StateError('IE_ESCROW_EMPTY');
    }
    return res;
  }

  /// Fetch compliance status
  Future<Map<String, dynamic>> getCompliance() async {
    final res = await _api.get('/import-export/compliance');
    if (res.isEmpty) {
      throw StateError('IE_COMPLIANCE_EMPTY');
    }
    return res;
  }
}
