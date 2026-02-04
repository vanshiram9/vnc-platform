// ============================================================
// VNC PLATFORM — LEDGER SCREEN
// File: lib/screens/wallet/ledger_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/ledger_row_widget.dart';
import '../../widgets/empty_state_widget.dart';
import '../../state/wallet_state.dart';

/// LedgerScreen
/// ------------
/// Displays wallet ledger entries.
/// IMPORTANT:
/// - Ledger integrity enforced by backend
/// - Frontend only renders immutable entries
class LedgerScreen extends StatelessWidget {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletState = WalletState.of(context);
    final entries = walletState.wallet?.ledger ?? [];

    return AppScaffold(
      title: 'Ledger',
      body: entries.isEmpty
          ? const EmptyStateWidget(
              title: 'No Transactions',
              message:
                  'Your ledger is currently empty.',
            )
          : ListView.separated(
              itemCount: entries.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1),
              itemBuilder: (context, index) {
                return LedgerRowWidget(
                  entry: entries[index],
                );
              },
            ),
    );
  }
}
