// ============================================================
// VNC PLATFORM — MINING BOOST SCREEN
// File: lib/screens/mining/boost_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/app_button.dart';
import '../../widgets/error_banner.dart';
import '../../services/mining_service.dart';

/// BoostScreen
/// -----------
/// UI for requesting mining boost.
/// IMPORTANT:
/// - Frontend only sends boost intent
/// - Boost eligibility & effects decided by backend
class BoostScreen extends StatefulWidget {
  const BoostScreen({super.key});

  @override
  State<BoostScreen> createState() =>
      _BoostScreenState();
}

class _BoostScreenState extends State<BoostScreen> {
  bool _loading = false;
  String? _error;

  late final MiningService _miningService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _miningService =
        MiningService.of(context);
  }

  Future<void> _requestBoost() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _miningService.requestBoost();

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _error = 'Unable to activate mining boost';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Boost Mining',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (_error != null)
              ErrorBanner(message: _error!),
            const SizedBox(height: 12),

            const Text(
              'Boosting mining may increase your rewards temporarily.\nEligibility and duration are controlled by the system.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Activate Boost',
              loading: _loading,
              onPressed: _requestBoost,
            ),
          ],
        ),
      ),
    );
  }
}
