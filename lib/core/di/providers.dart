// ============================================================
// KAYAN — Dependency Injection Root
// lib/core/di/providers.dart
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AppDI {
  /// Production overrides — empty in production.
  /// In tests: swap with mocks, e.g.:
  ///   overrides: [apiClientProvider.overrideWith((_) => MockApiClient())]
  static List<Override> get overrides => const [];
}
