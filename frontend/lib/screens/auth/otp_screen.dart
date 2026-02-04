// ============================================================
// VNC PLATFORM — OTP SCREEN
// File: lib/screens/auth/otp_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../routing/route_names.dart';
import '../../widgets/app_button.dart';
import '../../widgets/error_banner.dart';

/// OtpScreen
/// ---------
/// OTP verification screen.
/// IMPORTANT:
/// - Frontend only submits OTP
/// - Validation & session creation handled by backend
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpCtrl =
      TextEditingController();

  bool _loading = false;
  String? _error;

  late final AuthService _authService;
  late final String _identifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authService = AuthService.of(context);

    final args =
        ModalRoute.of(context)?.settings.arguments;
    _identifier = args is String ? args : '';
  }

  Future<void> _verifyOtp() async {
    final otp = _otpCtrl.text.trim();

    if (otp.length < 4) {
      setState(() {
        _error = 'Invalid OTP';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _authService.verifyOtp(
        identifier: _identifier,
        otp: otp,
      );

      if (!mounted) return;

      // Actual destination resolved by route guards
      Navigator.of(context)
          .pushReplacementNamed(RouteNames.home);
    } catch (e) {
      setState(() {
        _error = 'OTP verification failed';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              if (_error != null)
                ErrorBanner(message: _error!),

              const SizedBox(height: 12),
              TextField(
                controller: _otpCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                ),
              ),
              const SizedBox(height: 24),

              AppButton(
                label: 'Verify',
                loading: _loading,
                onPressed: _verifyOtp,
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
