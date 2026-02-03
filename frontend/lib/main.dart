// ============================================================
// VNC PLATFORM — FRONTEND ENTRY POINT
// File: main.dart
// Final Master Hard-Lock Version: v6.7.0.4
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'bootstrap.dart';
import 'app.dart';

/// Global error handler (last-resort)
void _handleFlutterError(FlutterErrorDetails details) {
  FlutterError.presentError(details);
  // In production, this can be extended to send logs
}

/// Application entry point
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Catch synchronous Flutter errors
  FlutterError.onError = _handleFlutterError;

  // Catch async / zone errors
  runZonedGuarded<Future<void>>(() async {
    // Bootstrap initializes env, services, guards
    await bootstrapApplication();

    // Start the app
    runApp(const VNCApp());
  }, (Object error, StackTrace stack) {
    // Hard fail-safe: log and stop
    debugPrint('UNCAUGHT ERROR: $error');
    debugPrint('$stack');
  });
}
