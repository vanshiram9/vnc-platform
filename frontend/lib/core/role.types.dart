// ============================================================
// VNC PLATFORM — ROLE TYPES (UI ONLY)
// File: lib/core/role.types.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/// User roles as declared by backend.
/// IMPORTANT:
/// - This enum is for UI hints only.
/// - Backend Zero-Trust is the final authority.
/// - Do NOT implement permission logic based on this alone.
enum UserRole {
  guest,
  user,
  merchant,
  admin,
  owner,
}

/// Parse backend role string into [UserRole].
/// Unknown roles are mapped to [UserRole.guest] (fail-safe).
UserRole parseUserRole(String? value) {
  switch (value) {
    case 'USER':
      return UserRole.user;
    case 'MERCHANT':
      return UserRole.merchant;
    case 'ADMIN':
      return UserRole.admin;
    case 'OWNER':
      return UserRole.owner;
    default:
      return UserRole.guest;
  }
}

/// Convert [UserRole] to backend wire value.
/// Used only when sending hints/logs (never for authority).
String roleToWire(UserRole role) {
  switch (role) {
    case UserRole.user:
      return 'USER';
    case UserRole.merchant:
      return 'MERCHANT';
    case UserRole.admin:
      return 'ADMIN';
    case UserRole.owner:
      return 'OWNER';
    case UserRole.guest:
    default:
      return 'GUEST';
  }
}

/// Utility helpers (UI convenience only)
extension UserRoleX on UserRole {
  bool get isAuthenticated =>
      this != UserRole.guest;

  bool get canSeeAdminUI =>
      this == UserRole.admin || this == UserRole.owner;

  bool get canSeeOwnerUI =>
      this == UserRole.owner;
}
