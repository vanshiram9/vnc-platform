// ============================================================
// VNC PLATFORM — APP DRAWER (FRONTEND)
// File: lib/widgets/app_drawer.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../routing/route_names.dart';

/// AppDrawer
/// ---------
/// Central navigation drawer.
/// IMPORTANT:
/// - Drawer NEVER decides access
/// - Routes are guarded elsewhere (route guards + backend)
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: const [
            _DrawerHeader(),
            _DrawerItem(
              icon: Icons.home,
              title: 'Home',
              route: RouteNames.home,
            ),
            _DrawerItem(
              icon: Icons.account_balance_wallet,
              title: 'Wallet',
              route: RouteNames.wallet,
            ),
            _DrawerItem(
              icon: Icons.trending_up,
              title: 'Mining',
              route: RouteNames.mining,
            ),
            _DrawerItem(
              icon: Icons.swap_horiz,
              title: 'Trade',
              route: RouteNames.trade,
            ),
            _DrawerItem(
              icon: Icons.store,
              title: 'Merchant',
              route: RouteNames.merchant,
            ),
            _DrawerItem(
              icon: Icons.support_agent,
              title: 'Support',
              route: RouteNames.support,
            ),
            _DrawerItem(
              icon: Icons.help_outline,
              title: 'FAQ',
              route: RouteNames.faq,
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------------------------------------------------- */
/* INTERNAL WIDGETS                                           */
/* ---------------------------------------------------------- */

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return const DrawerHeader(
      decoration: BoxDecoration(),
      child: Center(
        child: Text(
          'VNC PLATFORM',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(route);
      },
    );
  }
}
