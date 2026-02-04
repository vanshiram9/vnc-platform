// ============================================================
// VNC PLATFORM — ADMIN DASHBOARD SCREEN
// File: lib/screens/admin/admin_dashboard_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/app_button.dart';
import '../../widgets/empty_state_widget.dart';
import '../../routing/route_names.dart';
import '../../state/admin_state.dart';

/// AdminDashboardScreen
/// --------------------
/// Entry dashboard for admin users.
/// IMPORTANT:
/// - Frontend does NOT execute admin actions
/// - Backend enforces admin permissions & audit
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminState = AdminState.of(context);

    return AppScaffold(
      title: 'Admin',
      body: adminState.isEnabled
          ? _AdminView(state: adminState)
          : const EmptyStateWidget(
              title: 'Access Restricted',
              message:
                  'Admin access is not enabled for your account.',
            ),
    );
  }
}

/* ---------------------------------------------------------- */
/* INTERNAL WIDGETS                                           */
/* ---------------------------------------------------------- */

class _AdminView extends StatelessWidget {
  final AdminState state;

  const _AdminView({required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Admin Status',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.roleLabel,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Last Login: ${state.lastLogin}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        AppButton(
          label: 'User Moderation',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(RouteNames.adminUserModeration);
          },
        ),
        const SizedBox(height: 12),

        AppButton(
          label: 'KYC Review',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(RouteNames.adminKycReview);
          },
        ),
        const SizedBox(height: 12),

        AppButton(
          label: 'Transaction Review',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(
              RouteNames.adminTransactionReview,
            );
          },
        ),
        const SizedBox(height: 12),

        AppButton(
          label: 'Fraud Alerts',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(RouteNames.adminFraudAlerts);
          },
        ),
        const SizedBox(height: 12),

        AppButton(
          label: 'Audit Logs',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(RouteNames.adminAuditLogs);
          },
        ),
      ],
    );
  }
}
