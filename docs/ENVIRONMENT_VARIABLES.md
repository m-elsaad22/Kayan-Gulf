# Environment Variables

## NestJS API (`backend`)

| Variable | Required (prod) | Notes |
|----------|-----------------|-------|
| `NODE_ENV` | yes | `production` |
| `PORT` | no | default `3000` |
| `DATABASE_URL` | yes | `postgresql://…` |
| `JWT_ACCESS_SECRET` | yes | ≥32 chars |
| `JWT_ACCESS_TTL` | no | default `15m` |
| `JWT_REFRESH_TTL` | no | default `30d` |
| `CORS_ORIGINS` | yes | comma-separated |
| `OTP_PROVIDER` | yes | `unifonic` \| `twilio` (not `dev`) |
| `OTP_STRICT` | yes | `true` |
| `UNIFONIC_*` / `TWILIO_*` | when OTP live | provider credentials |
| `GOOGLE_WEB_CLIENT_ID` | yes* | Web OAuth client |
| `GOOGLE_CLIENT_IDS` | alt | comma list of allowed `aud`/`azp` |
| `GOOGLE_AUTH_REQUIRED` | no | default require Google IDs |
| `PAYMENT_PROVIDER` | no | `mock` \| `cod` \| `tap` … |
| `TAP_SECRET_KEY` | if tap | |
| `PAYMENT_WEBHOOK_SECRET` | if non-mock | ≥16 |
| `PAYMENT_ALLOW_CLIENT_CONFIRM` | must be false | |
| `FIREBASE_PROJECT_ID` / service account | for FCM | |

## Flutter (`--dart-define`)

| Define | Production |
|--------|------------|
| `KAYAN_ENV` | `production` |
| `KAYAN_USE_MOCK_DATA` | `false` |
| `KAYAN_API_BASE_URL` | `https://…/v1` |
| `KAYAN_GOOGLE_SERVER_CLIENT_ID` | Web client ID |
| `KAYAN_REQUIRE_REMOTE_STATUS` | `true` |
| `KAYAN_STATUS_URL` | cPanel fallback JSON |
| `KAYAN_PUBLISHER_URL` | company site |
| `KAYAN_ENABLE_FIREBASE` | `true` when FlutterFire ready |

## Admin (Next.js)

| Variable | Notes |
|----------|-------|
| `NEXT_PUBLIC_KAYAN_API_BASE_URL` | `https://api…/v1` |
