import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shared [ProviderContainer] factory for integration tests.
ProviderContainer createIntegrationContainer({
  List<Override> overrides = const [],
}) {
  return ProviderContainer(overrides: overrides);
}

/// Keeps auto-dispose providers alive while async reads run.
ProviderSubscription<T> keepAlive<T>(
  ProviderContainer container,
  ProviderListenable<T> provider,
) {
  return container.listen(provider, (_, __) {});
}
