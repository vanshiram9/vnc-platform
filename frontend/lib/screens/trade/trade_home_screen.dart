// ============================================================
// VNC PLATFORM — TRADE HOME SCREEN
// File: lib/screens/trade/trade_home_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/app_button.dart';
import '../../routing/route_names.dart';

/// TradeHomeScreen
/// ---------------
/// Entry dashboard for trading.
/// IMPORTANT:
/// - No trade execution
/// - No pricing logic
/// - Backend handles order matching & settlement
class TradeHomeScreen extends StatelessWidget {
  const TradeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Trade',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Trade Assets Securely',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'All trades are executed under escrow and zero-trust controls.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            AppButton(
              label: 'Buy / Sell',
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(RouteNames.tradeBuySell);
              },
            ),
            const SizedBox(height: 16),

            AppButton(
              label: 'Order History',
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(RouteNames.tradeOrders);
              },
            ),
            const SizedBox(height: 16),

            AppButton(
              label: 'Escrow Status',
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(RouteNames.tradeEscrow);
              },
            ),
          ],
        ),
      ),
    );
  }
}
