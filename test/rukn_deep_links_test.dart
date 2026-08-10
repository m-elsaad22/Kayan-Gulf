import 'package:flutter_test/flutter_test.dart';
import 'package:kayan/core/deep_links/rukn_deep_links.dart';
import 'package:kayan/routing/app_routes.dart';

void main() {
  group('RuknDeepLinks', () {
    test('maps website service path', () {
      final uri = Uri.parse('https://www.rukn-eltatawer.com/services/ac');
      expect(RuknDeepLinks.mapUri(uri), AppRoutes.servicePath('ac'));
    });

    test('maps kayan scheme', () {
      final uri = Uri.parse('kayan://services/plumbing');
      expect(RuknDeepLinks.mapUri(uri), AppRoutes.servicePath('plumbing'));
    });

    test('maps kayan landing to about', () {
      final uri = Uri.parse('https://www.rukn-eltatawer.com/kayan/');
      expect(RuknDeepLinks.mapUri(uri), AppRoutes.aboutKayan);
    });

    test('ignores unrelated hosts', () {
      final uri = Uri.parse('https://example.com/services/ac');
      expect(RuknDeepLinks.mapUri(uri), isNull);
    });
  });
}
