// ============================================================
// VNC PLATFORM — ALERT RULES (REGULATOR SAFE)
// ============================================================

export type AlertLevel = 'INFO' | 'WARNING' | 'CRITICAL';

export function evaluateEscalation(
  warningsInWindow: number,
  windowHours: number
): AlertLevel {
  if (warningsInWindow >= 3 && windowHours <= 24) {
    return 'CRITICAL';
  }
  if (warningsInWindow >= 1) {
    return 'WARNING';
  }
  return 'INFO';
}

export function mustFreezeSystem(level: AlertLevel): boolean {
  return level === 'CRITICAL';
}
