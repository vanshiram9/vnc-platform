// ============================================================
// VNC PLATFORM — QR SCANNER WIDGET (FRONTEND)
// File: lib/widgets/qr_scanner_widget.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

/// QrScannerWidget
/// ---------------
/// Placeholder-safe QR scanner wrapper.
/// IMPORTANT:
/// - This widget ONLY returns scanned raw data
/// - It does NOT parse, validate, or execute anything
/// - Backend or caller logic must decide next steps
///
/// NOTE:
/// - Actual camera/QR plugin integration is intentionally
///   abstracted to keep security surface minimal.
/// - Replace scanner implementation internally if needed
///   WITHOUT changing the public interface.
class QrScannerWidget extends StatelessWidget {
  final void Function(String data) onScanned;
  final String title;

  const QrScannerWidget({
    super.key,
    required this.onScanned,
    this.title = 'Scan QR Code',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.qr_code_scanner,
                size: 96,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'QR scanner placeholder',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // MOCK / PLACEHOLDER SCAN
                  // Real implementation must pipe scanned string here
                  onScanned('SCANNED_QR_DATA');
                  Navigator.of(context).pop();
                },
                child: const Text('Simulate Scan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
