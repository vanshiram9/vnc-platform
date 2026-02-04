// ============================================================
// VNC PLATFORM — WITHDRAW SCREEN
// File: lib/screens/wallet/withdraw_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/app_button.dart';
import '../../widgets/error_banner.dart';
import '../../services/wallet_service.dart';

/// WithdrawScreen
/// --------------
/// UI for initiating a withdrawal request.
/// IMPORTANT:
/// - Frontend only collects intent (amount + destination)
/// - Limits, KYC, risk, approval enforced by backend
class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() =>
      _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _amountCtrl =
      TextEditingController();
  final TextEditingController _destinationCtrl =
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

  Future<void> _withdraw() async {
    final rawAmount = _amountCtrl.text.trim();
    final amount = num.tryParse(rawAmount);
    final destination = _destinationCtrl.text.trim();

    if (amount == null || amount <= 0) {
      setState(() {
        _error = 'Enter a valid amount';
      });
      return;
    }

    if (destination.isEmpty) {
      setState(() {
        _error = 'Enter withdrawal destination';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _walletService.withdraw(
        amount: amount,
        destination: destination,
      );

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _error = 'Withdrawal request failed';
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
      title: 'Withdraw',
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
                labelText: 'Amount',
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _destinationCtrl,
              decoration: const InputDecoration(
                labelText:
                    'Destination (Bank / Wallet)',
              ),
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Submit Withdrawal',
              loading: _loading,
              onPressed: _withdraw,
              destructive: true,
            ),
          ],
        ),
      ),
    );
  }
}
