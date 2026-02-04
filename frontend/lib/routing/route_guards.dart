// ============================================================
// VNC PLATFORM — ROUTE GUARDS (UI ONLY)
// File: lib/routing/route_guards.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/auth_state.dart';
import '../state/user_state.dart';
import '../core/role.types.dart';
import 'route_names.dart';

/// RouteGuards
/// ------------
/// UI-only navigation guards.
/// IMPORTANT:
/// - Guards DO NOT grant permissions
/// - Backend Zero-Trust is final authority
/// - Any mismatch results in safe redirect
class RouteGuards {
  RouteGuards._();

  /* ---------------------------------------------------------- */
  /* AUTHENTICATED GUARD                                        */
  /* ---------------------------------------------------------- */

  static Route<dynamic> authenticated(
    RouteSettings settings,
    Widget page,
  ) {
    return _guard(
      settings,
      page,
      condition: (context) {
        final auth = context.read<AuthState>();
        return auth.isAuthenticated;
      },
      fallbackRoute: RouteNames.login,
    );
  }

  /* ---------------------------------------------------------- */
  /* ADMIN-ONLY GUARD                                           */
  /* ---------------------------------------------------------- */

  static Route<dynamic> adminOnly(
    RouteSettings settings,
    Widget page,
  ) {
    return _guard(
      settings,
      page,
      condition: (context) {
        final auth = context.read<AuthState>();
        final user = context.read<UserState>();

        if (!auth.isAuthenticated) return false;

        return user.role == UserRole.admin ||
            user.role == UserRole.owner;
      },
      fallbackRoute: RouteNames.home,
    );
  }

  /* ---------------------------------------------------------- */
  /* OWNER-ONLY GUARD                                           */
  /* ---------------------------------------------------------- */

  static Route<dynamic> ownerOnly(
    RouteSettings settings,
    Widget page,
  ) {
    return _guard(
      settings,
      page,
      condition: (context) {
        final auth = context.read<AuthState>();
        final user = context.read<UserState>();

        if (!auth.isAuthenticated) return false;

        return user.role == UserRole.owner;
      },
      fallbackRoute: RouteNames.home,
    );
  }

  /* ---------------------------------------------------------- */
  /* INTERNAL GUARD CORE                                        */
  /* ---------------------------------------------------------- */

  static Route<dynamic> _guard(
    RouteSettings settings,
    Widget page, {
    required bool Function(BuildContext) condition,
    required String fallbackRoute,
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        final bool allowed = condition(context);

        if (!allowed) {
          // Safe redirect — no explanation, no leak
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context)
                .pushReplacementNamed(fallbackRoute);
          });

          // Empty placeholder while redirecting
          return const SizedBox.shrink();
        }

        return page;
      },
    );
  }
}
