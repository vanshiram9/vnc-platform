// ============================================================
// VNC PLATFORM — MINING SCREEN
// File: lib/screens/mining/mining_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/app_button.dart';
import '../../widgets/empty_state_widget.dart';
import '../../routing/route_names.dart';
import '../../state/mining_state.dart';

/// MiningScreen
/// ------------
/// Main mining dashboard.
/// IMPORTANT:
/// - Frontend does NOT calculate mining rewards
/// - Frontend does NOT enforce mining rules
/// - Backend controls eligibility & rewards
class MiningScreen extends StatelessWidget {
  const MiningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final miningState = MiningState.of(context);

    return AppScaffold(
      title: 'Mining',
      body: miningState.isEnabled
          ? _MiningView(miningState: miningState)
          : const EmptyStateWidget(
              title: 'Mining Unavailable',
              message:
                  'Mining is currently disabled for your account.',
            ),
    );
  }
}

/* ---------------------------------------------------------- */
/* INTERNAL WIDGETS                                           */
/* ---------------------------------------------------------- */

class _MiningView extends StatelessWidget {
  final MiningState miningState;

  const _MiningView({
    required this.miningState,
  });

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
                  'Mining Status',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  miningState.statusLabel,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Total Mined: ${miningState.totalMined}',
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
          label: 'Boost Mining',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(RouteNames.miningBoost);
          },
        ),
        const SizedBox(height: 12),

        AppButton(
          label: 'Referral',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(RouteNames.miningReferral);
          },
        ),
        const SizedBox(height: 12),

        AppButton(
          label: 'Mining History',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(RouteNames.miningHistory);
          },
        ),
      ],
    );
  }
}
