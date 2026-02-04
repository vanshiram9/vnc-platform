// ============================================================
// VNC PLATFORM — COUNTRY RULES (UI ONLY)
// File: lib/core/country.rules.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/// Country access hints as reported by backend.
/// IMPORTANT:
/// - UI hint only
/// - Backend Zero-Trust is the final authority
/// - Never enforce allow/block purely on client
class CountryRule {
  final String countryCode; // ISO-3166-1 alpha-2 (e.g. IN, US)
  final bool allowed;

  const CountryRule({
    required this.countryCode,
    required this.allowed,
  });
}

/// Parse backend payload into [CountryRule].
/// Expected wire example:
/// { "country": "IN", "allowed": true }
CountryRule? parseCountryRule(Map<String, dynamic>? json) {
  if (json == null) return null;

  final String? code = json['country'] as String?;
  final bool? allowed = json['allowed'] as bool?;

  if (code == null || code.length != 2 || allowed == null) {
    return null; // fail-safe ignore
  }

  return CountryRule(
    countryCode: code.toUpperCase(),
    allowed: allowed,
  );
}

/// UI helpers (NO authority)
extension CountryRuleX on CountryRule {
  bool get isBlocked => !allowed;

  String get displayName => countryCode;
}
