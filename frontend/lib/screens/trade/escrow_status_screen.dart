// ============================================================
// VNC PLATFORM — ESCROW STATUS SCREEN
// File: lib/screens/trade/escrow_status_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/trade_service.dart';

/// EscrowStatusScreen
/// ------------------
/// Displays escrow / settlement status for trades.
/// IMPORTANT:
/// - Frontend does NOT release escrow
/// - Frontend does NOT change settlement state
/// - Backend enforces escrow lifecycle
class EscrowStatusScreen extends StatefulWidget {
  const EscrowStatusScreen({super.key});

  @override
  State<EscrowStatusScreen> createState() =>
      _EscrowStatusScreenState();
}

class _EscrowStatusScreenState
    extends State<EscrowStatusScreen> {
  bool _loading = true;
  List<dynamic> _items = [];

  late final TradeService _tradeService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tradeService =
        TradeService.of(context);
    _load();
  }

  Future<void> _load() async {
    try {
      final items =
          await _tradeService.getEscrowStatuses();
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
      title: 'Escrow Status',
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _items.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Escrow Records',
                  message:
                      'No active or past escrow records found.',
                )
              : ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final e =
                        _items[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        e['asset']?.toString() ??
                            'Trade',
                      ),
                      subtitle: Text(
                        'Amount: ${e['amount']} | Type: ${e['type']}',
                      ),
                      trailing: Text(
                        e['status']?.toString() ??
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
