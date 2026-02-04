// ============================================================
// VNC PLATFORM — MINING REFERRAL SCREEN
// File: lib/screens/mining/referral_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/mining_service.dart';

/// ReferralScreen
/// --------------
/// Displays referral code & sharing intent.
/// IMPORTANT:
/// - Frontend does NOT calculate referral rewards
/// - Backend assigns & validates referrals
class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() =>
      _ReferralScreenState();
}

class _ReferralScreenState
    extends State<ReferralScreen> {
  bool _loading = true;
  String? _code;

  late final MiningService _miningService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _miningService =
        MiningService.of(context);
    _load();
  }

  Future<void> _load() async {
    try {
      final code =
          await _miningService.getReferralCode();
      setState(() {
        _code = code;
      });
    } catch (_) {
      // silent fail
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Referral',
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _code == null
              ? const EmptyStateWidget(
                  title: 'Referral Unavailable',
                  message:
                      'Referral program is not active.',
                )
              : Padding(
                  padding:
                      const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Your Referral Code',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        _code!,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Share this code to invite others.\nRewards are governed by system rules.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
    );
  }
}
