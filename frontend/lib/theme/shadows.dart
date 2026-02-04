// ============================================================
// VNC PLATFORM — SHADOW TOKENS
// File: lib/theme/shadows.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

/// AppShadows
/// ----------
/// Centralized elevation & shadow system.
/// IMPORTANT:
/// - Use ONLY these shadows across the app
/// - No ad-hoc BoxShadow elsewhere
/// - Keep elevation subtle & accessible
class AppShadows {
  AppShadows._();

  /* ---------------------------------------------------------- */
  /* LIGHT THEME SHADOWS                                        */
  /* ---------------------------------------------------------- */

  static const List<BoxShadow> lightLow = [
    BoxShadow(
      color: Color(0x14000000), // 8% black
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> lightMedium = [
    BoxShadow(
      color: Color(0x1F000000), // 12% black
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> lightHigh = [
    BoxShadow(
      color: Color(0x29000000), // 16% black
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  /* ---------------------------------------------------------- */
  /* DARK THEME SHADOWS                                         */
  /* ---------------------------------------------------------- */

  static const List<BoxShadow> darkLow = [
    BoxShadow(
      color: Color(0x66000000), // 40% black
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> darkMedium = [
    BoxShadow(
      color: Color(0x80000000), // 50% black
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> darkHigh = [
    BoxShadow(
      color: Color(0x99000000), // 60% black
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
}
