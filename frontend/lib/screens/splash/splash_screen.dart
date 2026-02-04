// ============================================================
// VNC PLATFORM — SPLASH SCREEN
// File: lib/screens/splash/splash_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../routing/route_names.dart';

/// SplashScreen
/// ------------
/// Initial entry screen.
/// IMPORTANT:
/// - No auth decision here
/// - No feature logic here
/// - Only visual + timed redirect
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Minimal delay to show branding
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      // Actual routing decisions handled by guards
      Navigator.of(context)
          .pushReplacementNamed(RouteNames.authLogin);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'VNC PLATFORM',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
