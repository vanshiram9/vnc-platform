// ============================================================
// VNC PLATFORM — FEATURE FLAG SERVICE (FRONTEND)
// File: lib/services/feature_flag_service.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'api_client.dart';
import '../core/feature.flags.dart';

/// FeatureFlagService
/// ------------------
/// Frontend feature-flag mirror.
/// IMPORTANT:
/// - Flags are UI hints ONLY
/// - Backend Zero-Trust is final authority
/// - Never block or allow actions based on this alone
class FeatureFlagService {
  final ApiClient _api;

  FeatureFlagService(this._api);

  /* ---------------------------------------------------------- */
  /* FETCH                                                      */
  /* ---------------------------------------------------------- */

  /// Fetch feature flags snapshot from backend
  ///
  /// Expected backend response example:
  /// {
  ///   "flags": {
  ///     "WALLET": true,
  ///     "TRADE": false
  ///   }
  /// }
  Future<Map<FeatureFlag, bool>> fetchFlags() async {
    final res = await _api.get('/features');

    final raw = res['flags'];
    if (raw is! Map) {
      throw StateError('FEATURE_FLAGS_INVALID');
    }

    final Map<FeatureFlag, bool> flags = {};

    raw.forEach((key, value) {
      if (value is bool) {
        final FeatureFlag? flag =
            parseFeatureFlag(key.toString());
        if (flag != null) {
          flags[flag] = value;
        }
      }
    });

    return flags;
  }
}
