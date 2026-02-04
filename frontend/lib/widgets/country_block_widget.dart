// ============================================================
// VNC PLATFORM — COUNTRY BLOCK WIDGET (FRONTEND)
// File: lib/widgets/country_block_widget.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

/// CountryBlockWidget
/// ------------------
/// UI-only widget to indicate country-based restriction.
/// IMPORTANT:
/// - Does NOT check country
/// - Does NOT enforce blocking
/// - Backend country rules are final authority
class CountryBlockWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const CountryBlockWidget({
    super.key,
    this.title = 'Service Unavailable',
    this.message =
        'This service is not available in your country.',
    this.icon = Icons.public_off,
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
              color: Colors.orange.shade400,
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
