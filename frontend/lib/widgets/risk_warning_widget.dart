// ============================================================
// VNC PLATFORM — RISK WARNING WIDGET (FRONTEND)
// File: lib/widgets/risk_warning_widget.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

/// RiskWarningWidget
/// -----------------
/// UI-only widget to display risk or compliance warnings.
/// IMPORTANT:
/// - Does NOT evaluate risk
/// - Does NOT block actions
/// - Backend risk engine is final authority
class RiskWarningWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const RiskWarningWidget({
    super.key,
    this.title = 'Risk Warning',
    this.message =
        'Your account activity is under risk review.',
    this.icon = Icons.warning_amber_outlined,
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
              color: Colors.amber.shade600,
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
