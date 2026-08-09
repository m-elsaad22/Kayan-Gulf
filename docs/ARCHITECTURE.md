# KAYAN — Architecture Overview

This document describes the data and presentation architecture of the KAYAN Gulf Flutter super-app after the repository migration (phases 42–48).

## Layered structure

```
Presentation (screens, widgets, Riverpod providers)
        ↓
Domain (filters, result models, repository interfaces)
        ↓
Data (mock + remote repositories, MockDataCatalog)
        ↓
Core (AppConfig, ApiClient, DI, theme, routing)
```

Each feature lives under `lib/features/<feature>/` with the usual split:

| Layer | Path pattern | Responsibility |
|-------|--------------|----------------|
| Presentation | `presentation/screens`, `presentation/providers` | UI, navigation, Riverpod state |
| Domain | `domain/` (where present) | Filters, value objects |
| Data | `data/repositories`, `data/models` | Repository implementations |

Shared cross-cutting code is in `lib/core/` and `lib/shared/`.

## Repository pattern

All network-backed features expose an abstract repository and two implementations:

| Repository | Interface | Mock | Remote |
|------------|-----------|------|--------|
| Home | `HomeRepository` | `MockHomeRepository` | `RemoteHomeRepository` |
| Products | `ProductRepository` | `MockProductRepository` | `RemoteProductRepository` |
| Auth | `AuthRepository` | `MockAuthRepository` | `RemoteAuthRepository` |
| Cart | `CartRepository` | `MockCartRepository` | `RemoteCartRepository` |
| Orders | `OrderRepository` | `MockOrderRepository` | `RemoteOrderRepository` |
| Devices | `DeviceRepository` | `MockDeviceRepository` | `RemoteDeviceRepository` |
| Services | `ServiceRepository` | `MockServiceRepository` | `RemoteServiceRepository` |
| Classifieds | `ClassifiedsRepository` | `MockClassifiedsRepository` | `RemoteClassifiedsRepository` |

Providers are registered in `lib/core/di/repository_providers.dart`. The active implementation is chosen at compile time via `AppConfig.useMockData`.

```dart
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  if (AppConfig.useMockData) {
    return const MockProductRepository();
  }
  return RemoteProductRepository(ref.watch(apiClientProvider));
});
```

Presentation code should depend on **providers** (e.g. `productListProvider`), not on concrete repository classes.

## Mock data catalog

`lib/core/data/mock_data_catalog.dart` is the single entry point for seed data used by mock repositories and admin fallbacks. Individual mock files under `lib/core/data/mock/` are not imported directly from feature code.

## State management

- **Riverpod 2.x** — `FutureProvider`, `NotifierProvider`, `StateNotifier` patterns per feature.
- **Auth guard** — `authStateProvider` in `lib/shared/providers/auth_provider.dart` drives GoRouter redirects.
- **Auto-dispose** — many list/detail providers use `autoDispose`; integration tests use `keepAlive()` (see `test/helpers/provider_container.dart`).

## Networking

- `ApiClient` (`lib/core/network/api_client.dart`) wraps Dio with JSON helpers, `ApiException` mapping, and `AuthInterceptor` for Bearer tokens.
- Base URL and timeouts come from `AppConfig`.
- Remote repositories translate API JSON into feature models; mock repositories read from `MockDataCatalog`.

## Routing

`lib/routing/` defines GoRouter routes, deep links, and auth/profile guards via `RouteGuards`.

## Testing

| Type | Location | Purpose |
|------|----------|---------|
| Unit | `test/` | Repositories, tokens, guards, providers |
| Widget | `test/widget/` | Design system components |
| Integration | `test/integration/` | Cross-provider flows, DI stack |

CI runs `flutter analyze` and `flutter test` on every push (`.github/workflows/flutter_ci.yml`).

## Feature map (high level)

```
lib/features/
├── auth/           OTP, email login, profile setup
├── home/           Dashboard, banners, sections
├── ecommerce/      Products, cart, checkout, orders
├── services/       Browse, booking, technician flow
├── classifieds/    Ads, chat, my ads
├── delivery/       Food & grocery delivery
├── profile/        Account, wallet, referrals
├── settings/       Theme, language, notifications
└── …               splash, onboarding, admin CMS
```

## Switching to the real API

See [API_SWITCH.md](./API_SWITCH.md) for build flags, environment variables, and backend expectations.
