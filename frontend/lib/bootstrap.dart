// ============================================================
// VNC PLATFORM — FRONTEND BOOTSTRAP
// File: lib/bootstrap.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'dart:async';

import 'services/api_client.dart';
import 'env/env.base.dart';

/// Result of bootstrap decision
class BootstrapResult {
  final bool allowed;
  final String? reason;

  const BootstrapResult({
    required this.allowed,
    this.reason,
  });
}

/// AppBootstrap
/// -------------
/// - Runs BEFORE app UI starts
/// - Contacts backend for:
///   • version check
///   • maintenance status
///   • hard block
/// - Frontend NEVER overrides backend decision
class AppBootstrap {
  static Future<BootstrapResult> run({
    required String appVersion,
    required String buildNumber,
    required EnvBase env,
  }) async {
    try {
      final ApiClient api = ApiClient(
        baseUrl: env.apiBaseUrl,
        appVersion: appVersion,
      );

      final Map<String, dynamic> res =
          await api.get('/system/bootstrap');

      /*
        Expected backend response (example):

        {
          "allowed": true,
          "maintenance": false,
          "minVersion": "6.7.0.4",
          "reason": null
        }
      */

      final bool allowed = res['allowed'] == true;
      final bool maintenance = res['maintenance'] == true;
      final String? minVersion = res['minVersion'] as String?;
      final String? reason = res['reason'] as String?;

      // ------------------------------
      // HARD BLOCK CONDITIONS
      // ------------------------------

      if (!allowed) {
        return BootstrapResult(
          allowed: false,
          reason: reason ?? 'ACCESS_DENIED',
        );
      }

      if (maintenance) {
        return const BootstrapResult(
          allowed: false,
          reason: 'SYSTEM_MAINTENANCE',
        );
      }

      if (minVersion != null &&
          _compareVersion(appVersion, minVersion) < 0) {
        return const BootstrapResult(
          allowed: false,
          reason: 'VERSION_BLOCKED',
        );
      }

      // ------------------------------
      // PASSED ALL CHECKS
      // ------------------------------
      return const BootstrapResult(allowed: true);
    } catch (e) {
      // Any unexpected error = fail closed
      return const BootstrapResult(
        allowed: false,
        reason: 'BOOTSTRAP_FAILED',
      );
    }
  }

  /* ---------------------------------------------------------- */
  /* INTERNAL HELPERS                                           */
  /* ---------------------------------------------------------- */

  /// Compare semantic versions like 6.7.0.4
  /// Returns:
  ///  < 0 → current < required
  ///  = 0 → equal
  ///  > 0 → current > required
  static int _compareVersion(
    String current,
    String required,
  ) {
    final List<int> a = current.split('.').map(int.parse).toList();
    final List<int> b = required.split('.').map(int.parse).toList();

    final int len = a.length > b.length ? a.length : b.length;

    for (int i = 0; i < len; i++) {
      final int av = i < a.length ? a[i] : 0;
      final int bv = i < b.length ? b[i] : 0;

      if (av != bv) {
        return av.compareTo(bv);
      }
    }
    return 0;
  }
}
