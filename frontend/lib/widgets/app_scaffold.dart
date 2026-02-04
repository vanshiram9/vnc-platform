// ============================================================
// VNC PLATFORM — APP SCAFFOLD (FRONTEND)
// File: lib/widgets/app_scaffold.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import 'app_appbar.dart';
import 'app_drawer.dart';
import 'app_loader.dart';

/// AppScaffold
/// -----------
/// Secure base layout for all authenticated screens.
/// IMPORTANT:
/// - No permission logic
/// - No role checks
/// - Backend remains authority
class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool loading;
  final bool showDrawer;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.loading = false,
    this.showDrawer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppAppBar(title: title),
          drawer: showDrawer ? const AppDrawer() : null,
          body: SafeArea(child: body),
        ),

        // Global blocking loader
        if (loading)
          const Positioned.fill(
            child: AppLoader(),
          ),
      ],
    );
  }
}
