// ============================================================
// VNC PLATFORM — DEEP LINKS
// File: lib/routing/deep_links.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'route_names.dart';

/// Deep link resolution result.
/// - route: internal route name
/// - args: optional arguments for the screen
class DeepLinkResult {
  final String route;
  final Object? args;

  const DeepLinkResult({
    required this.route,
    this.args,
  });
}

/// DeepLinks
/// ----------
/// Converts external URIs into internal routes.
/// IMPORTANT:
/// - Only whitelisted paths are allowed
/// - Unknown / malformed links fall back safely
/// - NO authority decisions here
class DeepLinks {
  DeepLinks._();

  /// Resolve an incoming URI string.
  /// Returns null if the link must be ignored.
  static DeepLinkResult? resolve(String? uriString) {
    if (uriString == null || uriString.trim().isEmpty) {
      return null;
    }

    Uri uri;
    try {
      uri = Uri.parse(uriString);
    } catch (_) {
      return null;
    }

    // Only handle http/https/app schemes
    if (!_isAllowedScheme(uri.scheme)) {
      return null;
    }

    final List<String> segments = uri.pathSegments;

    if (segments.isEmpty) {
      return null;
    }

    // ----------------------------------------------------------
    // WHITELISTED PATHS
    // ----------------------------------------------------------

    switch (segments.first) {
      case 'wallet':
        return const DeepLinkResult(
          route: RouteNames.wallet,
        );

      case 'trade':
        return const DeepLinkResult(
          route: RouteNames.tradeHome,
        );

      case 'merchant':
        return const DeepLinkResult(
          route: RouteNames.merchantDashboard,
        );

      case 'support':
        return const DeepLinkResult(
          route: RouteNames.supportHome,
        );

      case 'faq':
        return const DeepLinkResult(
          route: RouteNames.faq,
        );

      // Example: /trade/escrow?id=XYZ
      case 'escrow':
        final String? tradeId = uri.queryParameters['id'];
        if (tradeId != null && tradeId.isNotEmpty) {
          return DeepLinkResult(
            route: RouteNames.escrowStatus,
            args: {'tradeId': tradeId},
          );
        }
        return null;

      default:
        // Unknown deep link — ignore safely
        return null;
    }
  }

  /* ---------------------------------------------------------- */
  /* INTERNAL HELPERS                                           */
  /* ---------------------------------------------------------- */

  static bool _isAllowedScheme(String scheme) {
    return scheme == 'http' ||
        scheme == 'https' ||
        scheme == 'vnc';
  }
}
