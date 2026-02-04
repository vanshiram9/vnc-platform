// ============================================================
// VNC PLATFORM — BLOCKED SCREEN
// File: lib/screens/auth/blocked_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

/// BlockedScreen
/// -------------
/// Displayed when user account is blocked by backend.
/// IMPORTANT:
/// - No retry
/// - No override
/// - Backend decision is final
class BlockedScreen extends StatelessWidget {
  final String message;

  const BlockedScreen({
    super.key,
    this.message =
        'Your account has been blocked due to policy or security reasons.',
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
                  Icons.block,
                  size: 80,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Account Blocked',
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
