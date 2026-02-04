// ============================================================
// VNC PLATFORM — IE ESCROW STATUS SCREEN
// File: lib/screens/import_export/ie_escrow_status_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/import_export_service.dart';

/// IEEscrowStatusScreen
/// -------------------
/// Displays Import / Export escrow (LC) status.
/// IMPORTANT:
/// - Frontend does NOT release escrow
/// - Frontend does NOT alter contract state
/// - Backend enforces LC, escrow & settlement
class IEEscrowStatusScreen extends StatefulWidget {
  const IEEscrowStatusScreen({super.key});

  @override
  State<IEEscrowStatusScreen> createState() =>
      _IEEscrowStatusScreenState();
}

class _IEEscrowStatusScreenState
    extends State<IEEscrowStatusScreen> {
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
          await _ieService.getEscrowStatuses();
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
      title: 'IE Escrow Status',
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _items.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Escrow Records',
                  message:
                      'No active or past escrow records found.',
                )
              : ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final e =
                        _items[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        e['contract']?.toString() ??
                            'IE Contract',
                      ),
                      subtitle: Text(
                        'Value: ${e['value']} | Counterparty: ${e['counterparty']}',
                      ),
                      trailing: Text(
                        e['status']?.toString() ??
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
