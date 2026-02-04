// ============================================================
// VNC PLATFORM — UNLOCK STATUS SCREEN
// File: lib/screens/wallet/unlock_status_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../state/wallet_state.dart';

/// UnlockStatusScreen
/// ------------------
/// Displays status of locked coins.
/// IMPORTANT:
/// - Frontend does NOT calculate unlock time
/// - Frontend does NOT trigger unlock
/// - Backend enforces lock rules
class UnlockStatusScreen extends StatelessWidget {
  const UnlockStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletState = WalletState.of(context);

    return AppScaffold(
      title: 'Locked Coins Status',
      body: walletState.lockedBalance <= 0
          ? const EmptyStateWidget(
              title: 'No Locked Coins',
              message:
                  'You do not have any locked coins.',
            )
          : ListView(
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
                          'Locked Balance',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          walletState.lockedBalance
                              .toString(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Unlock timing and eligibility are decided by the system.',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
