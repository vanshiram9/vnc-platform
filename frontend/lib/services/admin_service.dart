// ============================================================
// VNC PLATFORM — ADMIN SERVICE (FRONTEND)
// File: lib/services/admin_service.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'api_client.dart';

/// AdminService
/// ------------
/// Frontend admin API bridge.
/// IMPORTANT:
/// - Admin authority & validation handled by backend
/// - Frontend only triggers admin intents & displays data
class AdminService {
  final ApiClient _api;

  AdminService(this._api);

  /* ---------------------------------------------------------- */
  /* DASHBOARD                                                  */
  /* ---------------------------------------------------------- */

  /// Fetch admin dashboard snapshot
  ///
  /// Example backend response:
  /// {
  ///   "users": 1200,
  ///   "trades": 340,
  ///   "alerts": 2
  /// }
  Future<Map<String, dynamic>> getDashboard() async {
    final res = await _api.get('/admin');
    if (res.isEmpty) {
      throw StateError('ADMIN_DASHBOARD_EMPTY');
    }
    return res;
  }

  /* ---------------------------------------------------------- */
  /* USER MODERATION                                            */
  /* ---------------------------------------------------------- */

  /// Fetch users list (admin visibility)
  Future<List<dynamic>> getUsers() async {
    final res = await _api.get('/admin/users');
    final list = res['users'];
    if (list is List) {
      return list;
    }
    throw StateError('ADMIN_USERS_INVALID');
  }

  /// Freeze / unfreeze a user
  Future<void> setUserFreeze({
    required String userId,
    required bool freeze,
  }) async {
    await _api.post(
      '/admin/user/freeze',
      data: {
        'userId': userId,
        'freeze': freeze,
      },
    );
  }

  /* ---------------------------------------------------------- */
  /* KYC REVIEW                                                 */
  /* ---------------------------------------------------------- */

  /// Fetch pending KYC applications
  Future<List<dynamic>> getPendingKyc() async {
    final res = await _api.get('/admin/kyc/pending');
    final list = res['kyc'];
    if (list is List) {
      return list;
    }
    throw StateError('ADMIN_KYC_INVALID');
  }

  /// Review KYC
  Future<void> reviewKyc({
    required String kycId,
    required String decision, // APPROVE | REJECT
  }) async {
    await _api.post(
      '/admin/kyc/review',
      data: {
        'kycId': kycId,
        'decision': decision,
      },
    );
  }

  /* ---------------------------------------------------------- */
  /* TRANSACTIONS / AUDIT                                       */
  /* ---------------------------------------------------------- */

  /// Fetch recent transactions
  Future<List<dynamic>> getTransactions() async {
    final res = await _api.get('/admin/transactions');
    final list = res['transactions'];
    if (list is List) {
      return list;
    }
    throw StateError('ADMIN_TRANSACTIONS_INVALID');
  }

  /// Fetch audit logs
  Future<List<dynamic>> getAuditLogs() async {
    final res = await _api.get('/admin/audit');
    final list = res['logs'];
    if (list is List) {
      return list;
    }
    throw StateError('ADMIN_AUDIT_INVALID');
  }

  /* ---------------------------------------------------------- */
  /* FRAUD ALERTS                                               */
  /* ---------------------------------------------------------- */

  /// Fetch fraud alerts
  Future<List<dynamic>> getFraudAlerts() async {
    final res = await _api.get('/admin/fraud');
    final list = res['alerts'];
    if (list is List) {
      return list;
    }
    throw StateError('ADMIN_FRAUD_INVALID');
  }
}
