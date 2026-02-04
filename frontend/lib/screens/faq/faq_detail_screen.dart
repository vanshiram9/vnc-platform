// ============================================================
// VNC PLATFORM — FAQ DETAIL SCREEN
// File: lib/screens/faq/faq_detail_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';

/// FaqDetailScreen
/// ---------------
/// Displays single FAQ detail.
/// IMPORTANT:
/// - Frontend does NOT modify FAQ content
/// - Backend controls FAQ text & visibility
class FaqDetailScreen extends StatelessWidget {
  const FaqDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments;

    final faq = args is Map<String, dynamic>
        ? args
        : <String, dynamic>{};

    final question =
        faq['question']?.toString() ?? '';
    final answer =
        faq['answer']?.toString() ?? '';

    return AppScaffold(
      title: 'FAQ',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              answer,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
