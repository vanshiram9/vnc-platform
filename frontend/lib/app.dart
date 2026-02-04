// ============================================================
// VNC PLATFORM — APP SHELL
// File: lib/app.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routing/app_router.dart';
import 'routing/route_names.dart';
import 'theme/app_theme.dart';

import 'state/auth_state.dart';
import 'state/user_state.dart';

/// Root application widget.
/// - Attaches theme
/// - Attaches router
/// - NO business logic
/// - NO authority decisions
class VncApp extends StatelessWidget {
  const VncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthState, UserState>(
      builder: (context, auth, user, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'VNC Platform',

          // ------------------------------
          // THEME (LOCKED)
          // ------------------------------
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.system,

          // ------------------------------
          // ROUTING (GUARDED)
          // ------------------------------
          initialRoute: _initialRoute(auth),
          onGenerateRoute: AppRouter.generate,

          // ------------------------------
          // GLOBAL FALLBACK
          // ------------------------------
          onUnknownRoute: (_) => AppRouter.unknown(),
        );
      },
    );
  }

  /// Decide first screen ONLY based on auth signal.
  /// Final authority still lies with backend.
  String _initialRoute(AuthState auth) {
    if (!auth.isInitialized) {
      return RouteNames.splash;
    }

    if (!auth.isAuthenticated) {
      return RouteNames.login;
    }

    return RouteNames.home;
  }
}
