// ============================================================
// VNC PLATFORM — LOGIN SCREEN
// File: lib/screens/auth/login_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../routing/route_names.dart';
import '../../widgets/app_button.dart';
import '../../widgets/error_banner.dart';

/// LoginScreen
/// -----------
/// Entry point for authentication.
/// IMPORTANT:
/// - Frontend only collects identifier
/// - OTP decision & validation handled by backend
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierCtrl =
      TextEditingController();

  bool _loading = false;
  String? _error;

  late final AuthService _authService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authService =
        AuthService.of(context);
  }

  Future<void> _requestOtp() async {
    final identifier = _identifierCtrl.text.trim();
    if (identifier.isEmpty) {
      setState(() {
        _error = 'Please enter your email or mobile';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _authService.requestOtp(
        identifier: identifier,
      );

      if (!mounted) return;

      Navigator.of(context).pushNamed(
        RouteNames.authOtp,
        arguments: identifier,
      );
    } catch (e) {
      setState(() {
        _error = 'Unable to send OTP. Try again.';
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
                'Login to VNC',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              if (_error != null)
                ErrorBanner(message: _error!),

              const SizedBox(height: 12),
              TextField(
                controller: _identifierCtrl,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Email or Mobile',
                ),
              ),
              const SizedBox(height: 24),

              AppButton(
                label: 'Send OTP',
                loading: _loading,
                onPressed: _requestOtp,
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
