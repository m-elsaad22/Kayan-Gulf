# KAYAN Gulf — Final Production Release Candidate Report

PR: https://github.com/m-elsaad22/Kayan-Gulf/pull/57  
Branch: `cursor/final-production-release-candidate-eef0`

## A. What was implemented

- Real Google ID-token verification (audience + issuer + email_verified) with `googleSub` persistence
- `AppControl` PostgreSQL model + public `GET /v1/app/status` + admin CRUD UI
- Flutter status: API → cPanel → 6h grace cache → fail-closed; minVersion / forceUpdate / maintenance UX
- Admin user search/suspend/activate/soft-delete/roles; device status; audit logs
- Helmet + Nest throttler; JWT rejects suspended/deleted users
- `scripts/build_production_apk.sh` (mock=false, HTTPS API required)
- Docs suite: deployment, Google, cPanel, admin, checklist, env vars, troubleshooting

## B. What was fixed

- Google login discarded `googleSub` / trusted client email in prod paths
- Kill-switch was cPanel-primary; now API-authoritative
- Admin users were read-only; roles were binary `admin` only
- Production guard did not require Google client IDs
- Seed admin elevated to `super_admin`; AppControl seeded

## C. What was removed

- No silent production acceptance of Google login without `idToken`
- Competing “cPanel-only” authority as the primary control path (kept as fallback only)

## D. What was tested

- Backend: `npm test` (11) + `npm run build`
- Prisma migrate deploy + seed
- Flutter: full `flutter test` (82) + `flutter analyze` (info-only)
- Live smoke: `GET /v1/app/status` returns seeded control JSON
- Admin: `npm run build`

## E. Build results

| Target | Result |
|--------|--------|
| NestJS | pass |
| Flutter tests/analyze | pass (info lints only) |
| Production APK | pass (33MB) |
| Admin Next.js | pass (see CI/local build log) |
| AAB | build via `scripts/build_play_bundle.sh` with same dart-defines when needed |

## F. Final APK path

- `/workspace/dist/kayan-production-20260810.apk`
- `/opt/cursor/artifacts/kayan-production-20260810.apk`

Configured with `KAYAN_USE_MOCK_DATA=false` and `KAYAN_API_BASE_URL=https://api.kayan.gulf/v1` (placeholder host until real API DNS exists).

## G. Final AAB path

- `/workspace/dist/kayan-play-20260810.aab`
- `/opt/cursor/artifacts/kayan-play-20260810.aab`

Rebuild for real DNS:

```bash
KAYAN_API_BASE_URL=https://YOUR_API/v1 \
KAYAN_GOOGLE_SERVER_CLIENT_ID=YOUR_WEB_CLIENT_ID \
./scripts/build_play_bundle.sh
```
## H. Final API URL

Operator-defined. Production APK dart-define must be HTTPS `…/v1`.  
Local smoke: `http://127.0.0.1:3000/v1`.

## I. Admin URL

Operator-defined Next.js host with `NEXT_PUBLIC_KAYAN_API_BASE_URL` pointing at the API.

## J. cPanel deployment location

Upload `hosting/cpanel/kayan/*` → `public_html/kayan/`  
Example: `https://www.rukn-eltatawer.com/kayan/status.json`

## K. Google Sign-In status

**Code complete.** Manual Google Cloud / SHA-1 / Web client ID still required (see `docs/GOOGLE_SIGN_IN_SETUP.md`).

## L. Firebase status

FCM server path exists; FlutterFire options / `google-services` plugin still optional until push launch.

## M. OTP status

Provider interface ready (Unifonic/Twilio). Production forbids `OTP_PROVIDER=dev`. Credentials not in repo.

## N. Payment status

Mock/COD + Tap (when keyed) + HMAC webhooks. HyperPay/Paymob not production-complete.

## O. Kill Switch status

**Operational in code:** Admin App Control → DB → API; cPanel emergency fallback; Flutter blocking/maintenance/update screens.

## P. Database migration status

Applied: `20260810180000_final_rc_app_control` (User Google/status, DeviceToken fields, AppControl, AuditLog).

## Q. Security audit result

Hardened: token verification, status gates, helmet, throttler, production boot guards, soft-delete session revoke. Remaining risks: unpaid HyperPay/Paymob stubs, cPanel PHP secret still `CHANGE_ME` until rotated, placeholder API host in sample APK.

## R. Exact manual steps still required

1. Provision HTTPS NestJS + Postgres host; set env from `docs/ENVIRONMENT_VARIABLES.md`
2. Create Google OAuth Web+Android clients; add SHA-1 (incl. Play App Signing)
3. Rebuild APK/AAB with real `KAYAN_API_BASE_URL` + `KAYAN_GOOGLE_SERVER_CLIENT_ID`
4. Upload cPanel fallback; rotate `status.php` secret
5. Change seed admin password; configure Unifonic/Tap when going live SMS/payments
6. Point DNS for API + Admin

## S. Final PR

https://github.com/m-elsaad22/Kayan-Gulf/pull/57

## T. Remaining genuine blockers

- No live production API hostname/credentials in this environment
- Google Cloud OAuth clients / SHA fingerprints cannot be created from the repo alone
- SMS (Unifonic) and card acquiring (Tap/HyperPay) need merchant credentials
- Sample production APK points at placeholder `https://api.kayan.gulf/v1` until DNS exists
