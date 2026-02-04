// ============================================================
// VNC PLATFORM — ENV PRODUCTION
// File: lib/env/env.production.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'env.base.dart';

/// Production environment configuration.
/// - HTTPS only
/// - Strict timeouts
/// - Logs disabled
class EnvProduction extends EnvBase {
  const EnvProduction();

  @override
  String get name => 'production';

  /// IMPORTANT:
  /// Replace with your real production API domain.
  /// Example: https://api.vncplatform.com
  @override
  String get apiBaseUrl => 'https://api.vncplatform.com';

  /// Network discipline (fail fast)
  @override
  int get connectTimeoutMs => 8000;

  @override
  int get receiveTimeoutMs => 12000;

  /// No verbose logs in production
  @override
  bool get allowLogs => false;
}
