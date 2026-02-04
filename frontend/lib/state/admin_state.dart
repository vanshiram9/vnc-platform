// ============================================================
// VNC PLATFORM — ADMIN STATE (FRONTEND)
// File: lib/state/admin_state.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/foundation.dart';

/// AdminDashboardSnapshot
/// ----------------------
/// Lightweight admin dashboard snapshot.
/// IMPORTANT:
/// - Admin powers enforced by backend only
/// - Frontend shows read-only metrics
class AdminDashboardSnapshot {
  final int users;
  final int wallets;
  final int trades;
  final DateTime timestamp;

  const AdminDashboardSnapshot({
    required this.users,
    required this.wallets,
    required this.trades,
    required this.timestamp,
  });

  factory AdminDashboardSnapshot.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminDashboardSnapshot(
      users: json['users'] is int ? json['users'] as int : 0,
      wallets:
          json['wallets'] is int ? json['wallets'] as int : 0,
      trades:
          json['trades'] is int ? json['trades'] as int : 0,
      timestamp: DateTime.tryParse(
            json['timestamp']?.toString() ?? '',
          ) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}

/// AdminState
/// ----------
/// Frontend holder for admin dashboard snapshot.
/// IMPORTANT:
/// - No admin decisions here
/// - Backend is single source of truth
class AdminState extends ChangeNotifier {
  AdminDashboardSnapshot? _snapshot;

  AdminDashboardSnapshot? get snapshot => _snapshot;

  bool get hasData => _snapshot != null;

  /* ---------------------------------------------------------- */
  /* UPDATE                                                     */
  /* ---------------------------------------------------------- */

  /// Update admin dashboard snapshot
  void setSnapshot(AdminDashboardSnapshot snapshot) {
    _snapshot = snapshot;
    notifyListeners();
  }

  /// Clear admin state on logout / reset
  void clear() {
    _snapshot = null;
    notifyListeners();
  }
}
