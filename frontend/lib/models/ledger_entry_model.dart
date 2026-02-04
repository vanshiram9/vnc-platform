// ============================================================
// VNC PLATFORM — LEDGER ENTRY MODEL (FRONTEND)
// File: lib/models/ledger_entry_model.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/// LedgerEntryModel
/// ----------------
/// Immutable frontend representation of a wallet ledger entry.
/// IMPORTANT:
/// - Ledger is append-only on backend
/// - Frontend only displays records
class LedgerEntryModel {
  final String id;
  final String type; // LOCK | WITHDRAW | CREDIT | DEBIT etc
  final num amount;
  final String note;
  final DateTime createdAt;

  const LedgerEntryModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.note,
    required this.createdAt,
  });

  /* ---------------------------------------------------------- */
  /* FACTORY                                                    */
  /* ---------------------------------------------------------- */

  factory LedgerEntryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final String id =
        json['id']?.toString() ?? '';

    final String type =
        json['type']?.toString() ?? 'UNKNOWN';

    final num amount =
        json['amount'] is num
            ? json['amount'] as num
            : 0;

    final String note =
        json['note']?.toString() ?? '';

    final DateTime createdAt =
        DateTime.tryParse(
              json['createdAt']?.toString() ?? '',
            ) ??
            DateTime.fromMillisecondsSinceEpoch(0);

    return LedgerEntryModel(
      id: id,
      type: type,
      amount: amount,
      note: note,
      createdAt: createdAt,
    );
  }
}
