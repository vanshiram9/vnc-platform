// ============================================================
// VNC PLATFORM — OWNER STATE (FRONTEND)
// File: lib/state/owner_state.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/foundation.dart';

/// OwnerSystemSnapshot
/// -------------------
/// Read-only snapshot of system-wide owner view.
/// IMPORTANT:
/// - Owner powers enforced ONLY on backend
/// - Frontend only displays status
class OwnerSystemSnapshot {
  final String systemStatus; // NORMAL | DEGRADED | EMERGENCY
  final bool killSwitchActive;
  final DateTime timestamp;

  const OwnerSystemSnapshot({
    required this.systemStatus,
    required this.killSwitchActive,
    required this.timestamp,
  });

  factory OwnerSystemSnapshot.fromJson(
    Map<String, dynamic> json,
  ) {
    return OwnerSystemSnapshot(
      systemStatus:
          json['systemStatus']?.toString() ?? 'UNKNOWN',
      killSwitchActive:
          json['killSwitch'] == true,
      timestamp: DateTime.tryParse(
            json['timestamp']?.toString() ?? '',
          ) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}

/// OwnerState
/// ----------
/// Frontend holder for owner system snapshot.
/// IMPORTANT:
/// - No kill-switch logic
/// - No feature enforcement
/// - Backend is single authority
class OwnerState extends ChangeNotifier {
  OwnerSystemSnapshot? _snapshot;

  OwnerSystemSnapshot? get snapshot => _snapshot;

  bool get hasData => _snapshot != null;

  bool get isKillSwitchActive =>
      _snapshot?.killSwitchActive ?? false;

  /* ---------------------------------------------------------- */
  /* UPDATE                                                     */
  /* ---------------------------------------------------------- */

  /// Update owner snapshot after fetch
  void setSnapshot(OwnerSystemSnapshot snapshot) {
    _snapshot = snapshot;
    notifyListeners();
  }

  /// Clear owner state on logout / reset
  void clear() {
    _snapshot = null;
    notifyListeners();
  }
}
