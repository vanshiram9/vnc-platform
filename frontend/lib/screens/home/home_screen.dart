// ============================================================
// VNC PLATFORM — HOME SCREEN
// File: lib/screens/home/home_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../routing/route_names.dart';

/// HomeScreen
/// ----------
/// Main dashboard entry.
/// IMPORTANT:
/// - No permission logic
/// - No feature enforcement
/// - Backend + route guards decide access
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Home',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _WelcomeCard(),
          const SizedBox(height: 16),
          const _QuickActions(),
        ],
      ),
    );
  }
}

/* ---------------------------------------------------------- */
/* INTERNAL WIDGETS                                           */
/* ---------------------------------------------------------- */

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Welcome to VNC Platform',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Secure. Regulated. Zero-Trust.',
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        title: 'Wallet',
        icon: Icons.account_balance_wallet,
        route: RouteNames.wallet,
      ),
      _ActionItem(
        title: 'Mining',
        icon: Icons.trending_up,
        route: RouteNames.mining,
      ),
      _ActionItem(
        title: 'Trade',
        icon: Icons.swap_horiz,
        route: RouteNames.trade,
      ),
      _ActionItem(
        title: 'Support',
        icon: Icons.support_agent,
        route: RouteNames.support,
      ),
    ];

    if (actions.isEmpty) {
      return const EmptyStateWidget(
        title: 'No Actions',
        message: 'No actions available at the moment.',
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: actions,
    );
  }
}

class _ActionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;

  const _ActionItem({
    required this.title,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Card(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
