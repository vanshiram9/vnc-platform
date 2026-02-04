// ============================================================
// VNC PLATFORM — EMERGENCY KILL SCREEN
// File: lib/screens/owner/emergency_kill_screen.dart
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

class EmergencyKillScreen extends StatefulWidget {
  const EmergencyKillScreen({super.key});

  @override
  State<EmergencyKillScreen> createState() =>
      _EmergencyKillScreenState();
}

class _EmergencyKillScreenState
    extends State<EmergencyKillScreen> {
  bool _loading = false;
  final TextEditingController _reasonController =
      TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _activateKillSwitch(
    BuildContext context,
  ) async {
    final reason = _reasonController.text.trim();

    if (reason.isEmpty) {
      await AppDialog.error(
        context,
        'Reason is mandatory for emergency freeze.',
      );
      return;
    }

    final confirm = await AppDialog.confirm(
      context,
      title: 'Confirm Emergency Freeze',
      message:
          'This will immediately halt ALL platform '
          'operations.\n\nThis action cannot be undone '
          'without owner recovery.\n\nProceed?',
    );

    if (confirm != true) return;

    setState(() => _loading = true);

    try {
      final ownerService =
          context.read<OwnerService>();

      await ownerService.activateEmergencyFreeze(
        reason: reason,
      );

      if (!mounted) return;

      await AppDialog.success(
        context,
        'Emergency freeze activated successfully.',
      );

      _reasonController.clear();
    } catch (e) {
      if (!mounted) return;

      await AppDialog.error(
        context,
        'Failed to activate emergency freeze.',
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _recoverSystem(
    BuildContext context,
  ) async {
    final confirm = await AppDialog.confirm(
      context,
      title: 'Confirm System Recovery',
      message:
          'System recovery will resume platform '
          'operations.\n\nEnsure forensic review is '
          'complete before proceeding.\n\nContinue?',
    );

    if (confirm != true) return;

    setState(() => _loading = true);

    try {
      final ownerService =
          context.read<OwnerService>();

      await ownerService.recoverSystem();

      if (!mounted) return;

      await AppDialog.success(
        context,
        'System recovered successfully.',
      );
    } catch (e) {
      if (!mounted) return;

      await AppDialog.error(
        context,
        'System recovery failed.',
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
        title: 'Emergency Control',
        body: Center(
          child: Text('Permission denied'),
        ),
      );
    }

    return AppScaffold(
      title: 'Emergency Control',
      body: _loading
          ? const AppLoader()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Emergency Kill Switch',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Use ONLY in case of critical '
                    'security, financial, or regulatory '
                    'incident.',
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _reasonController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Reason (required)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton.danger(
                    label: 'ACTIVATE EMERGENCY FREEZE',
                    onPressed: () =>
                        _activateKillSwitch(context),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 12),
                  AppButton.primary(
                    label: 'Recover System',
                    onPressed: () =>
                        _recoverSystem(context),
                  ),
                ],
              ),
            ),
    );
  }
}
