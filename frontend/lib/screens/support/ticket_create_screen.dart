// ============================================================
// VNC PLATFORM — SUPPORT TICKET CREATE SCREEN
// File: lib/screens/support/ticket_create_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/app_button.dart';
import '../../widgets/error_banner.dart';
import '../../services/support_service.dart';

/// TicketCreateScreen
/// ------------------
/// UI for creating a new support ticket.
/// IMPORTANT:
/// - Frontend only submits ticket intent
/// - Priority, routing & resolution handled by backend
class TicketCreateScreen extends StatefulWidget {
  const TicketCreateScreen({super.key});

  @override
  State<TicketCreateScreen> createState() =>
      _TicketCreateScreenState();
}

class _TicketCreateScreenState
    extends State<TicketCreateScreen> {
  final TextEditingController _subjectCtrl =
      TextEditingController();
  final TextEditingController _messageCtrl =
      TextEditingController();

  bool _loading = false;
  String? _error;

  late final SupportService _supportService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supportService =
        SupportService.of(context);
  }

  Future<void> _submit() async {
    final subject = _subjectCtrl.text.trim();
    final message = _messageCtrl.text.trim();

    if (subject.isEmpty || message.isEmpty) {
      setState(() {
        _error = 'Please fill all fields';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _supportService.createTicket(
        subject: subject,
        message: message,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _error = 'Unable to create ticket';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Create Ticket',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (_error != null)
              ErrorBanner(message: _error!),
            const SizedBox(height: 12),

            TextField(
              controller: _subjectCtrl,
              decoration: const InputDecoration(
                labelText: 'Subject',
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _messageCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Message',
              ),
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Submit Ticket',
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
