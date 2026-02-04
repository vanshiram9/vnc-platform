// ============================================================
// VNC PLATFORM — APP DIALOG (FRONTEND)
// File: lib/widgets/app_dialog.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

/// AppDialog
/// ---------
/// Centralized dialog helper.
/// IMPORTANT:
/// - Dialog NEVER executes actions by itself
/// - Callbacks must be provided explicitly
class AppDialog {
  /* ---------------------------------------------------------- */
  /* CONFIRM DIALOG                                             */
  /* ---------------------------------------------------------- */

  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool destructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  destructive ? Colors.red : null,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /* ---------------------------------------------------------- */
  /* INFO DIALOG                                                */
  /* ---------------------------------------------------------- */

  static Future<void> info(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
