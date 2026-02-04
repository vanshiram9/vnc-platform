// ============================================================
// VNC PLATFORM — SUPPORT SERVICE (FRONTEND)
// File: lib/services/support_service.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'api_client.dart';

/// SupportService
/// --------------
/// Frontend support ticket API bridge.
/// IMPORTANT:
/// - Ticket priority, SLA, escalation handled by backend
/// - Frontend only submits issues & displays status
class SupportService {
  final ApiClient _api;

  SupportService(this._api);

  /* ---------------------------------------------------------- */
  /* TICKETS                                                    */
  /* ---------------------------------------------------------- */

  /// Create a new support ticket
  ///
  /// Payload example:
  /// {
  ///   "subject": "Withdrawal issue",
  ///   "message": "Amount not received"
  /// }
  Future<void> createTicket({
    required String subject,
    required String message,
  }) async {
    await _api.post(
      '/support/ticket',
      data: {
        'subject': subject,
        'message': message,
      },
    );
  }

  /// Fetch all tickets for current user
  Future<List<dynamic>> getTickets() async {
    final res = await _api.get('/support/tickets');
    final list = res['tickets'];
    if (list is List) {
      return list;
    }
    throw StateError('SUPPORT_TICKETS_INVALID');
  }

  /// Fetch ticket status by id
  Future<Map<String, dynamic>> getTicketStatus({
    required String ticketId,
  }) async {
    final res = await _api.get(
      '/support/ticket/status',
      query: {'id': ticketId},
    );
    if (res.isEmpty) {
      throw StateError('SUPPORT_TICKET_EMPTY');
    }
    return res;
  }
}
