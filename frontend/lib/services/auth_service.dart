// ============================================================
// VNC PLATFORM — AUTH SERVICE (FRONTEND)
// File: lib/services/auth_service.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'api_client.dart';

/// AuthService
/// -----------
/// Frontend authentication service.
/// IMPORTANT:
/// - Backend decides EVERYTHING
/// - Frontend only forwards data & stores token
/// - No validation, no assumptions
class AuthService {
  final ApiClient _api;

  AuthService(this._api);

  /* ---------------------------------------------------------- */
  /* LOGIN / OTP                                                */
  /* ---------------------------------------------------------- */

  /// Start login (mobile/email/etc decided by backend)
  Future<void> startLogin({
    required String identifier,
  }) async {
    await _api.post(
      '/auth/login',
      data: {
        'identifier': identifier,
      },
    );
  }

  /// Verify OTP and receive token
  Future<void> verifyOtp({
    required String identifier,
    required String otp,
  }) async {
    final res = await _api.post(
      '/auth/verify',
      data: {
        'identifier': identifier,
        'otp': otp,
      },
    );

    final String? token = res['token'] as String?;
    if (token == null || token.isEmpty) {
      throw StateError('TOKEN_MISSING');
    }

    await ApiClient.saveToken(token);
  }

  /* ---------------------------------------------------------- */
  /* SESSION                                                    */
  /* ---------------------------------------------------------- */

  /// Logout (local + backend signal)
  Future<void> logout() async {
    try {
      await _api.post('/auth/logout');
    } finally {
      await ApiClient.clearToken();
    }
  }
}
