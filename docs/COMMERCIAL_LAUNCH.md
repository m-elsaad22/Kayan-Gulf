# KAYAN — Commercial Launch Plan (MVP)

Assumptions for Phase 1 (fill these when you have them):

| Item | Assumed default | Notes |
|------|-----------------|-------|
| Primary market | **Saudi Arabia** | SAR, RTL, Gulf cities in seed |
| Domain | TBD → local `http://127.0.0.1:3000/v1` | Point DNS later to API host |
| OTP | **Dev stub** + Unifonic-ready adapter | Swap env to Unifonic/Twilio/Firebase Auth |
| Payments | Deferred (Phase 2) | Recommend **Tap** or **HyperPay** for KSA |
| Server / VPS | Not required for Phase 1 | Docker Compose provided for deploy |

---

## Recommended backend stack

| Layer | Choice | Why |
|-------|--------|-----|
| API | **NestJS** (TypeScript) | Matches modular Flutter features; strong DI; JWT ecosystem |
| ORM | **Prisma** | Fast schema iteration; SQLite for local, PostgreSQL for prod |
| Auth | JWT access + refresh | Matches `AuthInterceptor` Bearer flow |
| OTP | Provider interface | `OTP_PROVIDER=dev\|unifonic\|twilio` |
| Deploy | Docker Compose (API + Postgres) | One-command staging/prod |

Alternatives considered: Firebase-only (limits commerce/orders), Laravel (fine if team is PHP-first). NestJS is the default for this monorepo.

---

## Execution order (MVP commercial)

### Phase 1 — Core API + app wiring ✅ (this PR)

1. NestJS API under `/backend` with global prefix `/v1`
2. Endpoints matching Flutter remote repos:
   - Auth: OTP send/verify, email login/signup, refresh, logout
   - Home: `GET /home`
   - Products: `GET /products`, `GET /products/:slug`
3. Seed catalog compatible with Dart `fromJson` shapes
4. Run Flutter with:
   ```bash
   --dart-define=KAYAN_USE_MOCK_DATA=false
   --dart-define=KAYAN_API_BASE_URL=http://127.0.0.1:3000/v1
   ```

### Phase 2 — Commerce checkout

- Cart / orders API
- Addresses + shipping zones (KSA cities)
- Payment gateway (Tap / HyperPay / Paymob)
- Webhooks + order status

### Phase 3 — Real OTP + notifications

- Production SMS (Unifonic recommended for GCC)
- Firebase Cloud Messaging + Analytics
- Optional Firebase Auth phone as alternative

### Phase 4 — Services + Classifieds APIs

- Wire existing remote repos for services & ads
- Booking + ad lifecycle

### Phase 5 — Web admin (not in-app)

- Separate Next.js / Nest admin UI
- Role-based access (replace device-local admin)

### Phase 6 — Store release

- Google Play (AAB, signing, store listing AR/EN)
- iOS later (Apple Developer, TestFlight)

---

## Phase 1 runbook

```bash
# Backend
cd backend
cp .env.example .env
npm install
npx prisma migrate dev
npm run seed
npm run start:dev
# → http://127.0.0.1:3000/v1/health

# Flutter against local API
./scripts/run_api_mode.sh
# or
flutter run -d chrome --web-port=8080 \
  --dart-define=KAYAN_USE_MOCK_DATA=false \
  --dart-define=KAYAN_API_BASE_URL=http://127.0.0.1:3000/v1
```

Production APK (when domain is ready):

```bash
flutter build apk --release \
  --dart-define=KAYAN_USE_MOCK_DATA=false \
  --dart-define=KAYAN_API_BASE_URL=https://api.my-domain.com/v1
```

Default `AppConfig.useMockData` stays `true` so demos/tests keep working without a backend.
