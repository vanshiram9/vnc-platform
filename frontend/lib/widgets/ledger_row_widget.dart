// ============================================================
// VNC PLATFORM — LEDGER ROW WIDGET (FRONTEND)
// File: lib/widgets/ledger_row_widget.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../models/ledger_entry_model.dart';

/// LedgerRowWidget
/// ---------------
/// UI widget to render a single ledger entry.
/// IMPORTANT:
/// - Ledger integrity enforced by backend
/// - Frontend only displays immutable data
class LedgerRowWidget extends StatelessWidget {
  final LedgerEntryModel entry;

  const LedgerRowWidget({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final bool isNegative =
        entry.type == 'WITHDRAW' ||
        entry.type == 'DEBIT';

    return ListTile(
      leading: Icon(
        isNegative ? Icons.remove : Icons.add,
        color: isNegative ? Colors.red : Colors.green,
      ),
      title: Text(entry.note.isNotEmpty
          ? entry.note
          : entry.type),
      subtitle: Text(
        _formatDate(entry.createdAt),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Text(
        _formatAmount(entry.amount, isNegative),
        style: TextStyle(
          color: isNegative ? Colors.red : Colors.green,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /* ---------------------------------------------------------- */
  /* INTERNAL HELPERS                                           */
  /* ---------------------------------------------------------- */

  String _formatAmount(num amount, bool negative) {
    final value = amount.toStringAsFixed(2);
    return negative ? '-$value' : '+$value';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_two(date.month)}-${_two(date.day)} '
        '${_two(date.hour)}:${_two(date.minute)}';
  }

  String _two(int n) => n < 10 ? '0$n' : '$n';
}
