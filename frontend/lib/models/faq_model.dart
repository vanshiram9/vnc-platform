// ============================================================
// VNC PLATFORM — FAQ MODEL (FRONTEND)
// File: lib/models/faq_model.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/// FaqModel
/// --------
/// Immutable frontend representation of a FAQ item.
/// IMPORTANT:
/// - FAQ content controlled by backend/admin
/// - Frontend only renders data
class FaqModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime updatedAt;

  const FaqModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.updatedAt,
  });

  /* ---------------------------------------------------------- */
  /* FACTORY                                                    */
  /* ---------------------------------------------------------- */

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    final String id = json['id']?.toString() ?? '';
    final String title = json['title']?.toString() ?? '';
    final String content = json['content']?.toString() ?? '';
    final String category = json['category']?.toString() ?? 'GENERAL';

    final DateTime updatedAt =
        DateTime.tryParse(
              json['updatedAt']?.toString() ?? '',
            ) ??
            DateTime.fromMillisecondsSinceEpoch(0);

    return FaqModel(
      id: id,
      title: title,
      content: content,
      category: category,
      updatedAt: updatedAt,
    );
  }
}
