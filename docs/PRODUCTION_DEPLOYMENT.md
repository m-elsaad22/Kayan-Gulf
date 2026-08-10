# KAYAN Gulf — Production Deployment

## Architecture

```
Flutter APK  --HTTPS-->  NestJS API (/v1)  -->  PostgreSQL
                              |
                              +--> Admin (Next.js)
                              +--> FCM (optional)
                              +--> OTP (Unifonic/Twilio)
                              +--> Payments (Tap when keys present)

Emergency fallback (kill-switch only):
cPanel status.json / status.php on https://www.rukn-eltatawer.com/kayan/
```

**Authority rule:** the NestJS API owns identity, prices, orders, and app control. Flutter is a client.

## Prerequisites

- Node.js 20+
- PostgreSQL 14+
- Domain + TLS certificates
- Android upload keystore (`android/key.properties`)
- Google OAuth Web + Android clients (see `GOOGLE_SIGN_IN_SETUP.md`)

## Backend

```bash
cd backend
cp .env.example .env   # if present; otherwise set env vars from ENVIRONMENT_VARIABLES.md
npm ci
npx prisma migrate deploy
npm run seed           # optional demo data — skip on real prod if undesired
npm run build
NODE_ENV=production npm run start:prod
```

Docker:

```bash
docker compose up -d --build
```

Use `docker-compose.dev.yml` only for local OTP=dev.

## Admin

```bash
cd admin
npm ci
NEXT_PUBLIC_KAYAN_API_BASE_URL=https://api.YOUR_DOMAIN/v1 npm run build
npm start
```

Default seed admin: `admin@kayan.app` / `kayan@admin` (role `super_admin`). **Change immediately.**

## Flutter production APK

```bash
export KAYAN_API_BASE_URL=https://api.YOUR_DOMAIN/v1
export KAYAN_GOOGLE_SERVER_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
./scripts/build_production_apk.sh
```

Do **not** use `build_distribution_apk.sh` for production — that script defaults to mock data for cPanel demos.

## App control

1. Primary: Admin → **تحكم التطبيق** → `PATCH /v1/admin/app-control`
2. Public poll: `GET /v1/app/status`
3. Fallback: upload `hosting/cpanel/kayan/*` to cPanel `public_html/kayan/`

## Health checks

- `GET /v1/health`
- `GET /v1/app/status`
- Admin login + users list
- Flutter splash reaches home only when `enabled=true` and version ≥ `minVersion`
