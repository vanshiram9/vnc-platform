// ============================================================
// VNC PLATFORM — AUTH STATE (FRONTEND)
// File: lib/state/auth_state.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/foundation.dart';

/// AuthState
/// ---------
/// Frontend session state.
/// IMPORTANT:
/// - Backend decides authentication validity
/// - Frontend only reflects session presence
class AuthState extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  /* ---------------------------------------------------------- */
  /* SESSION CONTROL                                            */
  /* ---------------------------------------------------------- */

  /// Called after successful login / OTP verification
  void markAuthenticated() {
    if (_isAuthenticated) return;
    _isAuthenticated = true;
    notifyListeners();
  }

  /// Called on logout or backend invalidation
  void markLoggedOut() {
    if (!_isAuthenticated) return;
    _isAuthenticated = false;
    notifyListeners();
  }
}
