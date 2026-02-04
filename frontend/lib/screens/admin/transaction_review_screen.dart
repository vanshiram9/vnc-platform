// ============================================================
// VNC PLATFORM — TRANSACTION REVIEW SCREEN
// File: lib/screens/admin/transaction_review_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/admin_service.dart';

/// TransactionReviewScreen
/// -----------------------
/// Displays financial transactions for admin audit.
/// IMPORTANT:
/// - Frontend does NOT approve/reverse transactions
/// - Frontend does NOT modify ledger
/// - Backend enforces ledger immutability & audit
class TransactionReviewScreen extends StatefulWidget {
  const TransactionReviewScreen({super.key});

  @override
  State<TransactionReviewScreen> createState() =>
      _TransactionReviewScreenState();
}

class _TransactionReviewScreenState
    extends State<TransactionReviewScreen> {
  bool _loading = true;
  List<dynamic> _items = [];

  late final AdminService _adminService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _adminService = AdminService.of(context);
    _load();
  }

  Future<void> _load() async {
    try {
      final tx =
          await _adminService.getTransactions();
      setState(() {
        _items = tx;
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
      title: 'Transaction Review',
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _items.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Transactions',
                  message:
                      'No transactions available for review.',
                )
              : ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final t =
                        _items[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        t['type']?.toString() ??
                            'Transaction',
                      ),
                      subtitle: Text(
                        'User: ${t['user']} | Amount: ${t['amount']}',
                      ),
                      trailing: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.end,
                        children: [
                          Text(
                            t['status']?.toString() ??
                                '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            t['createdAt']?.toString() ??
                                '',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
