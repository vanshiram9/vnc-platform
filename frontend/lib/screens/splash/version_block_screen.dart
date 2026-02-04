// ============================================================
// VNC PLATFORM — VERSION BLOCK SCREEN
// File: lib/screens/splash/version_block_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

/// VersionBlockScreen
/// ------------------
/// Displayed when backend blocks current app version.
/// IMPORTANT:
/// - No skip
/// - No override
/// - User must update app externally
class VersionBlockScreen extends StatelessWidget {
  final String message;

  const VersionBlockScreen({
    super.key,
    this.message =
        'Your app version is no longer supported.\nPlease update to continue.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.system_update_alt,
                  size: 80,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Update Required',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
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
