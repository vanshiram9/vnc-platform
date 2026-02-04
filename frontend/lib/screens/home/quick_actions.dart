// ============================================================
// VNC PLATFORM — QUICK ACTIONS
// File: lib/screens/home/quick_actions.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../routing/route_names.dart';

/// QuickActions
/// ------------
/// Home screen shortcuts.
/// IMPORTANT:
/// - Does NOT check permissions
/// - Does NOT enable features
/// - Navigation is guarded elsewhere
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = const [
      _QuickAction(
        title: 'Wallet',
        icon: Icons.account_balance_wallet,
        route: RouteNames.wallet,
      ),
      _QuickAction(
        title: 'Mining',
        icon: Icons.trending_up,
        route: RouteNames.mining,
      ),
      _QuickAction(
        title: 'Trade',
        icon: Icons.swap_horiz,
        route: RouteNames.trade,
      ),
      _QuickAction(
        title: 'Merchant',
        icon: Icons.store,
        route: RouteNames.merchant,
      ),
      _QuickAction(
        title: 'Support',
        icon: Icons.support_agent,
        route: RouteNames.support,
      ),
    ];

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

/* ---------------------------------------------------------- */
/* INTERNAL WIDGET                                            */
/* ---------------------------------------------------------- */

class _QuickAction extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;

  const _QuickAction({
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
