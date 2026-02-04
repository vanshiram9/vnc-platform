// ============================================================
// VNC PLATFORM — PERMISSION DENIED WIDGET (FRONTEND)
// File: lib/widgets/permission_denied_widget.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

/// PermissionDeniedWidget
/// ----------------------
/// UI-only widget to show access denied information.
/// IMPORTANT:
/// - Does NOT decide permissions
/// - Does NOT attempt retries or bypass
/// - Backend + guards are final authority
class PermissionDeniedWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const PermissionDeniedWidget({
    super.key,
    this.title = 'Access Denied',
    this.message =
        'You do not have permission to access this section.',
    this.icon = Icons.block,
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
              color: Colors.red.shade400,
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
