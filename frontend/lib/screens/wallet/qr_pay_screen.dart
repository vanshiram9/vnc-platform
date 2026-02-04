// ============================================================
// VNC PLATFORM — QR PAY SCREEN
// File: lib/screens/wallet/qr_pay_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/qr_scanner_widget.dart';
import '../../widgets/error_banner.dart';
import '../../services/wallet_service.dart';

/// QrPayScreen
/// -----------
/// QR-based payment initiation.
/// IMPORTANT:
/// - Frontend ONLY scans QR and forwards raw data
/// - No parsing, no validation, no execution
/// - Backend fully validates & executes payment
class QrPayScreen extends StatefulWidget {
  const QrPayScreen({super.key});

  @override
  State<QrPayScreen> createState() =>
      _QrPayScreenState();
}

class _QrPayScreenState extends State<QrPayScreen> {
  bool _loading = false;
  String? _error;

  late final WalletService _walletService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _walletService =
        WalletService.of(context);
  }

  Future<void> _onQrScanned(String data) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _walletService.qrPay(
        rawQrData: data,
      );

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _error = 'QR payment failed';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'QR Pay',
      body: Column(
        children: [
          if (_error != null)
            Padding(
              padding:
                  const EdgeInsets.all(12),
              child: ErrorBanner(
                message: _error!,
              ),
            ),

          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                QrScannerWidget(
                  title: 'Scan Payment QR',
                  onScanned: _onQrScanned,
                ),
                if (_loading)
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
