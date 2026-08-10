# Final Release Checklist — Rukn El Tatawer

Use this when you are ready to go live. Until then the repo is **code-ready only**.

## Before customer APK

- [ ] DNS: `api.rukn-eltatawer.com` → API server with TLS
- [ ] DNS: `admin.rukn-eltatawer.com` → Admin with TLS
- [ ] PostgreSQL provisioned; `prisma migrate deploy`
- [ ] Production env vars set (`docs/ENVIRONMENT_VARIABLES.md`)
- [ ] Seed/admin password rotated
- [ ] Google OAuth Web + Android + SHA-1 (incl. Play App Signing)
- [ ] Upload `hosting/cpanel/kayan/` to `public_html/kayan/`
- [ ] Rotate `status.php` `$secret` (never in Flutter)
- [ ] Optional: publish `assetlinks.json` for App Links
- [ ] Build with mock **false**:
  ```bash
  KAYAN_API_BASE_URL=https://api.rukn-eltatawer.com/v1 \
  KAYAN_GOOGLE_SERVER_CLIENT_ID=....apps.googleusercontent.com \
  ./scripts/build_production_apk.sh
  ```
- [ ] `./scripts/verify_release_config.sh` passes
- [ ] Smoke: splash → status enabled → login → service request path
- [ ] Smoke: Admin kill-switch disables app
- [ ] Confirm binary contains **no** `KAYAN_USE_MOCK_DATA=true`

## Classification of leftover hosts

| Pattern | Allowed where |
|---------|----------------|
| `www.rukn-eltatawer.com` | Production website / status fallback |
| `api.rukn-eltatawer.com` | Planned production API (after DNS) |
| `127.0.0.1` / `localhost` | Dev only (`.env.example`, AGENTS, docker-compose.dev) |
| `10.0.2.2` | Android emulator → host machine (dev) |
| `api.kayan.gulf` | **Forbidden** in production builds |

## Do not claim

- Production deployed
- API live
- Google production configured
- cPanel files uploaded
- App Links verified
 until the matching external step is actually done.
