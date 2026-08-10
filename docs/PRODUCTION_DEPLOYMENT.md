# Production Deployment — KAYAN / Rukn El Tatawer

**This document describes how to deploy later.** Nothing here is assumed already live.

Official website (exists): https://www.rukn-eltatawer.com/

Planned (not created until you provision them):

- API: `https://api.rukn-eltatawer.com/v1`
- Admin: `https://admin.rukn-eltatawer.com`

## Architecture

```
Flutter → NestJS /v1 → PostgreSQL
Next.js Admin → NestJS /v1
WordPress (rukn-eltatawer.com) → marketing + emergency /kayan/status.json
```

## 1. API server

Node 20+, PostgreSQL 14+, TLS terminator.

```bash
cd backend
cp .env.example .env   # fill production secrets — never commit
npx prisma migrate deploy
npm ci && npm run build
NODE_ENV=production npm run start:prod
```

Or `docker compose up -d --build` with strong `.env`.

## 2. Admin

```bash
cd admin
NEXT_PUBLIC_KAYAN_API_BASE_URL=https://api.rukn-eltatawer.com/v1 npm ci && npm run build && npm start
```

## 3. Flutter production binary

```bash
export KAYAN_API_BASE_URL=https://api.rukn-eltatawer.com/v1
export KAYAN_GOOGLE_SERVER_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
./scripts/verify_release_config.sh
./scripts/build_production_apk.sh
# optional Play:
./scripts/build_play_bundle.sh
```

Script refuses localhost / `kayan.gulf` / missing HTTPS.

## 4. cPanel emergency fallback

Upload `hosting/cpanel/kayan/*` → `public_html/kayan/`.  
Primary AppControl remains Admin → DB → API. See `CPANEL_DEPLOYMENT.md`.

## 5. DNS (future)

| Host | Target |
|------|--------|
| `api.rukn-eltatawer.com` | NestJS |
| `admin.rukn-eltatawer.com` | Next.js |
| `www.rukn-eltatawer.com` | Existing WordPress (unchanged) |

## Health checks (after deploy)

- `GET https://api…/v1/health`
- `GET https://api…/v1/app/status`
- Admin login
- Flutter splash with production dart-defines
