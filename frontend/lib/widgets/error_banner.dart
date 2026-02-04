// ============================================================
// VNC PLATFORM — ERROR BANNER (FRONTEND)
// File: lib/widgets/error_banner.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

/// ErrorBanner
/// -----------
/// Lightweight banner for displaying non-blocking errors.
/// IMPORTANT:
/// - No retry / action logic
/// - Pure UI feedback
class ErrorBanner extends StatelessWidget {
  final String message;
  final Color? backgroundColor;

  const ErrorBanner({
    super.key,
    required this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      color: backgroundColor ??
          Theme.of(context).colorScheme.error,
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}
