// ============================================================
// VNC PLATFORM — AUDIT LOG SCREEN
// File: lib/screens/admin/audit_log_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/admin_service.dart';

/// AuditLogScreen
/// --------------
/// Displays immutable audit logs for admin & compliance.
/// IMPORTANT:
/// - Frontend does NOT modify logs
/// - Frontend does NOT hide entries
/// - Backend enforces immutability & forensic integrity
class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({super.key});

  @override
  State<AuditLogScreen> createState() =>
      _AuditLogScreenState();
}

class _AuditLogScreenState
    extends State<AuditLogScreen> {
  bool _loading = true;
  List<dynamic> _logs = [];

  late final AdminService _adminService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _adminService = AdminService.of(context);
    _load();
  }

  Future<void> _load() async {
    try {
      final items =
          await _adminService.getAuditLogs();
      setState(() {
        _logs = items;
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
      title: 'Audit Logs',
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _logs.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Logs',
                  message:
                      'No audit logs available.',
                )
              : ListView.separated(
                  itemCount: _logs.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final l =
                        _logs[index] as Map<String, dynamic>;
                    return ListTile(
                      leading: const Icon(
                        Icons.security,
                        color: Colors.blueGrey,
                      ),
                      title: Text(
                        l['event']?.toString() ??
                            'Audit Event',
                      ),
                      subtitle: Text(
                        l['actor']?.toString() ??
                            '',
                      ),
                      trailing: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.end,
                        children: [
                          Text(
                            l['timestamp']?.toString() ??
                                '',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            l['hash']?.toString() ?? '',
                            style: const TextStyle(
                              fontSize: 10,
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
