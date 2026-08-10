# KAYAN — Commercial Launch Plan (MVP)

Assumptions for Phase 1 (fill these when you have them):

| Item | Assumed default | Notes |
|------|-----------------|-------|
| Primary market | **Saudi Arabia** | SAR, RTL, Gulf cities in seed |
| Domain | TBD → local `http://127.0.0.1:3000/v1` | Point DNS later to API host |
| OTP | **dev** / Unifonic / Twilio | Set `OTP_PROVIDER` + credentials |
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

### Phase 2 — Commerce checkout ✅

- Cart / orders / addresses API (`/v1/cart`, `/v1/orders`, `/v1/addresses`)
- KSA VAT 15% + free shipping ≥ 200 SAR; coupons `KAYAN10` / `KAYAN50`
- Payment adapter stub: `PAYMENT_PROVIDER=mock|tap|hyperpay|paymob`
  - COD / mock card → immediate; others → `redirectUrl` + webhook
- Flutter: `CartRepository` + `OrderRepository` (mock + remote)

### Phase 3 — Real OTP + notifications ✅

- OTP providers: `dev` | `unifonic` | `twilio` (rate limit + cooldown)
- Device token API + FCM push (`firebase-admin` or log mode)
- Flutter: optional Firebase bootstrap (`KAYAN_ENABLE_FIREBASE`), Analytics, FCM sync after login
- Docs: `docs/OTP_AND_PUSH.md`, updated `lib/core/config/README_FIREBASE.md`

### Phase 4 — Services + Classifieds APIs ✅

- Services: `GET /services`, `/services/categories`, `/services/:slug`
- Bookings: `GET/POST /bookings`, `PATCH /bookings/:id/status` (JWT)
- Classifieds: categories, ads list/detail/featured, `my-ads`, create + status
- Flutter repos extended with create booking / create ad / status updates

### Phase 5 — Web admin (not in-app) ✅

- User `role`: `user` | `admin` (JWT + `AdminGuard`)
- Admin APIs under `/v1/admin/*` (stats, users, products, orders, services, bookings, ads)
- Next.js app in `/admin` → http://127.0.0.1:3001
- Seed admin: `admin@kayan.app` / `kayan@admin`
- In-app local CMS remains demo-only; production ops use the web panel

### Phase 6 — Store release ✅

- Google Play AAB pipeline: `scripts/create_upload_keystore.sh`, `scripts/build_play_bundle.sh`, `scripts/verify_release_config.sh`
- Signing via `android/key.properties` (example tracked; real file gitignored) + `secrets/*.jks`
- `android/app/build.gradle`: Play-standard keystore props; `versionCode` / `versionName` from Flutter
- Docs: `docs/PLAY_STORE.md` (listing AR/EN, Data safety, checklist), `docs/IOS_RELEASE.md` (TestFlight later)
- Optional CI: `.github/workflows/build_play_aab.yml` (`workflow_dispatch` + signing secrets)

---

## Commercial MVP complete

Phases 1–6 cover API, commerce, OTP/push, services/classifieds, web admin, and Play release tooling.

### Production critical hardening (follow-up)

See **[docs/PRODUCTION.md](PRODUCTION.md)** for Postgres-only DB, Docker entrypoint fix, production boot guards, payment webhook HMAC, SecureStorage tokens, and API-wired checkout/cart.

Remaining go-live work is mostly operational (host API + TLS, real Unifonic/Tap keys, Play Console submit) plus High items listed in that doc.

## Phase 1–2 runbook

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

### Phase 2 checkout smoke (curl)

```bash
TOKEN=$(curl -s -X POST http://127.0.0.1:3000/v1/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"demo@kayan.app","password":"password123"}' | jq -r .accessToken)
PRODUCT=$(curl -s http://127.0.0.1:3000/v1/products | jq -r '.items[0].id')
ADDR=$(curl -s http://127.0.0.1:3000/v1/addresses -H "Authorization: Bearer $TOKEN" | jq -r '.items[0].id')
curl -s -X POST http://127.0.0.1:3000/v1/cart/items \
  -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d "{\"productId\":\"$PRODUCT\",\"quantity\":1}"
ORDER=$(curl -s -X POST http://127.0.0.1:3000/v1/orders \
  -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d "{\"addressId\":\"$ADDR\",\"paymentMethod\":\"cod\",\"agreeToTerms\":true}" | jq -r .id)
curl -s -X POST http://127.0.0.1:3000/v1/payments/intent \
  -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d "{\"orderId\":\"$ORDER\",\"paymentMethod\":\"cod\"}"
```

Production APK (when domain is ready):

```bash
flutter build apk --release \
  --dart-define=KAYAN_USE_MOCK_DATA=false \
  --dart-define=KAYAN_API_BASE_URL=https://api.my-domain.com/v1
```

Default `AppConfig.useMockData` stays `true` so demos/tests keep working without a backend.
