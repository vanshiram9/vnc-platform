// ============================================================
// VNC PLATFORM — USER SERVICE (FRONTEND)
// File: lib/services/user_service.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'api_client.dart';

/// UserService
/// -----------
/// Frontend read-only user profile service.
/// IMPORTANT:
/// - Backend is the single source of truth
/// - No client-side role/state decisions
/// - Pure data fetch + parse
class UserService {
  final ApiClient _api;

  UserService(this._api);

  /* ---------------------------------------------------------- */
  /* PROFILE                                                    */
  /* ---------------------------------------------------------- */

  /// Fetch current authenticated user profile
  ///
  /// Expected backend response (example):
  /// {
  ///   "id": "uuid",
  ///   "identifier": "user@x.com",
  ///   "role": "USER | ADMIN | OWNER",
  ///   "state": "ACTIVE | BLOCKED",
  ///   "country": "IN"
  /// }
  Future<Map<String, dynamic>> getProfile() async {
    final res = await _api.get('/users/me');

    if (res.isEmpty) {
      throw StateError('USER_PROFILE_EMPTY');
    }

    return res;
  }

  /* ---------------------------------------------------------- */
  /* DEVICE / SESSION                                           */
  /* ---------------------------------------------------------- */

  /// Ask backend to re-check device trust
  /// (backend may respond with BLOCK / VERIFY / OK)
  Future<Map<String, dynamic>> verifyDevice() async {
    return _api.post('/users/device/verify');
  }
}
