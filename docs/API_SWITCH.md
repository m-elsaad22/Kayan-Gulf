# KAYAN — Switching from Mock Data to the Real API

By default the app ships with **mock repositories** (`AppConfig.useMockData = true`). No backend is required for development, demos, or QA APKs.

## Quick reference

| Variable | Default | Purpose |
|----------|---------|---------|
| `KAYAN_USE_MOCK_DATA` | `true` | `false` enables remote repositories |
| `KAYAN_API_BASE_URL` | `https://api.kayan.gulf/v1` | REST API base URL |

Configuration is defined in `lib/core/config/app_config.dart` and read via `String.fromEnvironment` / `bool.fromEnvironment` at **compile time**.

## Run with mock data (default)

```bash
flutter run
# or
flutter build apk --release
```

## Run against a real backend

### Debug / profile

```bash
flutter run \
  --dart-define=KAYAN_USE_MOCK_DATA=false \
  --dart-define=KAYAN_API_BASE_URL=https://staging.api.example.com/v1
```

### Release APK

```bash
flutter build apk --release \
  --dart-define=KAYAN_USE_MOCK_DATA=false \
  --dart-define=KAYAN_API_BASE_URL=https://api.example.com/v1
```

### CI / GitHub Actions

Add the same `--dart-define` flags to your build step, for example:

```yaml
- run: flutter build apk --release \
    --dart-define=KAYAN_USE_MOCK_DATA=false \
    --dart-define=KAYAN_API_BASE_URL=${{ secrets.KAYAN_API_BASE_URL }}
```

## What changes when mock is disabled

`repository_providers.dart` swaps implementations:

| Provider | Mock | Remote |
|----------|------|--------|
| `homeRepositoryProvider` | `MockHomeRepository` | `RemoteHomeRepository` |
| `productRepositoryProvider` | `MockProductRepository` | `RemoteProductRepository` |
| `authRepositoryProvider` | `MockAuthRepository` | `RemoteAuthRepository` |
| `serviceRepositoryProvider` | `MockServiceRepository` | `RemoteServiceRepository` |
| `classifiedsRepositoryProvider` | `MockClassifiedsRepository` | `RemoteClassifiedsRepository` |

Presentation providers (`homeDataProvider`, `productListProvider`, etc.) stay the same — only the data source changes.

## Backend contract (overview)

Remote repositories expect JSON REST endpoints under the configured base URL. Implementations live in each feature’s `data/repositories/remote_*_repository.dart`. Typical shapes:

- **Home** — `GET /home` → banners, categories, flash deals, featured products, recent ads
- **Products** — `GET /products`, `GET /products/:slug`, query params for search/sort/filter
- **Auth** — `POST /auth/otp/send`, `POST /auth/otp/verify`, `POST /auth/login`, `POST /auth/signup`
- **Services** — `GET /services`, `GET /services/:slug`, `GET /bookings`
- **Classifieds** — `GET /ads`, `GET /ads/:slug`, `GET /ads/featured`, category filters

Exact field names should match the models in each feature’s `data/models/` directory. Use the mock repositories and `MockDataCatalog` as the reference for expected domain shapes.

## Authentication headers

`ApiClient` currently sends `Accept: application/json`. When wiring production auth:

1. Persist tokens via `LocalStorageService` (already used by `AuthNotifier`).
2. Add a Dio interceptor on `ApiClient` to attach `Authorization: Bearer <accessToken>`.
3. Handle 401 responses with token refresh in the remote auth repository.

## Local storage in tests

`AuthNotifier.setAuthenticated()` writes to Hive via `LocalStorageService`. Unit/integration tests that touch auth persistence must call `LocalStorageService.initialize()` after `Hive.init()`, or test only the repository layer (see `test/integration/app_data_flow_test.dart`).

## Remaining screen-level TODOs

Some secondary screens still contain `// TODO: connect to real backend` in their headers. These are cosmetic markers for screens that use local UI state or admin mocks; they do not block the repository switch. New work should use feature providers backed by repositories.

## Verification checklist

- [ ] `flutter analyze` — zero issues
- [ ] `flutter test` — all tests pass (mock mode)
- [ ] App launches with `KAYAN_USE_MOCK_DATA=false` against staging
- [ ] Login / OTP flow returns tokens and populates `authStateProvider`
- [ ] Home, products, services, and classifieds load from API without crashes
