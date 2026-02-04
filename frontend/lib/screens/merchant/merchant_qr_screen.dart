// ============================================================
// VNC PLATFORM — MERCHANT QR SCREEN
// File: lib/screens/merchant/merchant_qr_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/merchant_service.dart';

/// MerchantQrScreen
/// ----------------
/// Displays merchant payment QR.
/// IMPORTANT:
/// - QR data generated & signed by backend
/// - Frontend only renders QR string / image
class MerchantQrScreen extends StatefulWidget {
  const MerchantQrScreen({super.key});

  @override
  State<MerchantQrScreen> createState() =>
      _MerchantQrScreenState();
}

class _MerchantQrScreenState
    extends State<MerchantQrScreen> {
  bool _loading = true;
  String? _qrData;

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
      final data =
          await _merchantService.getMerchantQr();
      setState(() {
        _qrData = data;
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
      title: 'Merchant QR',
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _qrData == null
              ? const EmptyStateWidget(
                  title: 'QR Unavailable',
                  message:
                      'Merchant QR is not available.',
                )
              : Padding(
                  padding:
                      const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Scan to Pay',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Container(
                        padding:
                            const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: SelectableText(
                          _qrData!,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'This QR is generated securely by the system.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
    );
  }
}
