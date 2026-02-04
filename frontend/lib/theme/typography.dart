// ============================================================
// VNC PLATFORM — TYPOGRAPHY TOKENS
// File: lib/theme/typography.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

/// AppTypography
/// -------------
/// Centralized text styles.
/// IMPORTANT:
/// - Use ONLY these styles across the app
/// - No ad-hoc TextStyle() elsewhere
/// - Inter font is locked via pubspec assets
class AppTypography {
  AppTypography._();

  static const String _fontFamily = 'Inter';

  /* ---------------------------------------------------------- */
  /* HEADINGS                                                   */
  /* ---------------------------------------------------------- */

  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /* ---------------------------------------------------------- */
  /* BODY                                                       */
  /* ---------------------------------------------------------- */

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /* ---------------------------------------------------------- */
  /* LABELS / UI                                                */
  /* ---------------------------------------------------------- */

  static const TextStyle label = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.3,
  );

  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.4,
  );

  /* ---------------------------------------------------------- */
  /* MONOSPACE (IDS / CODES)                                    */
  /* ---------------------------------------------------------- */

  static const TextStyle mono = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}
