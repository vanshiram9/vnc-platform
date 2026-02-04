// ============================================================
// VNC PLATFORM — FAQ SERVICE (FRONTEND)
// File: lib/services/faq_service.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'api_client.dart';

/// FaqService
/// ----------
/// Frontend FAQ read-only service.
/// IMPORTANT:
/// - FAQs are controlled by backend/admin
/// - Frontend only fetches & displays content
class FaqService {
  final ApiClient _api;

  FaqService(this._api);

  /* ---------------------------------------------------------- */
  /* LIST                                                       */
  /* ---------------------------------------------------------- */

  /// Fetch FAQ list
  ///
  /// Example backend response:
  /// {
  ///   "faqs": [
  ///     { "id": "1", "title": "What is VNC?", "category": "General" }
  ///   ]
  /// }
  Future<List<dynamic>> getFaqs() async {
    final res = await _api.get('/faq');
    final list = res['faqs'];
    if (list is List) {
      return list;
    }
    throw StateError('FAQ_LIST_INVALID');
  }

  /* ---------------------------------------------------------- */
  /* DETAIL                                                     */
  /* ---------------------------------------------------------- */

  /// Fetch FAQ detail by id
  Future<Map<String, dynamic>> getFaqDetail({
    required String faqId,
  }) async {
    final res = await _api.get(
      '/faq/detail',
      query: {'id': faqId},
    );
    if (res.isEmpty) {
      throw StateError('FAQ_DETAIL_EMPTY');
    }
    return res;
  }
}
