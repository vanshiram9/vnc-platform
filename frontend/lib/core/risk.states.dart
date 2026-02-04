// ============================================================
// VNC PLATFORM — RISK STATES (UI ONLY)
// File: lib/core/risk.states.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/// Risk levels as reported by backend.
/// IMPORTANT:
/// - UI warning / banner hint only
/// - Backend Zero-Trust is final authority
/// - Never block actions solely on client risk state
enum RiskLevel {
  unknown,
  low,
  medium,
  high,
  critical,
}

/// Parse backend wire value into [RiskLevel].
/// Unknown or missing values fall back to [RiskLevel.unknown].
RiskLevel parseRiskLevel(String? value) {
  switch (value) {
    case 'LOW':
      return RiskLevel.low;
    case 'MEDIUM':
      return RiskLevel.medium;
    case 'HIGH':
      return RiskLevel.high;
    case 'CRITICAL':
      return RiskLevel.critical;
    default:
      return RiskLevel.unknown;
  }
}

/// Convert [RiskLevel] to backend wire value.
/// Used only for diagnostics/logs (never authority).
String riskLevelToWire(RiskLevel level) {
  switch (level) {
    case RiskLevel.low:
      return 'LOW';
    case RiskLevel.medium:
      return 'MEDIUM';
    case RiskLevel.high:
      return 'HIGH';
    case RiskLevel.critical:
      return 'CRITICAL';
    case RiskLevel.unknown:
    default:
      return 'UNKNOWN';
  }
}

/// UI convenience helpers (NO authority)
extension RiskLevelX on RiskLevel {
  bool get showWarning =>
      this == RiskLevel.medium ||
      this == RiskLevel.high ||
      this == RiskLevel.critical;

  bool get showCriticalBanner =>
      this == RiskLevel.critical;

  String get label {
    switch (this) {
      case RiskLevel.low:
        return 'Low risk';
      case RiskLevel.medium:
        return 'Medium risk';
      case RiskLevel.high:
        return 'High risk';
      case RiskLevel.critical:
        return 'Critical risk';
      case RiskLevel.unknown:
      default:
        return 'Risk unknown';
    }
  }
}
