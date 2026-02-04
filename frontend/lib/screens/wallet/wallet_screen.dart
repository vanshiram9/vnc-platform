// ============================================================
// VNC PLATFORM — WALLET SCREEN
// File: lib/screens/wallet/wallet_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/app_button.dart';
import '../../widgets/empty_state_widget.dart';
import '../../routing/route_names.dart';
import '../../state/wallet_state.dart';

/// WalletScreen
/// ------------
/// Main wallet dashboard.
/// IMPORTANT:
/// - No business logic
/// - No balance math
/// - Backend decides everything
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletState = WalletState.of(context);

    return AppScaffold(
      title: 'Wallet',
      body: walletState.hasWallet
          ? _WalletView(walletState: walletState)
          : const EmptyStateWidget(
              title: 'No Wallet',
              message:
                  'Wallet not initialized yet.',
            ),
    );
  }
}

/* ---------------------------------------------------------- */
/* INTERNAL WIDGETS                                           */
/* ---------------------------------------------------------- */

class _WalletView extends StatelessWidget {
  final WalletState walletState;

  const _WalletView({
    required this.walletState,
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
                  'Balance',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  walletState.balance.toString(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Locked: ${walletState.lockedBalance}',
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
          label: 'View Ledger',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(RouteNames.ledger);
          },
        ),
        const SizedBox(height: 12),

        AppButton(
          label: 'Withdraw',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(RouteNames.withdraw);
          },
        ),
        const SizedBox(height: 12),

        AppButton(
          label: 'Lock Coins',
          onPressed: () {
            Navigator.of(context)
                .pushNamed(RouteNames.lockCoins);
          },
        ),
      ],
    );
  }
}
