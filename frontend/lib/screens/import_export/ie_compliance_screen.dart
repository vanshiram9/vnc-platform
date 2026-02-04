// ============================================================
// VNC PLATFORM — IE COMPLIANCE SCREEN
// File: lib/screens/import_export/ie_compliance_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/import_export_service.dart';

/// IEComplianceScreen
/// ------------------
/// Displays Import / Export compliance notices and requirements.
/// IMPORTANT:
/// - Frontend does NOT validate compliance
/// - Frontend does NOT submit regulator responses
/// - Backend + regulator decide compliance outcome
class IEComplianceScreen extends StatefulWidget {
  const IEComplianceScreen({super.key});

  @override
  State<IEComplianceScreen> createState() =>
      _IEComplianceScreenState();
}

class _IEComplianceScreenState
    extends State<IEComplianceScreen> {
  bool _loading = true;
  List<dynamic> _items = [];

  late final ImportExportService _ieService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ieService =
        ImportExportService.of(context);
    _load();
  }

  Future<void> _load() async {
    try {
      final items =
          await _ieService.getComplianceNotices();
      setState(() {
        _items = items;
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
      title: 'Compliance',
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _items.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Compliance Notices',
                  message:
                      'No compliance requirements at this time.',
                )
              : ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final c =
                        _items[index] as Map<String, dynamic>;
                    return ListTile(
                      leading: const Icon(
                        Icons.gavel,
                        color: Colors.blueGrey,
                      ),
                      title: Text(
                        c['title']?.toString() ??
                            'Compliance Notice',
                      ),
                      subtitle: Text(
                        c['message']?.toString() ?? '',
                      ),
                      trailing: Text(
                        c['status']?.toString() ??
                            '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
