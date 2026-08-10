import 'package:flutter/foundation.dart';

import 'app_config.dart';

/// Fail closed if a production-labelled binary still uses mocks / dev hosts.
///
/// Call from `main()` before `runApp`. Development builds are unaffected.
void assertProductionClientConfig() {
  if (!AppConfig.isProductionEnv) return;

  final errors = <String>[];
  if (AppConfig.useMockData) {
    errors.add(
      'KAYAN_USE_MOCK_DATA must be false when KAYAN_ENV=production',
    );
  }
  if (AppConfig.apiLooksLikeDevHost) {
    errors.add(
      'KAYAN_API_BASE_URL must be a real HTTPS API host in production '
      '(got ${AppConfig.apiBaseUrl})',
    );
  }
  if (!AppConfig.apiBaseUrl.startsWith('https://')) {
    errors.add('KAYAN_API_BASE_URL must use https:// in production');
  }
  if (errors.isEmpty) return;

  final message =
      'Production client config invalid:\n- ${errors.join('\n- ')}';
  if (kReleaseMode) {
    throw StateError(message);
  }
  debugPrint(message);
}
