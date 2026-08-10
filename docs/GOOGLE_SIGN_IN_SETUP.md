# Google Sign-In Setup (manual — credentials not in repo)

**Code is ready** (Flutter obtains ID token; Nest verifies issuer/audience/`sub` and stores `googleSub`).  
**Production Google Console is NOT configured until you complete the steps below.**

## Values you will enter later

| Item | Where |
|------|--------|
| Android package name | `sa.kayan.app` (Firebase / Google Cloud Android OAuth client) |
| Debug SHA-1 | Local debug keystore → Android OAuth client |
| Release / upload SHA-1 | `secrets/kayan-upload.jks` or your Play upload key |
| Play App Signing SHA-1 | Play Console → App integrity → App signing key certificate |
| Web Client ID | Google Cloud → OAuth 2.0 Web client |

## Flutter

```bash
--dart-define=KAYAN_GOOGLE_SERVER_CLIENT_ID=<WEB_CLIENT_ID>.apps.googleusercontent.com
```

## NestJS

```bash
GOOGLE_WEB_CLIENT_ID=<WEB_CLIENT_ID>.apps.googleusercontent.com
# or
GOOGLE_CLIENT_IDS=web-id,android-id
```

Production boot requires these unless `GOOGLE_AUTH_REQUIRED=false`.

## Verification rules (already in code)

- `idToken` required in production
- `iss` = accounts.google.com
- `aud` / `azp` ∈ configured client IDs
- `email_verified`
- Identity from token `sub` → `User.googleSub`

Do not trust client-supplied email/googleId in production.
