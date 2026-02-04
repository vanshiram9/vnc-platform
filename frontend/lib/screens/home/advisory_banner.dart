// ============================================================
// VNC PLATFORM — ADVISORY BANNER
// File: lib/screens/home/advisory_banner.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

/// AdvisoryBanner
/// --------------
/// Displays compliance / risk / system advisory messages.
/// IMPORTANT:
/// - Advisory only (no blocking)
/// - Backend decides when to show this
class AdvisoryBanner extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color? backgroundColor;

  const AdvisoryBanner({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.info_outline,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor ??
            Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.blueGrey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(message),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
