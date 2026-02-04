// ============================================================
// VNC PLATFORM — NOTIFICATION SERVICE (FRONTEND)
// File: lib/services/notification_service.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'api_client.dart';

/// NotificationService
/// -------------------
/// Frontend notification / alert API bridge.
/// IMPORTANT:
/// - Notification severity & targeting handled by backend
/// - Frontend only fetches & renders messages
/// - No local filtering or prioritization
class NotificationService {
  final ApiClient _api;

  NotificationService(this._api);

  /* ---------------------------------------------------------- */
  /* FETCH                                                      */
  /* ---------------------------------------------------------- */

  /// Fetch notifications for current user
  ///
  /// Example backend response:
  /// {
  ///   "notifications": [
  ///     {
  ///       "id": "n1",
  ///       "type": "SYSTEM | ALERT | INFO",
  ///       "title": "Maintenance",
  ///       "message": "System maintenance at 2 AM",
  ///       "createdAt": "2026-02-03T10:00:00Z"
  ///     }
  ///   ]
  /// }
  Future<List<dynamic>> getNotifications() async {
    final res = await _api.get('/notifications');

    final list = res['notifications'];
    if (list is List) {
      return list;
    }

    throw StateError('NOTIFICATIONS_INVALID');
  }

  /* ---------------------------------------------------------- */
  /* ACKNOWLEDGEMENT                                            */
  /* ---------------------------------------------------------- */

  /// Acknowledge / mark notification as read
  /// (intent only — backend decides state)
  Future<void> markAsRead({
    required String notificationId,
  }) async {
    await _api.post(
      '/notifications/read',
      data: {
        'id': notificationId,
      },
    );
  }
}
