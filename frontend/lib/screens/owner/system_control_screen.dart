// ============================================================
// VNC PLATFORM — SYSTEM CONTROL SCREEN
// File: lib/screens/owner/system_control_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/owner_service.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_dialog.dart';
import '../../widgets/app_loader.dart';
import '../../core/role.types.dart';

class SystemControlScreen extends StatefulWidget {
  const SystemControlScreen({super.key});

  @override
  State<SystemControlScreen> createState() =>
      _SystemControlScreenState();
}

class _SystemControlScreenState
    extends State<SystemControlScreen> {
  bool _loading = false;

  Future<void> _toggleMaintenance(
    BuildContext context,
    bool enable,
  ) async {
    setState(() => _loading = true);

    try {
      final ownerService =
          context.read<OwnerService>();

      if (enable) {
        await ownerService.enableMaintenance();
      } else {
        await ownerService.disableMaintenance();
      }

      if (!mounted) return;

      await AppDialog.success(
        context,
        enable
            ? 'System entered maintenance mode'
            : 'System resumed successfully',
      );
    } catch (e) {
      if (!mounted) return;

      await AppDialog.error(
        context,
        'Operation failed. Please retry.',
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<OwnerService>().role;

    if (role != RoleType.owner) {
      return const AppScaffold(
        title: 'System Control',
        body: Center(
          child: Text('Permission denied'),
        ),
      );
    }

    return AppScaffold(
      title: 'System Control',
      body: _loading
          ? const AppLoader()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Maintenance Mode',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Temporarily pause all platform '
                    'operations for upgrades or safety.',
                  ),
                  const SizedBox(height: 24),
                  AppButton.danger(
                    label: 'Enable Maintenance',
                    onPressed: () =>
                        _toggleMaintenance(context, true),
                  ),
                  const SizedBox(height: 12),
                  AppButton.primary(
                    label: 'Disable Maintenance',
                    onPressed: () =>
                        _toggleMaintenance(context, false),
                  ),
                ],
              ),
            ),
    );
  }
}
