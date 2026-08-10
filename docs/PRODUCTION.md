# KAYAN — Production runbook (Critical hardening)

This document reflects the **Critical** production fixes after the commercial readiness audit.

## What changed (must-know)

| Area | Before | After |
|------|--------|-------|
| Database | SQLite + broken Postgres Compose | **PostgreSQL only** (`prisma/schema.prisma`) |
| Docker entrypoint | `node dist/main.js` (missing) | `node dist/src/main.js` + migrate deploy |
| Boot guards | None | `assertProductionConfig()` refuses unsafe prod |
| OTP | Plaintext + `Math.random` | SHA-256 at rest + `crypto.randomInt` |
| Payments webhook | Open | HMAC `x-kayan-signature` required |
| Client `/payments/confirm` | Marks any payment paid | Disabled unless `PAYMENT_ALLOW_CLIENT_CONFIRM=true` (dev) |
| Tap | Fake redirect | Real Charge create when `TAP_SECRET_KEY` set |
| Flutter tokens | Hive | SecureStorage (+ memory cache) |
| Checkout | `Future.delayed` | Remote `orders` + `payments/intent` |
| Cart | In-memory mock | Remote cart when `KAYAN_USE_MOCK_DATA=false` |
| Release signing | Silent debug fallback | Release/bundle **fails** without `key.properties` |

## Backend local (Postgres)

```bash
# Postgres running (Docker or local)
export DATABASE_URL=postgresql://kayan:kayan@127.0.0.1:5432/kayan
cd backend
cp .env.example .env   # already uses Postgres URL
npx prisma migrate deploy
npm run seed
npm run start:dev
```

## Docker Compose (production-shaped)

Requires a `.env` next to `docker-compose.yml` with **strong** values:

```bash
POSTGRES_PASSWORD=...
JWT_ACCESS_SECRET=...          # ≥32 chars, not change-me
OTP_PROVIDER=unifonic          # or twilio — NOT dev
OTP_STRICT=true
CORS_ORIGINS=https://admin.your-domain.com
UNIFONIC_APP_SID=...
PAYMENT_PROVIDER=mock          # or tap + TAP_SECRET_KEY + PAYMENT_WEBHOOK_SECRET
```

```bash
cd backend && docker compose up --build
```

Dev-only Compose (OTP=dev allowed): use `docker compose -f docker-compose.dev.yml up` if present.

## Payment webhook signature

Payload signed (stable JSON keys):

```json
{"orderId":"...","providerRef":"...","status":"paid"}
```

Header: `x-kayan-signature: <hex hmac-sha256(payload, PAYMENT_WEBHOOK_SECRET)>`

## Flutter release against API

```bash
./scripts/create_upload_keystore.sh
cp android/key.properties.example android/key.properties  # fill secrets
export KAYAN_API_BASE_URL=https://api.your-domain.com/v1
./scripts/verify_release_config.sh
./scripts/build_play_bundle.sh
```

Requires a signed-in user with a delivery address (seed creates one for `demo@kayan.app`).

## Still not full commercial (High / later)

- HyperPay / Paymob createIntent still rejected (not implemented)
- Firebase FlutterFire options / google-services plugin still missing
- Social login still mock
- Classifieds post / service booking UI may still be partially demo
- Helmet / global throttler not added yet
