// ============================================================
// VNC PLATFORM — OWNER COUNTRY RULE SCREEN
// File: lib/screens/owner/country_rule_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/owner_service.dart';

/// CountryRuleScreen
/// -----------------
/// Displays country-based operational rules.
/// IMPORTANT:
/// - Frontend does NOT modify country rules
/// - Backend + regulator engine enforce geo-compliance
class CountryRuleScreen extends StatefulWidget {
  const CountryRuleScreen({super.key});

  @override
  State<CountryRuleScreen> createState() =>
      _CountryRuleScreenState();
}

class _CountryRuleScreenState
    extends State<CountryRuleScreen> {
  bool _loading = true;
  List<dynamic> _rules = [];

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
          await _ownerService.getCountryRules();
      setState(() {
        _rules = items;
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
      title: 'Country Rules',
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _rules.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Country Rules',
                  message:
                      'No country-specific rules are configured.',
                )
              : ListView.separated(
                  itemCount: _rules.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final r =
                        _rules[index] as Map<String, dynamic>;
                    return ListTile(
                      leading: const Icon(
                        Icons.public,
                        color: Colors.blueGrey,
                      ),
                      title: Text(
                        r['country']?.toString() ??
                            'Country',
                      ),
                      subtitle: Text(
                        r['description']?.toString() ??
                            '',
                      ),
                      trailing: Text(
                        r['status']?.toString() ??
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
