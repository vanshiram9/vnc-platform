// ============================================================
// VNC PLATFORM — FEATURE FLAG MODEL (FRONTEND)
// File: lib/models/feature_flag_model.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import '../core/feature.flags.dart';

/// FeatureFlagModel
/// ----------------
/// Immutable frontend representation of a feature flag.
/// IMPORTANT:
/// - Feature enforcement happens ONLY on backend
/// - Frontend uses this model for UI visibility hints
class FeatureFlagModel {
  final FeatureFlag flag;
  final bool enabled;

  const FeatureFlagModel({
    required this.flag,
    required this.enabled,
  });

  /* ---------------------------------------------------------- */
  /* FACTORY                                                    */
  /* ---------------------------------------------------------- */

  factory FeatureFlagModel.fromJson(
    String key,
    dynamic value,
  ) {
    final FeatureFlag? parsed =
        parseFeatureFlag(key);

    if (parsed == null || value is! bool) {
      throw StateError('FEATURE_FLAG_INVALID');
    }

    return FeatureFlagModel(
      flag: parsed,
      enabled: value,
    );
  }
}
