// ============================================================
// VNC PLATFORM — NOTIFICATION PANEL
// File: lib/screens/home/notification_panel.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../services/notification_service.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_banner.dart';

/// NotificationPanel
/// -----------------
/// Displays latest system / user notifications.
/// IMPORTANT:
/// - No filtering or prioritization on client
/// - Backend decides visibility & severity
class NotificationPanel extends StatefulWidget {
  const NotificationPanel({super.key});

  @override
  State<NotificationPanel> createState() =>
      _NotificationPanelState();
}

class _NotificationPanelState
    extends State<NotificationPanel> {
  bool _loading = true;
  String? _error;
  List<dynamic> _items = [];

  late final NotificationService _service;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _service = NotificationService.of(context);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final items = await _service.getNotifications();
      setState(() {
        _items = items;
      });
    } catch (e) {
      setState(() {
        _error = 'Unable to load notifications';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return ErrorBanner(message: _error!);
    }

    if (_items.isEmpty) {
      return const EmptyStateWidget(
        title: 'No Notifications',
        message: 'You have no notifications.',
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1),
      itemBuilder: (context, index) {
        final n = _items[index] as Map<String, dynamic>;
        return ListTile(
          title: Text(n['title']?.toString() ?? ''),
          subtitle:
              Text(n['message']?.toString() ?? ''),
        );
      },
    );
  }
}
