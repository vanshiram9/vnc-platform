// ============================================================
// VNC PLATFORM — COUNTRY RULE SERVICE (FRONTEND)
// File: lib/services/country_rule_service.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'api_client.dart';
import '../core/country.rules.dart';

/// CountryRuleService
/// ------------------
/// Frontend country-rule mirror.
/// IMPORTANT:
/// - UI hints ONLY
/// - Backend Zero-Trust enforces real access
/// - Never block flows based on client rules
class CountryRuleService {
  final ApiClient _api;

  CountryRuleService(this._api);

  /* ---------------------------------------------------------- */
  /* FETCH                                                      */
  /* ---------------------------------------------------------- */

  /// Fetch country rules snapshot
  ///
  /// Expected backend response example:
  /// {
  ///   "countries": [
  ///     { "country": "IN", "allowed": true },
  ///     { "country": "CN", "allowed": false }
  ///   ]
  /// }
  Future<List<CountryRule>> fetchRules() async {
    final res = await _api.get('/countries');

    final raw = res['countries'];
    if (raw is! List) {
      throw StateError('COUNTRY_RULES_INVALID');
    }

    final List<CountryRule> rules = [];

    for (final item in raw) {
      if (item is Map<String, dynamic>) {
        final rule = parseCountryRule(item);
        if (rule != null) {
          rules.add(rule);
        }
      }
    }

    return rules;
  }
}
