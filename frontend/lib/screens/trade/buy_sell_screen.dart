// ============================================================
// VNC PLATFORM — BUY / SELL SCREEN
// File: lib/screens/trade/buy_sell_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/app_button.dart';
import '../../widgets/error_banner.dart';
import '../../services/trade_service.dart';

/// BuySellScreen
/// -------------
/// UI for creating buy/sell trade orders.
/// IMPORTANT:
/// - Frontend only sends trade intent
/// - Validation, escrow, matching handled by backend
class BuySellScreen extends StatefulWidget {
  const BuySellScreen({super.key});

  @override
  State<BuySellScreen> createState() =>
      _BuySellScreenState();
}

class _BuySellScreenState extends State<BuySellScreen> {
  final TextEditingController _assetCtrl =
      TextEditingController();
  final TextEditingController _amountCtrl =
      TextEditingController();
  final TextEditingController _priceCtrl =
      TextEditingController();

  String _type = 'BUY';
  bool _loading = false;
  String? _error;

  late final TradeService _tradeService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tradeService =
        TradeService.of(context);
  }

  Future<void> _submit() async {
    final asset = _assetCtrl.text.trim();
    final amount =
        num.tryParse(_amountCtrl.text.trim());
    final price =
        num.tryParse(_priceCtrl.text.trim());

    if (asset.isEmpty ||
        amount == null ||
        amount <= 0 ||
        price == null ||
        price <= 0) {
      setState(() {
        _error = 'Enter valid trade details';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _tradeService.createTrade(
        type: _type,
        asset: asset,
        amount: amount,
        price: price,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _error = 'Trade request failed';
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
      title: 'Buy / Sell',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (_error != null)
              ErrorBanner(message: _error!),
            const SizedBox(height: 12),

            DropdownButton<String>(
              value: _type,
              items: const [
                DropdownMenuItem(
                  value: 'BUY',
                  child: Text('Buy'),
                ),
                DropdownMenuItem(
                  value: 'SELL',
                  child: Text('Sell'),
                ),
              ],
              onChanged: (v) {
                if (v != null) {
                  setState(() => _type = v);
                }
              },
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _assetCtrl,
              decoration: const InputDecoration(
                labelText: 'Asset',
              ),
            ),
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
              controller: _priceCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Price',
              ),
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Submit Trade',
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
