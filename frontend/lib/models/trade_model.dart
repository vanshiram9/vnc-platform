// ============================================================
// VNC PLATFORM — TRADE MODEL (FRONTEND)
// File: lib/models/trade_model.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

/// TradeModel
/// ----------
/// Immutable frontend representation of a trade/order.
/// IMPORTANT:
/// - Trade execution, matching, settlement handled by backend
/// - Frontend only displays state
class TradeModel {
  final String id;
  final String type; // BUY | SELL
  final String asset;
  final num amount;
  final num price;
  final String status; // OPEN | MATCHED | SETTLED | CANCELLED
  final DateTime createdAt;

  const TradeModel({
    required this.id,
    required this.type,
    required this.asset,
    required this.amount,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  /* ---------------------------------------------------------- */
  /* FACTORY                                                    */
  /* ---------------------------------------------------------- */

  factory TradeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final String id =
        json['id']?.toString() ?? '';

    final String type =
        json['type']?.toString() ?? 'UNKNOWN';

    final String asset =
        json['asset']?.toString() ?? '';

    final num amount =
        json['amount'] is num
            ? json['amount'] as num
            : 0;

    final num price =
        json['price'] is num
            ? json['price'] as num
            : 0;

    final String status =
        json['status']?.toString() ?? 'UNKNOWN';

    final DateTime createdAt =
        DateTime.tryParse(
              json['createdAt']?.toString() ?? '',
            ) ??
            DateTime.fromMillisecondsSinceEpoch(0);

    return TradeModel(
      id: id,
      type: type,
      asset: asset,
      amount: amount,
      price: price,
      status: status,
      createdAt: createdAt,
    );
  }
}
