// ============================================================
// VNC PLATFORM — LOCK COINS SCREEN
// File: lib/screens/wallet/lock_coins_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/app_button.dart';
import '../../widgets/error_banner.dart';
import '../../services/wallet_service.dart';

/// LockCoinsScreen
/// ---------------
/// UI for locking / staking coins.
/// IMPORTANT:
/// - Frontend only collects amount
/// - Validation & rules enforced by backend
class LockCoinsScreen extends StatefulWidget {
  const LockCoinsScreen({super.key});

  @override
  State<LockCoinsScreen> createState() =>
      _LockCoinsScreenState();
}

class _LockCoinsScreenState extends State<LockCoinsScreen> {
  final TextEditingController _amountCtrl =
      TextEditingController();

  bool _loading = false;
  String? _error;

  late final WalletService _walletService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _walletService =
        WalletService.of(context);
  }

  Future<void> _lockCoins() async {
    final raw = _amountCtrl.text.trim();
    final amount = num.tryParse(raw);

    if (amount == null || amount <= 0) {
      setState(() {
        _error = 'Enter a valid amount';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _walletService.lockCoins(amount: amount);

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _error = 'Unable to lock coins';
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
      title: 'Lock Coins',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (_error != null)
              ErrorBanner(message: _error!),
            const SizedBox(height: 12),

            TextField(
              controller: _amountCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Amount to lock',
              ),
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Confirm Lock',
              loading: _loading,
              onPressed: _lockCoins,
            ),
          ],
        ),
      ),
    );
  }
}
