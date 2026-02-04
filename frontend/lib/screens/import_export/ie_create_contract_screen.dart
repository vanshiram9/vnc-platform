// ============================================================
// VNC PLATFORM — IE CREATE CONTRACT SCREEN
// File: lib/screens/import_export/ie_create_contract_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/app_button.dart';
import '../../widgets/error_banner.dart';
import '../../services/import_export_service.dart';

/// IECreateContractScreen
/// ----------------------
/// UI for initiating an Import / Export contract.
/// IMPORTANT:
/// - Frontend only collects contract intent
/// - Compliance, escrow & approval handled by backend
class IECreateContractScreen extends StatefulWidget {
  const IECreateContractScreen({super.key});

  @override
  State<IECreateContractScreen> createState() =>
      _IECreateContractScreenState();
}

class _IECreateContractScreenState
    extends State<IECreateContractScreen> {
  final TextEditingController _counterpartyCtrl =
      TextEditingController();
  final TextEditingController _goodsCtrl =
      TextEditingController();
  final TextEditingController _valueCtrl =
      TextEditingController();

  bool _loading = false;
  String? _error;

  late final ImportExportService _ieService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ieService =
        ImportExportService.of(context);
  }

  Future<void> _submit() async {
    final counterparty =
        _counterpartyCtrl.text.trim();
    final goods = _goodsCtrl.text.trim();
    final value =
        num.tryParse(_valueCtrl.text.trim());

    if (counterparty.isEmpty ||
        goods.isEmpty ||
        value == null ||
        value <= 0) {
      setState(() {
        _error = 'Enter valid contract details';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _ieService.createContract(
        counterparty: counterparty,
        goods: goods,
        value: value,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _error = 'Contract creation failed';
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
      title: 'Create Contract',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (_error != null)
              ErrorBanner(message: _error!),
            const SizedBox(height: 12),

            TextField(
              controller: _counterpartyCtrl,
              decoration: const InputDecoration(
                labelText: 'Counterparty',
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _goodsCtrl,
              decoration: const InputDecoration(
                labelText: 'Goods / Services',
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _valueCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Contract Value',
              ),
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Submit Contract',
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
