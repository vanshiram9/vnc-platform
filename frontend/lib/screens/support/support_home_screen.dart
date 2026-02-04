// ============================================================
// VNC PLATFORM — SUPPORT HOME SCREEN
// File: lib/screens/support/support_home_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/app_button.dart';
import '../../routing/route_names.dart';

/// SupportHomeScreen
/// -----------------
/// Entry dashboard for support & help.
/// IMPORTANT:
/// - Frontend does NOT resolve tickets
/// - Backend controls ticket lifecycle
class SupportHomeScreen extends StatelessWidget {
  const SupportHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Support',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'How can we help you?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Create Ticket',
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(RouteNames.supportCreate);
              },
            ),
            const SizedBox(height: 16),

            AppButton(
              label: 'Ticket Status',
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(RouteNames.supportStatus);
              },
            ),
          ],
        ),
      ),
    );
  }
}
