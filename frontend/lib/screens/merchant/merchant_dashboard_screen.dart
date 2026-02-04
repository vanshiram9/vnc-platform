// ============================================================
// VNC PLATFORM — MERCHANT DASHBOARD SCREEN
// File: lib/screens/merchant/merchant_dashboard_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/app_button.dart';
import '../../widgets/empty_state_widget.dart';
import '../../routing/route_names.dart';
import '../../state/merchant_state.dart';

/// MerchantDashboardScreen
/// -----------------------
/// Main dashboard for merchant users.
/// IMPORTANT:
/// - No settlement logic
/// - No payout calculation
/// - Backend decides merchant eligibility & limits
class MerchantDashboardScreen extends StatelessWidget {
  const MerchantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final merchantState = MerchantState.of(context);

    return AppScaffold(
      title: 'Merchant',
      body: merchantState.isEnabled
          ? _MerchantView(state: merchantState)
          : const EmptyStateWidget(
              title: 'Merchant Disabled',
              message:
                  'Merchant services are not enabled for this account.',
            ),
    );
  }
}

/* ---------------------------------------------------------- */
/* INTERNAL WIDGETS                                           */
/* ---------------------------------------------------------- */

class _MerchantView extends StatelessWidget {
  final MerchantState state;

  const _MerchantView({required this.state});

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
                  'Merchant Status',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.statusLabel,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Total Volume: ${state.totalVolume}',
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
          label: 'Merchant QR',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(RouteNames.merchantQr);
          },
        ),
        const SizedBox(height: 12),

        AppButton(
          label: 'Settlement',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(
              RouteNames.merchantSettlement,
            );
          },
        ),
        const SizedBox(height: 12),

        AppButton(
          label: 'Merchant KYC',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(
              RouteNames.merchantKyc,
            );
          },
        ),
      ],
    );
  }
}
