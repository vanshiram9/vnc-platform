// ============================================================
// VNC PLATFORM — ORDER HISTORY SCREEN
// File: lib/screens/trade/order_history_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/trade_service.dart';

/// OrderHistoryScreen
/// ------------------
/// Displays user's trade order history.
/// IMPORTANT:
/// - Orders are immutable on frontend
/// - Backend decides order state & lifecycle
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() =>
      _OrderHistoryScreenState();
}

class _OrderHistoryScreenState
    extends State<OrderHistoryScreen> {
  bool _loading = true;
  List<dynamic> _orders = [];

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
      final orders =
          await _tradeService.getOrders();
      setState(() {
        _orders = orders;
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
      title: 'Order History',
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _orders.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Orders',
                  message:
                      'You have not placed any trades yet.',
                )
              : ListView.separated(
                  itemCount: _orders.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final o =
                        _orders[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        '${o['type']} ${o['asset']}',
                      ),
                      subtitle: Text(
                        'Amount: ${o['amount']} | Price: ${o['price']}',
                      ),
                      trailing: Text(
                        o['status']?.toString() ??
                            '',
                      ),
                    );
                  },
                ),
    );
  }
}
