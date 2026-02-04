// ============================================================
// VNC PLATFORM — USER STATE (FRONTEND)
// File: lib/state/user_state.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../core/role.types.dart';
import '../core/user.states.dart';

/// UserState
/// ---------
/// Frontend holder for current user snapshot.
/// IMPORTANT:
/// - Backend is the single source of truth
/// - State is READ-ONLY mirror
class UserState extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  UserRole get role => _user?.role ?? UserRole.guest;
  UserStateEnum get state =>
      _user?.state ?? UserStateEnum.unknown;

  String get countryCode =>
      _user?.countryCode ?? 'XX';

  bool get isLoggedIn => _user != null;

  /* ---------------------------------------------------------- */
  /* UPDATE                                                     */
  /* ---------------------------------------------------------- */

  /// Update user snapshot after profile fetch
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  /// Clear user on logout / invalidation
  void clear() {
    _user = null;
    notifyListeners();
  }
}
