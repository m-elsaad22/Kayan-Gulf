# Release Checklist — KAYAN Gulf Final RC

## Backend

- [ ] `NODE_ENV=production`
- [ ] PostgreSQL `DATABASE_URL`
- [ ] Strong `JWT_ACCESS_SECRET` (≥32, not placeholder)
- [ ] `OTP_PROVIDER` ≠ `dev`, `OTP_STRICT=true`
- [ ] `CORS_ORIGINS` set
- [ ] `GOOGLE_CLIENT_IDS` / `GOOGLE_WEB_CLIENT_ID` set
- [ ] `PAYMENT_ALLOW_CLIENT_CONFIRM` unset/false
- [ ] `prisma migrate deploy` applied (incl. AppControl migration)
- [ ] Admin password rotated
- [ ] Helmet + throttler active

## Flutter

- [ ] Built with `./scripts/build_production_apk.sh`
- [ ] `KAYAN_USE_MOCK_DATA=false`
- [ ] HTTPS `KAYAN_API_BASE_URL`
- [ ] Google Web client ID dart-define
- [ ] Release signing via `key.properties`
- [ ] Splash blocked when API `enabled=false`
- [ ] Force-update path tested

## Admin

- [ ] Deployed against production API
- [ ] App Control page reachable
- [ ] User suspend revokes refresh tokens

## cPanel fallback

- [ ] `status.json` uploaded
- [ ] PHP secret rotated
- [ ] Confirmed Flutter still works when API briefly down (grace cache)

## Store

- [ ] AAB via `./scripts/build_play_bundle.sh` (optional Play)
- [ ] Play App Signing SHA-1 added to Google Cloud
- [ ] Privacy policy / data safety filled

## Do not ship if

- Mock data is still enabled in the release binary
- Google tokens are accepted without audience checks
- Suspended users can still call authenticated APIs
- API points to localhost
