// ============================================================
// VNC PLATFORM — COLOR TOKENS
// File: lib/theme/colors.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

/// AppColors
/// ---------
/// Centralized color tokens.
/// IMPORTANT:
/// - Use ONLY these colors across the app
/// - No ad-hoc Color(...) elsewhere
/// - Dark/Light parity maintained
class AppColors {
  AppColors._();

  /* ---------------------------------------------------------- */
  /* BRAND                                                      */
  /* ---------------------------------------------------------- */

  static const Color primary = Color(0xFF3B82F6); // Blue-500
  static const Color primaryDark = Color(0xFF2563EB); // Blue-600
  static const Color accent = Color(0xFF22C55E); // Green-500

  /* ---------------------------------------------------------- */
  /* NEUTRALS                                                   */
  /* ---------------------------------------------------------- */

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  /* ---------------------------------------------------------- */
  /* SEMANTIC                                                   */
  /* ---------------------------------------------------------- */

  static const Color success = Color(0xFF16A34A); // Green-600
  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color error = Color(0xFFDC2626); // Red-600
  static const Color info = Color(0xFF0EA5E9); // Sky-500

  /* ---------------------------------------------------------- */
  /* BACKGROUNDS                                                */
  /* ---------------------------------------------------------- */

  static const Color bgLight = Color(0xFFFFFFFF);
  static const Color bgDark = Color(0xFF0B1220);

  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color surfaceDark = Color(0xFF111827);

  /* ---------------------------------------------------------- */
  /* TEXT                                                       */
  /* ---------------------------------------------------------- */

  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textDisabledLight = Color(0xFF94A3B8);

  static const Color textPrimaryDark = Color(0xFFE5E7EB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textDisabledDark = Color(0xFF6B7280);

  /* ---------------------------------------------------------- */
  /* BORDERS / DIVIDERS                                         */
  /* ---------------------------------------------------------- */

  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  /* ---------------------------------------------------------- */
  /* STATES                                                     */
  /* ---------------------------------------------------------- */

  static const Color overlay = Color(0x66000000); // 40% black
  static const Color focus = Color(0xFF60A5FA); // Blue-400
}
