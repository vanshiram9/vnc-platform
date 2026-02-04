// ============================================================
// VNC PLATFORM — KYC REVIEW SCREEN
// File: lib/screens/admin/kyc_review_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/admin_service.dart';

/// KycReviewScreen
/// ---------------
/// Displays pending KYC applications for admin review.
/// IMPORTANT:
/// - Frontend does NOT approve/reject KYC
/// - Frontend does NOT validate documents
/// - Backend enforces compliance, audit & decisions
class KycReviewScreen extends StatefulWidget {
  const KycReviewScreen({super.key});

  @override
  State<KycReviewScreen> createState() =>
      _KycReviewScreenState();
}

class _KycReviewScreenState
    extends State<KycReviewScreen> {
  bool _loading = true;
  List<dynamic> _items = [];

  late final AdminService _adminService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _adminService = AdminService.of(context);
    _load();
  }

  Future<void> _load() async {
    try {
      final items =
          await _adminService.getPendingKyc();
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
      title: 'KYC Review',
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _items.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Pending KYC',
                  message:
                      'There are no KYC applications awaiting review.',
                )
              : ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final k =
                        _items[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        k['user']?.toString() ??
                            'User',
                      ),
                      subtitle: Text(
                        'Submitted: ${k['submittedAt']}',
                      ),
                      trailing: Text(
                        k['status']?.toString() ??
                            'PENDING',
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
