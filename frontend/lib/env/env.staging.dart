// ============================================================
// VNC PLATFORM — ENV STAGING
// File: lib/env/env.staging.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'env.base.dart';

/// Staging environment configuration.
/// - HTTPS preferred (HTTP only if explicitly required internally)
/// - Logs allowed (controlled)
/// - Timeouts slightly relaxed for debugging
class EnvStaging extends EnvBase {
  const EnvStaging();

  @override
  String get name => 'staging';

  /// IMPORTANT:
  /// Replace with your staging API domain.
  /// Example: https://staging-api.vncplatform.com
  @override
  String get apiBaseUrl => 'https://staging-api.vncplatform.com';

  /// Network timeouts (more forgiving than production)
  @override
  int get connectTimeoutMs => 12000;

  @override
  int get receiveTimeoutMs => 20000;

  /// Controlled logs allowed in staging only
  @override
  bool get allowLogs => true;
}
