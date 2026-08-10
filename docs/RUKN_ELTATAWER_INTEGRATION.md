# Rukn El Tatawer — Integration Readiness

**Status:** CODE READY FOR PRODUCTION DEPLOYMENT — **not** production deployed.

Existing live website only:

- https://www.rukn-eltatawer.com/

**Not created yet (do not assume live):**

- `api.rukn-eltatawer.com`
- `admin.rukn-eltatawer.com`
- DNS records for those hosts
- Google OAuth production credentials
- cPanel upload of `hosting/cpanel/kayan/`

## Architecture boundary

```
Flutter APK  --HTTPS-->  NestJS API  -->  PostgreSQL
                              ^
Next.js Admin ----------------┘

WordPress (rukn-eltatawer.com) = marketing / SEO / emergency status JSON
WordPress MySQL ≠ app database
Flutter NEVER talks to WordPress MySQL or PostgreSQL directly
```

## A. Already implemented (in code)

| Item | Location |
|------|----------|
| Central brand URLs | `lib/core/config/rukn_brand.dart` |
| API / mock / status config | `lib/core/config/app_config.dart` |
| Prod mock/host guard | `lib/core/config/production_assert.dart` |
| AppControl API primary | Nest `GET /v1/app/status`, Admin UI |
| cPanel emergency files | `hosting/cpanel/kayan/` |
| Google idToken verify + `googleSub` | Nest `AuthService.loginWithGoogle` |
| Service `websiteUrl` + cities | Prisma `Service`, Flutter `ServiceDetailModel` |
| Android App Links intent filters | `AndroidManifest.xml` (verification pending) |
| Deep-link path mapper | `lib/core/deep_links/rukn_deep_links.dart` |
| About / Support / Privacy / Terms links | Profile screens via `RuknBrand` |

## B. Code ready — needs external configuration

- `KAYAN_API_BASE_URL` once API host exists
- `KAYAN_GOOGLE_SERVER_CLIENT_ID` + backend `GOOGLE_CLIENT_IDS`
- Optional `KAYAN_WHATSAPP_URL` / `KAYAN_PHONE_URL`
- Privacy/terms WordPress pages if paths differ from defaults
- Per-service `websiteUrl` in Admin/DB mapping to WP pages

## C. Requires server / DNS

| Record / host | Purpose |
|---------------|---------|
| `A/AAAA api.rukn-eltatawer.com` | NestJS API + TLS |
| `A/AAAA admin.rukn-eltatawer.com` | Next.js admin + TLS |
| PostgreSQL reachable only by API | App data |
| Upload `public_html/kayan/*` | Emergency status fallback |
| Upload `.well-known/assetlinks.json` | Android App Links verify |

## D. Requires Google Console

- Android OAuth client: package `sa.kayan.app` + SHA-1 (debug, release, Play App Signing)
- Web OAuth client ID → Flutter dart-define + API env
- See `docs/GOOGLE_SIGN_IN_SETUP.md`

## E. Requires other credentials

- Unifonic / Twilio (OTP)
- Tap (or other) payment keys
- Firebase Admin for FCM (optional)
- cPanel PHP `$secret` rotation

## WordPress

Do **not** modify WordPress code/DB from this repo. Future integration = HTTPS APIs or published JSON only. Service pages remain informational; bookings/requests go NestJS → Admin.
