// ============================================================
// VNC PLATFORM — SUPPORT TICKET STATUS SCREEN
// File: lib/screens/support/ticket_status_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/support_service.dart';

/// TicketStatusScreen
/// ------------------
/// Displays user's support tickets and their current status.
/// IMPORTANT:
/// - Frontend does NOT update ticket state
/// - Backend controls ticket lifecycle & resolution
class TicketStatusScreen extends StatefulWidget {
  const TicketStatusScreen({super.key});

  @override
  State<TicketStatusScreen> createState() =>
      _TicketStatusScreenState();
}

class _TicketStatusScreenState
    extends State<TicketStatusScreen> {
  bool _loading = true;
  List<dynamic> _tickets = [];

  late final SupportService _supportService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supportService =
        SupportService.of(context);
    _load();
  }

  Future<void> _load() async {
    try {
      final items =
          await _supportService.getMyTickets();
      setState(() {
        _tickets = items;
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
      title: 'Ticket Status',
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _tickets.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Tickets',
                  message:
                      'You have not created any support tickets.',
                )
              : ListView.separated(
                  itemCount: _tickets.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final t =
                        _tickets[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        t['subject']?.toString() ??
                            'Support Ticket',
                      ),
                      subtitle: Text(
                        'Status: ${t['status']}',
                      ),
                      trailing: Text(
                        t['updatedAt']?.toString() ??
                            '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
