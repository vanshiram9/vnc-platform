// ============================================================
// VNC PLATFORM — ENV BASE
// File: lib/env/env.base.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/// Environment base contract.
/// - NO logic
/// - NO side-effects
/// - Pure configuration only
abstract class EnvBase {
  const EnvBase();

  /// API base URL (HTTPS only in prod)
  String get apiBaseUrl;

  /// Environment label (prod / staging)
  String get name;

  /// Network timeouts (milliseconds)
  int get connectTimeoutMs;
  int get receiveTimeoutMs;

  /// Whether verbose logs are allowed
  bool get allowLogs;

  /// Mandatory app version header value
  String get appVersionHeaderName => 'X-App-Version';

  /// Device identifier header
  String get deviceIdHeaderName => 'X-Device-Id';

  /// Authorization header name
  String get authHeaderName => 'Authorization';
}b
