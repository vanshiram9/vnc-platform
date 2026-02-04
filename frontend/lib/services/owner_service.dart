// ============================================================
// VNC PLATFORM — OWNER SERVICE (FRONTEND)
// File: lib/services/owner_service.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'api_client.dart';

/// OwnerService
/// ------------
/// Frontend owner-level API bridge.
/// IMPORTANT:
/// - OWNER power is EXTREMELY sensitive
/// - Frontend only forwards intent
/// - Backend validates identity, role, quorum, audit
class OwnerService {
  final ApiClient _api;

  OwnerService(this._api);

  /* ---------------------------------------------------------- */
  /* DASHBOARD                                                  */
  /* ---------------------------------------------------------- */

  /// Fetch owner system dashboard
  ///
  /// Example backend response:
  /// {
  ///   "systemStatus": "NORMAL | DEGRADED | EMERGENCY",
  ///   "killSwitch": false
  /// }
  Future<Map<String, dynamic>> getDashboard() async {
    final res = await _api.get('/owner');
    if (res.isEmpty) {
      throw StateError('OWNER_DASHBOARD_EMPTY');
    }
    return res;
  }

  /* ---------------------------------------------------------- */
  /* FEATURE FLAGS                                              */
  /* ---------------------------------------------------------- */

  /// Fetch current feature flags (read-only view)
  Future<Map<String, dynamic>> getFeatureFlags() async {
    final res = await _api.get('/owner/features');
    if (res.isEmpty) {
      throw StateError('OWNER_FEATURES_EMPTY');
    }
    return res;
  }

  /// Toggle a feature (intent only)
  Future<void> toggleFeature({
    required String feature, // AUTH / WALLET / TRADE etc
    required bool enabled,
  }) async {
    await _api.post(
      '/owner/features/toggle',
      data: {
        'feature': feature,
        'enabled': enabled,
      },
    );
  }

  /* ---------------------------------------------------------- */
  /* COUNTRY RULES                                              */
  /* ---------------------------------------------------------- */

  /// Fetch country rules (read-only)
  Future<List<dynamic>> getCountryRules() async {
    final res = await _api.get('/owner/countries');
    final list = res['countries'];
    if (list is List) {
      return list;
    }
    throw StateError('OWNER_COUNTRIES_INVALID');
  }

  /// Update country rule (intent only)
  Future<void> updateCountryRule({
    required String country,
    required bool allowed,
  }) async {
    await _api.post(
      '/owner/country/update',
      data: {
        'country': country,
        'allowed': allowed,
      },
    );
  }

  /* ---------------------------------------------------------- */
  /* SYSTEM CONTROL                                             */
  /* ---------------------------------------------------------- */

  /// Fetch system control snapshot
  Future<Map<String, dynamic>> getSystemControl() async {
    final res = await _api.get('/owner/system');
    if (res.isEmpty) {
      throw StateError('OWNER_SYSTEM_EMPTY');
    }
    return res;
  }

  /// Activate / deactivate emergency kill switch
  ///
  /// NOTE:
  /// - Backend enforces multi-step auth & audit
  Future<void> setKillSwitch({
    required bool active,
  }) async {
    await _api.post(
      '/owner/kill-switch',
      data: {
        'active': active,
      },
    );
  }
}
