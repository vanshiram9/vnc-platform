// ============================================================
// VNC PLATFORM — APP APPBAR (FRONTEND)
// File: lib/widgets/app_appbar.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

/// AppAppBar
/// ---------
/// Centralized app bar widget.
/// IMPORTANT:
/// - No role checks
/// - No permission enforcement
/// - Pure UI component
class AppAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
      actions: actions,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
