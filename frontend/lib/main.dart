// ============================================================
// VNC PLATFORM — MAIN ENTRY
// File: lib/main.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'app.dart';
import 'bootstrap.dart';

import 'state/auth_state.dart';
import 'state/user_state.dart';
import 'state/wallet_state.dart';
import 'state/mining_state.dart';
import 'state/trade_state.dart';
import 'state/merchant_state.dart';
import 'state/admin_state.dart';
import 'state/owner_state.dart';

import 'env/env.base.dart';
import 'env/env.production.dart';
import 'env/env.staging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ------------------------------------------------------------
  // GLOBAL ERROR BOUNDARY (FAIL FAST)
  // ------------------------------------------------------------
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  // ------------------------------------------------------------
  // LOAD APP METADATA
  // ------------------------------------------------------------
  final PackageInfo pkg = await PackageInfo.fromPlatform();

  // ------------------------------------------------------------
  // SELECT ENVIRONMENT (LOCKED)
  // ------------------------------------------------------------
  // NOTE:
  // - Production builds MUST use EnvProduction
  // - Staging/dev can switch explicitly
  const EnvBase env = EnvProduction(); // CHANGE ONLY FOR STAGING

  // ------------------------------------------------------------
  // STARTUP BOOTSTRAP (VERSION / MAINTENANCE / BLOCK)
  // ------------------------------------------------------------
  final BootstrapResult bootstrap = await AppBootstrap.run(
    appVersion: pkg.version,
    buildNumber: pkg.buildNumber,
    env: env,
  );

  // If bootstrap fails, app must not proceed
  if (!bootstrap.allowed) {
    runApp(
      _BlockedApp(
        reason: bootstrap.reason ?? 'APP_BLOCKED',
      ),
    );
    return;
  }

  // ------------------------------------------------------------
  // START APP WITH STATE CONTAINERS
  // ------------------------------------------------------------
  runZonedGuarded(() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthState()),
          ChangeNotifierProvider(create: (_) => UserState()),
          ChangeNotifierProvider(create: (_) => WalletState()),
          ChangeNotifierProvider(create: (_) => MiningState()),
          ChangeNotifierProvider(create: (_) => TradeState()),
          ChangeNotifierProvider(create: (_) => MerchantState()),
          ChangeNotifierProvider(create: (_) => AdminState()),
          ChangeNotifierProvider(create: (_) => OwnerState()),
        ],
        child: const VncApp(),
      ),
    );
  }, (error, stack) {
    // Last-resort crash boundary
    debugPrint('UNHANDLED_ERROR: $error');
  });
}

/* -------------------------------------------------------------- */
/* BLOCKED APP FALLBACK                                           */
/* -------------------------------------------------------------- */

class _BlockedApp extends StatelessWidget {
  final String reason;

  const _BlockedApp({required this.reason});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              reason,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
