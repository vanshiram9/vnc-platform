// ============================================================
// VNC PLATFORM — APP LOADER (FRONTEND)
// File: lib/widgets/app_loader.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

/// AppLoader
/// ---------
/// Full-screen blocking loader.
/// IMPORTANT:
/// - Pure UI component
/// - No business logic
/// - Used during critical async operations
class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.35),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
