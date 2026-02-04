// ============================================================
// VNC PLATFORM — MINING HISTORY SCREEN
// File: lib/screens/mining/mining_history_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/mining_service.dart';

/// MiningHistoryScreen
/// -------------------
/// Displays mining reward history.
/// IMPORTANT:
/// - Frontend does NOT calculate rewards
/// - Backend provides immutable history
class MiningHistoryScreen extends StatefulWidget {
  const MiningHistoryScreen({super.key});

  @override
  State<MiningHistoryScreen> createState() =>
      _MiningHistoryScreenState();
}

class _MiningHistoryScreenState
    extends State<MiningHistoryScreen> {
  bool _loading = true;
  List<dynamic> _items = [];

  late final MiningService _miningService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _miningService =
        MiningService.of(context);
    _load();
  }

  Future<void> _load() async {
    try {
      final items =
          await _miningService.getMiningHistory();
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
      title: 'Mining History',
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _items.isEmpty
              ? const EmptyStateWidget(
                  title: 'No History',
                  message:
                      'No mining activity recorded yet.',
                )
              : ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final h =
                        _items[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        h['label']?.toString() ??
                            'Mining Reward',
                      ),
                      subtitle: Text(
                        h['date']?.toString() ?? '',
                      ),
                      trailing: Text(
                        h['amount']?.toString() ?? '',
                      ),
                    );
                  },
                ),
    );
  }
}
