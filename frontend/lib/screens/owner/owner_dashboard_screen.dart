// ============================================================
// VNC PLATFORM — OWNER DASHBOARD SCREEN
// File: lib/screens/owner/owner_dashboard_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/app_button.dart';
import '../../widgets/empty_state_widget.dart';
import '../../routing/route_names.dart';
import '../../state/owner_state.dart';

/// OwnerDashboardScreen
/// --------------------
/// Supreme control dashboard for platform owner.
/// IMPORTANT:
/// - Frontend does NOT execute owner actions
/// - Backend enforces owner authority, audit & kill-switch
class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ownerState = OwnerState.of(context);

    return AppScaffold(
      title: 'Owner',
      body: ownerState.isEnabled
          ? _OwnerView(state: ownerState)
          : const EmptyStateWidget(
              title: 'Access Restricted',
              message:
                  'Owner access is not enabled for this account.',
            ),
    );
  }
}

/* ---------------------------------------------------------- */
/* INTERNAL WIDGETS                                           */
/* ---------------------------------------------------------- */

class _OwnerView extends StatelessWidget {
  final OwnerState state;

  const _OwnerView({required this.state});

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
                  'Owner Status',
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
                  'Last Verified: ${state.lastVerified}',
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
          label: 'Feature Toggles',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(RouteNames.ownerFeatureToggle);
          },
        ),
        const SizedBox(height: 12),

        AppButton(
          label: 'Country Rules',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(RouteNames.ownerCountryRules);
          },
        ),
        const SizedBox(height: 12),

        AppButton(
          label: 'System Control',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(RouteNames.ownerSystemControl);
          },
        ),
        const SizedBox(height: 12),

        AppButton(
          label: 'Emergency Kill Switch',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(RouteNames.ownerEmergencyKill);
          },
        ),
      ],
    );
  }
}
