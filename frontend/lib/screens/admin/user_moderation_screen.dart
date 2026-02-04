// ============================================================
// VNC PLATFORM — USER MODERATION SCREEN
// File: lib/screens/admin/user_moderation_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/admin_service.dart';

/// UserModerationScreen
/// --------------------
/// Displays users for moderation review.
/// IMPORTANT:
/// - Frontend does NOT freeze/unfreeze users
/// - Frontend does NOT change roles
/// - Backend enforces moderation + audit
class UserModerationScreen extends StatefulWidget {
  const UserModerationScreen({super.key});

  @override
  State<UserModerationScreen> createState() =>
      _UserModerationScreenState();
}

class _UserModerationScreenState
    extends State<UserModerationScreen> {
  bool _loading = true;
  List<dynamic> _users = [];

  late final AdminService _adminService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _adminService = AdminService.of(context);
    _load();
  }

  Future<void> _load() async {
    try {
      final users = await _adminService.getUsers();
      setState(() {
        _users = users;
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
      title: 'User Moderation',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Users',
                  message: 'No users available for review.',
                )
              : ListView.separated(
                  itemCount: _users.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final u =
                        _users[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        u['identifier']?.toString() ??
                            'User',
                      ),
                      subtitle: Text(
                        'Status: ${u['status']}',
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                    );
                  },
                ),
    );
  }
}
