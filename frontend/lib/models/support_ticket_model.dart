// ============================================================
// VNC PLATFORM — SUPPORT TICKET MODEL (FRONTEND)
// File: lib/models/support_ticket_model.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/// SupportTicketModel
/// ------------------
/// Immutable frontend representation of a support ticket.
/// IMPORTANT:
/// - Ticket lifecycle, SLA, escalation handled by backend
/// - Frontend only displays ticket state
class SupportTicketModel {
  final String id;
  final String subject;
  final String message;
  final String status; // OPEN | IN_PROGRESS | RESOLVED | CLOSED
  final DateTime createdAt;
  final DateTime? updatedAt;

  const SupportTicketModel({
    required this.id,
    required this.subject,
    required this.message,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  /* ---------------------------------------------------------- */
  /* FACTORY                                                    */
  /* ---------------------------------------------------------- */

  factory SupportTicketModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final String id = json['id']?.toString() ?? '';
    final String subject = json['subject']?.toString() ?? '';
    final String message = json['message']?.toString() ?? '';
    final String status = json['status']?.toString() ?? 'UNKNOWN';

    final DateTime createdAt =
        DateTime.tryParse(
              json['createdAt']?.toString() ?? '',
            ) ??
            DateTime.fromMillisecondsSinceEpoch(0);

    final DateTime? updatedAt =
        DateTime.tryParse(json['updatedAt']?.toString() ?? '');

    return SupportTicketModel(
      id: id,
      subject: subject,
      message: message,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
