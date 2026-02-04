// ============================================================
// VNC PLATFORM — FAQ SCREEN
// File: lib/screens/faq/faq_screen.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/faq_service.dart';
import '../../routing/route_names.dart';

/// FaqScreen
/// ---------
/// Displays list of FAQs.
/// IMPORTANT:
/// - Frontend does NOT modify FAQ content
/// - Backend controls FAQ visibility & ordering
class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  bool _loading = true;
  List<dynamic> _faqs = [];

  late final FaqService _faqService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _faqService = FaqService.of(context);
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await _faqService.getFaqs();
      setState(() {
        _faqs = items;
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
      title: 'FAQs',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _faqs.isEmpty
              ? const EmptyStateWidget(
                  title: 'No FAQs',
                  message: 'No frequently asked questions available.',
                )
              : ListView.separated(
                  itemCount: _faqs.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final f =
                        _faqs[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        f['question']?.toString() ?? '',
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          RouteNames.faqDetail,
                          arguments: f,
                        );
                      },
                    );
                  },
                ),
    );
  }
}
