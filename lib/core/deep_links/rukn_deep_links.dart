import '../../routing/app_routes.dart';

/// Maps public Rukn El Tatawer website paths → in-app routes.
///
/// Android App Links are prepared in `AndroidManifest.xml` for
/// `https://www.rukn-eltatawer.com/...`. Until `.well-known/assetlinks.json`
/// is published on the website AND verified, OS will open the normal website
/// (correct fallback when the app is not installed / links not verified).
///
/// This mapper is code-ready; it does **not** claim App Links are live.
abstract final class RuknDeepLinks {
  static const String websiteHost = 'www.rukn-eltatawer.com';
  static const String websiteHostBare = 'rukn-eltatawer.com';

  /// Returns an in-app location for a deep link, or null to leave unhandled.
  static String? mapUri(Uri uri) {
    final host = uri.host.toLowerCase();

    if (uri.scheme == 'kayan') {
      // kayan://services/ac  → host=services, path=/ac
      // kayan:///services/ac → path=/services/ac
      final combined = host.isEmpty
          ? uri.path
          : '/$host${uri.path.startsWith('/') ? uri.path : '/${uri.path}'}';
      return _mapPath(combined, uri.queryParameters);
    }

    if (host != websiteHost && host != websiteHostBare) {
      return null;
    }
    return _mapPath(uri.path, uri.queryParameters);
  }

  static String? _mapPath(String path, Map<String, String> query) {
    var p = path.trim();
    if (p.isEmpty || p == '/') return AppRoutes.dashboard;
    if (!p.startsWith('/')) p = '/$p';
    // Collapse duplicate slashes
    p = p.replaceAll(RegExp(r'/+'), '/');

    final services = RegExp(r'^/services/([^/]+)/?$').firstMatch(p);
    if (services != null) {
      return AppRoutes.servicePath(services.group(1)!);
    }
    if (p == '/services' || p == '/services/') {
      return AppRoutes.services;
    }

    if (p.startsWith('/kayan')) {
      return AppRoutes.aboutKayan;
    }

    if (p.startsWith('/shop')) return AppRoutes.shop;
    if (p.startsWith('/ads') || p.startsWith('/classifieds')) {
      return AppRoutes.classifieds;
    }

    if (p.contains('contact') || p.contains('support')) {
      return AppRoutes.contactSupport;
    }

    final appPath = query['app'];
    if (appPath != null && appPath.startsWith('/')) return appPath;

    return null;
  }
}
