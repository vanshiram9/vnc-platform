// ============================================================
// VNC PLATFORM — DEVICE VERIFY SCREEN
// File: lib/screens/auth/device_verify_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../routing/route_names.dart';
import '../../widgets/app_button.dart';

/// DeviceVerifyScreen
/// ------------------
/// Shown when backend requires device verification.
/// IMPORTANT:
/// - Frontend does NOT verify device
/// - Backend controls trust & approval
class DeviceVerifyScreen extends StatelessWidget {
  const DeviceVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              const Icon(
                Icons.phonelink_lock,
                size: 80,
                color: Colors.blueGrey,
              ),
              const SizedBox(height: 24),

              const Text(
                'Device Verification Required',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              const Text(
                'For security reasons, this device must be verified before continuing.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              AppButton(
                label: 'Back to Login',
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(
                    RouteNames.authLogin,
                  );
                },
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
