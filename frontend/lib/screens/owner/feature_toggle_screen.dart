// ============================================================
// VNC PLATFORM — OWNER FEATURE TOGGLE SCREEN
// File: lib/screens/owner/feature_toggle_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/owner_service.dart';

/// FeatureToggleScreen
/// -------------------
/// Displays platform feature flags for owner visibility.
/// IMPORTANT:
/// - Frontend does NOT enable/disable features
/// - Backend enforces feature state, rollout & audit
class FeatureToggleScreen extends StatefulWidget {
  const FeatureToggleScreen({super.key});

  @override
  State<FeatureToggleScreen> createState() =>
      _FeatureToggleScreenState();
}

class _FeatureToggleScreenState
    extends State<FeatureToggleScreen> {
  bool _loading = true;
  List<dynamic> _features = [];

  late final OwnerService _ownerService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ownerService = OwnerService.of(context);
    _load();
  }

  Future<void> _load() async {
    try {
      final items =
          await _ownerService.getFeatureFlags();
      setState(() {
        _features = items;
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
      title: 'Feature Toggles',
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _features.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Features',
                  message:
                      'No feature flags available.',
                )
              : ListView.separated(
                  itemCount: _features.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final f =
                        _features[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        f['name']?.toString() ??
                            'Feature',
                      ),
                      subtitle: Text(
                        f['description']?.toString() ??
                            '',
                      ),
                      trailing: Icon(
                        f['enabled'] == true
                            ? Icons.toggle_on
                            : Icons.toggle_off,
                        color: f['enabled'] == true
                            ? Colors.green
                            : Colors.grey,
                        size: 32,
                      ),
                    );
                  },
                ),
    );
  }
}
