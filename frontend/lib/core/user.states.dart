// ============================================================
// VNC PLATFORM — USER STATES (UI ONLY)
// File: lib/core/user.states.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/// User lifecycle states as reported by backend.
/// IMPORTANT:
/// - UI hint only
/// - Backend Zero-Trust is final authority
/// - Never enforce permissions using this alone
enum UserState {
  unknown,
  active,
  blocked,
  frozen,
  pendingKyc,
  rejectedKyc,
}

/// Parse backend wire value to [UserState].
/// Unknown / missing values fall back to [UserState.unknown].
UserState parseUserState(String? value) {
  switch (value) {
    case 'ACTIVE':
      return UserState.active;
    case 'BLOCKED':
      return UserState.blocked;
    case 'FROZEN':
      return UserState.frozen;
    case 'PENDING_KYC':
      return UserState.pendingKyc;
    case 'REJECTED_KYC':
      return UserState.rejectedKyc;
    default:
      return UserState.unknown;
  }
}

/// Convert [UserState] to backend wire value.
/// Used only for logs / diagnostics (not authority).
String userStateToWire(UserState state) {
  switch (state) {
    case UserState.active:
      return 'ACTIVE';
    case UserState.blocked:
      return 'BLOCKED';
    case UserState.frozen:
      return 'FROZEN';
    case UserState.pendingKyc:
      return 'PENDING_KYC';
    case UserState.rejectedKyc:
      return 'REJECTED_KYC';
    case UserState.unknown:
    default:
      return 'UNKNOWN';
  }
}

/// UI convenience helpers (NO authority)
extension UserStateX on UserState {
  bool get isBlocked =>
      this == UserState.blocked || this == UserState.frozen;

  bool get requiresKyc =>
      this == UserState.pendingKyc ||
      this == UserState.rejectedKyc;

  bool get canAccessApp =>
      this == UserState.active;
}
