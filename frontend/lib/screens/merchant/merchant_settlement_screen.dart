// ============================================================
// VNC PLATFORM — MERCHANT SETTLEMENT SCREEN
// File: lib/screens/merchant/merchant_settlement_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/merchant_service.dart';

/// MerchantSettlementScreen
/// ------------------------
/// Displays merchant settlement summary & history.
/// IMPORTANT:
/// - Frontend does NOT trigger settlement
/// - Backend executes payouts & reconciliation
class MerchantSettlementScreen extends StatefulWidget {
  const MerchantSettlementScreen({super.key});

  @override
  State<MerchantSettlementScreen> createState() =>
      _MerchantSettlementScreenState();
}

class _MerchantSettlementScreenState
    extends State<MerchantSettlementScreen> {
  bool _loading = true;
  List<dynamic> _items = [];

  late final MerchantService _merchantService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _merchantService =
        MerchantService.of(context);
    _load();
  }

  Future<void> _load() async {
    try {
      final items =
          await _merchantService.getSettlements();
      setState(() {
        _items = items;
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
      title: 'Settlement',
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _items.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Settlements',
                  message:
                      'No settlement records found.',
                )
              : ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final s =
                        _items[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        s['period']?.toString() ??
                            'Settlement',
                      ),
                      subtitle: Text(
                        'Amount: ${s['amount']}',
                      ),
                      trailing: Text(
                        s['status']?.toString() ??
                            '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
