// ============================================================
// VNC PLATFORM — IMPORT / EXPORT DASHBOARD
// File: lib/screens/import_export/ie_dashboard_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/app_button.dart';
import '../../widgets/empty_state_widget.dart';
import '../../routing/route_names.dart';
import '../../services/import_export_service.dart';

/// IEDashboardScreen
/// -----------------
/// Entry dashboard for Import / Export module.
/// IMPORTANT:
/// - No contract execution
/// - No escrow control
/// - Backend enforces compliance & settlement
class IEDashboardScreen extends StatefulWidget {
  const IEDashboardScreen({super.key});

  @override
  State<IEDashboardScreen> createState() =>
      _IEDashboardScreenState();
}

class _IEDashboardScreenState
    extends State<IEDashboardScreen> {
  bool _loading = true;
  bool _enabled = false;

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
      final enabled =
          await _ieService.isEnabled();
      setState(() {
        _enabled = enabled;
      });
    } catch (_) {
      _enabled = false;
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Import / Export',
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : !_enabled
              ? const EmptyStateWidget(
                  title: 'Unavailable',
                  message:
                      'Import / Export services are not enabled for your account.',
                )
              : Padding(
                  padding:
                      const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Trade Globally with Compliance',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      AppButton(
                        label: 'Create Contract',
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(
                            RouteNames.ieCreateContract,
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      AppButton(
                        label: 'Escrow Status',
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(
                            RouteNames.ieEscrowStatus,
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      AppButton(
                        label: 'Compliance',
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(
                            RouteNames.ieCompliance,
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
