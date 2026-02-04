// ============================================================
// VNC PLATFORM — MERCHANT KYC SCREEN
// File: lib/screens/merchant/merchant_kyc_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/app_button.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/merchant_service.dart';

/// MerchantKycScreen
/// -----------------
/// Displays merchant KYC status and submission intent.
/// IMPORTANT:
/// - Frontend does NOT validate KYC documents
/// - Frontend does NOT approve/reject KYC
/// - Backend + compliance engine decide everything
class MerchantKycScreen extends StatefulWidget {
  const MerchantKycScreen({super.key});

  @override
  State<MerchantKycScreen> createState() =>
      _MerchantKycScreenState();
}

class _MerchantKycScreenState
    extends State<MerchantKycScreen> {
  bool _loading = true;
  Map<String, dynamic>? _kyc;

  late final MerchantService _merchantService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _merchantService =
        MerchantService.of(context);
    _load();
  }

  Future<void> _load() async {
    try {
      final kyc =
          await _merchantService.getKycStatus();
      setState(() {
        _kyc = kyc;
      });
    } catch (_) {
      // silent fail
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _submitKyc() async {
    try {
      await _merchantService.submitKyc();
      _load();
    } catch (_) {
      // silent fail
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Merchant KYC',
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _kyc == null
              ? const EmptyStateWidget(
                  title: 'KYC Not Available',
                  message:
                      'Merchant KYC is not enabled.',
                )
              : Padding(
                  padding:
                      const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status: ${_kyc!['status']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _kyc!['message']?.toString() ??
                            '',
                      ),
                      const SizedBox(height: 24),

                      if (_kyc!['canSubmit'] ==
                          true)
                        AppButton(
                          label: 'Submit / Update KYC',
                          onPressed: _submitKyc,
                        ),
                    ],
                  ),
                ),
    );
  }
}
