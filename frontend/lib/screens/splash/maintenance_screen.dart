// ============================================================
// VNC PLATFORM — MAINTENANCE SCREEN
// File: lib/screens/splash/maintenance_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

/// MaintenanceScreen
/// -----------------
/// Displayed when backend places system in maintenance mode.
/// IMPORTANT:
/// - No retry logic
/// - No override
/// - Backend controls availability
class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.build_outlined,
                  size: 80,
                  color: Colors.orange,
                ),
                SizedBox(height: 24),
                Text(
                  'Maintenance in Progress',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'The system is temporarily unavailable.\nPlease try again later.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
