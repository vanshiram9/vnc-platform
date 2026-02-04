// ============================================================
// VNC PLATFORM — FEATURE LOCKED WIDGET (FRONTEND)
// File: lib/widgets/feature_locked_widget.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

/// FeatureLockedWidget
/// -------------------
/// UI-only widget to indicate a feature is locked or unavailable.
/// IMPORTANT:
/// - Does NOT decide access
/// - Does NOT unlock features
/// - Backend remains final authority
class FeatureLockedWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const FeatureLockedWidget({
    super.key,
    this.title = 'Feature Locked',
    this.message =
        'This feature is currently unavailable.',
    this.icon = Icons.lock_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 56,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
