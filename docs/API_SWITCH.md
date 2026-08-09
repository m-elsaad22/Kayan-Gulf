# KAYAN — Switching from Mock Data to the Real API

By default the app ships with **mock repositories** (`AppConfig.useMockData = true`). No backend is required for development, demos, or QA APKs.

## Quick reference

| Variable | Default | Purpose |
|----------|---------|---------|
| `KAYAN_USE_MOCK_DATA` | `true` | `false` enables remote repositories |
| `KAYAN_API_BASE_URL` | `https://api.kayan.gulf/v1` | REST API base URL |

Configuration is defined in `lib/core/config/app_config.dart` and read via `String.fromEnvironment` / `bool.fromEnvironment` at **compile time**.

> **Phase 1 commercial API** lives in `/backend` (NestJS). Local base URL: `http://127.0.0.1:3000/v1`.  
> Convenience scripts: `scripts/run_api_mode.sh`, `scripts/build_api_release.sh`.  
> Roadmap: [COMMERCIAL_LAUNCH.md](./COMMERCIAL_LAUNCH.md).

## Run with mock data (default)

```bash
flutter run
# or
flutter build apk --release
```

## Run against a real backend

### Local NestJS API (Phase 1)

```bash
# Terminal 1
cd backend && cp .env.example .env && npm install
npx prisma migrate dev --name init && npm run seed && npm run start:dev

# Terminal 2
./scripts/run_api_mode.sh
# → --dart-define=KAYAN_USE_MOCK_DATA=false
# → --dart-define=KAYAN_API_BASE_URL=http://127.0.0.1:3000/v1
```

### Debug / profile (staging)

```bash
flutter run \
  --dart-define=KAYAN_USE_MOCK_DATA=false \
  --dart-define=KAYAN_API_BASE_URL=https://staging.api.example.com/v1
```

### Release APK (production)

```bash
KAYAN_API_BASE_URL=https://api.my-domain.com/v1 ./scripts/build_api_release.sh

# or manually:
flutter build apk --release \
  --dart-define=KAYAN_USE_MOCK_DATA=false \
  --dart-define=KAYAN_API_BASE_URL=https://api.my-domain.com/v1
```

Default `KAYAN_USE_MOCK_DATA` remains `true` so demos and CI tests work without a backend.

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
| `cartRepositoryProvider` | `MockCartRepository` | `RemoteCartRepository` |
| `orderRepositoryProvider` | `MockOrderRepository` | `RemoteOrderRepository` |
| `deviceRepositoryProvider` | `MockDeviceRepository` | `RemoteDeviceRepository` |
| `serviceRepositoryProvider` | `MockServiceRepository` | `RemoteServiceRepository` |
| `classifiedsRepositoryProvider` | `MockClassifiedsRepository` | `RemoteClassifiedsRepository` |

Presentation providers (`homeDataProvider`, `productListProvider`, etc.) stay the same — only the data source changes.

## Backend contract (overview)

Remote repositories expect JSON REST endpoints under the configured base URL. Implementations live in each feature’s `data/repositories/remote_*_repository.dart`. Typical shapes:

- **Home** — `GET /home` → banners, categories, flash deals, featured products, recent ads
- **Products** — `GET /products`, `GET /products/:slug`, query params for search/sort/filter
- **Auth** — `POST /auth/otp/send`, `POST /auth/otp/verify`, `POST /auth/login`, `POST /auth/signup`
- **Cart** — `GET /cart`, `POST /cart/items`, `PATCH /cart/items/:id`, `DELETE /cart/items/:id`, coupon endpoints
- **Addresses** — `GET|POST /addresses`, `PATCH|DELETE /addresses/:id`
- **Orders** — `POST /orders`, `GET /orders`, `GET /orders/:id`, `GET /orders/:id/tracking`
- **Payments** — `POST /payments/intent`, `POST /payments/confirm`, `POST /webhooks/payments`
- **Devices / Push** — `POST /devices/fcm`, `DELETE /devices/fcm`, `POST /notifications/push/me`
- **Services** — `GET /services/categories`, `GET /services`, `GET /services/:slug`
- **Bookings** — `GET/POST /bookings`, `GET /bookings/:id`, `PATCH /bookings/:id/status`
- **Classifieds** — `GET /classifieds/categories`, `GET /classifieds/ads`, `GET /classifieds/ads/featured`, `GET /classifieds/ads/:slug`, `GET /classifieds/my-ads`, `POST /classifieds/ads`, `PATCH /classifieds/ads/:id/status`

Exact field names should match the models in each feature’s `data/models/` directory. Use the mock repositories and `MockDataCatalog` as the reference for expected domain shapes.

## Authentication headers

`ApiClient` automatically attaches `Authorization: Bearer <accessToken>` on every request when a token is stored in `LocalStorageService` (via `AuthInterceptor` in `lib/core/network/auth_interceptor.dart`).

For tests or custom wiring, pass an explicit `tokenProvider` to `ApiClient`:

```dart
ApiClient(tokenProvider: () => 'staging-token');
```

### Token refresh (future)

Handle 401 responses with token refresh in the remote auth repository when the backend supports it.

## Local storage in tests

`AuthNotifier.setAuthenticated()` writes to Hive via `LocalStorageService`. Unit/integration tests that touch auth persistence must call `LocalStorageService.initialize()` after `Hive.init()`, or test only the repository layer (see `test/integration/app_data_flow_test.dart`).

## Remaining screen-level notes

Some secondary screens use local demo UI content (booking flow steps, returns wizard, gallery). They are routed and styled but do not yet call remote repositories directly. New work should use feature providers backed by repositories.

## Verification checklist

- [ ] `flutter analyze` — zero issues
- [ ] `flutter test` — all tests pass (mock mode)
- [ ] App launches with `KAYAN_USE_MOCK_DATA=false` against staging
- [ ] Login / OTP flow returns tokens and populates `authStateProvider`
- [ ] Home, products, services, and classifieds load from API without crashes
