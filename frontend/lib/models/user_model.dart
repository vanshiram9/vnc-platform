// ============================================================
// VNC PLATFORM — USER MODEL (FRONTEND)
// File: lib/models/user_model.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import '../core/role.types.dart';
import '../core/user.states.dart';

/// UserModel
/// ---------
/// Immutable frontend representation of authenticated user.
/// IMPORTANT:
/// - Backend is the single source of truth
/// - This model NEVER decides access or permissions
class UserModel {
  final String id;
  final String identifier; // email / mobile / username
  final UserRole role;
  final UserState state;
  final String countryCode;

  const UserModel({
    required this.id,
    required this.identifier,
    required this.role,
    required this.state,
    required this.countryCode,
  });

  /* ---------------------------------------------------------- */
  /* FACTORY                                                    */
  /* ---------------------------------------------------------- */

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final String id = json['id']?.toString() ?? '';
    final String identifier =
        json['identifier']?.toString() ?? '';

    final String roleRaw =
        json['role']?.toString() ?? 'USER';
    final String stateRaw =
        json['state']?.toString() ?? 'UNKNOWN';

    final String country =
        json['country']?.toString() ?? 'XX';

    return UserModel(
      id: id,
      identifier: identifier,
      role: parseUserRole(roleRaw),
      state: parseUserState(stateRaw),
      countryCode: country,
    );
  }

  /* ---------------------------------------------------------- */
  /* HELPERS                                                    */
  /* ---------------------------------------------------------- */

  bool get isActive => state == UserState.active;
  bool get isBlocked => state == UserState.blocked;

  bool get isAdmin => role == UserRole.admin;
  bool get isOwner => role == UserRole.owner;
}
