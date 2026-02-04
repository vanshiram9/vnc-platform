// ============================================================
// VNC PLATFORM — IMPORT / EXPORT MODEL (FRONTEND)
// File: lib/models/import_export_model.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/// ImportExportModel
/// -----------------
/// Immutable frontend representation of import/export contract.
/// IMPORTANT:
/// - LC, escrow, compliance enforced by backend
/// - Frontend only displays contract state
class ImportExportModel {
  final String id;
  final String type; // IMPORT | EXPORT
  final String status; // CREATED | ACTIVE | COMPLETED | CANCELLED
  final num value;
  final String counterparty;
  final DateTime createdAt;

  const ImportExportModel({
    required this.id,
    required this.type,
    required this.status,
    required this.value,
    required this.counterparty,
    required this.createdAt,
  });

  /* ---------------------------------------------------------- */
  /* FACTORY                                                    */
  /* ---------------------------------------------------------- */

  factory ImportExportModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final String id =
        json['id']?.toString() ?? '';

    final String type =
        json['type']?.toString() ?? 'UNKNOWN';

    final String status =
        json['status']?.toString() ?? 'UNKNOWN';

    final num value =
        json['value'] is num
            ? json['value'] as num
            : 0;

    final String counterparty =
        json['counterparty']?.toString() ?? '';

    final DateTime createdAt =
        DateTime.tryParse(
              json['createdAt']?.toString() ?? '',
            ) ??
            DateTime.fromMillisecondsSinceEpoch(0);

    return ImportExportModel(
      id: id,
      type: type,
      status: status,
      value: value,
      counterparty: counterparty,
      createdAt: createdAt,
    );
  }
}
