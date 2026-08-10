# Google Sign-In Setup (KAYAN Gulf)

## Goal

Real Google OAuth: Flutter obtains an **ID token**; NestJS verifies it with Google `tokeninfo`, checks **audience**, and persists `googleSub`.

Never trust client-supplied email / googleId in production.

## 1. Firebase / Google Cloud

1. Create (or reuse) a Firebase project for `sa.kayan.app`.
2. Add an Android app with package name **`sa.kayan.app`**.
3. Add SHA-1 (and SHA-256) fingerprints:
   - Debug keystore (local)
   - Upload keystore (`secrets/kayan-upload.jks` or Play upload key)
   - **Play App Signing** certificate from Play Console (required after Play enrollment)
4. Enable **Google** sign-in provider in Firebase Authentication (optional for token issuance; still recommended).
5. In Google Cloud Console → APIs & Services → Credentials:
   - **Android** OAuth client (package + SHA-1)
   - **Web** OAuth client (used as `serverClientId` / audience)

## 2. Flutter

Pass the **Web client ID** at build time:

```bash
--dart-define=KAYAN_GOOGLE_SERVER_CLIENT_ID=XXXX.apps.googleusercontent.com
```

`GoogleAuthService` uses `google_sign_in` v7 `authenticate()` and requests an ID token.

## 3. Backend

Set either:

```bash
GOOGLE_WEB_CLIENT_ID=XXXX.apps.googleusercontent.com
# or comma-separated:
GOOGLE_CLIENT_IDS=WEB_ID,ANDROID_ID
```

Production boot refuses to start without these unless `GOOGLE_AUTH_REQUIRED=false`.

Endpoint: `POST /v1/auth/google` with `{ "idToken": "..." }`.

Verified fields used: `sub`, `email`, `email_verified`, `aud`/`azp`, `iss`.

## 4. Account rules

| Case | Behavior |
|------|----------|
| New `googleSub` | Create user (`authProvider=google`) |
| Existing `googleSub` | Login |
| Email exists, no `googleSub` | Link Google to that account |
| Email exists with different `googleSub` | Reject `google_account_mismatch` |
| Suspended / deleted | Reject |

## 5. Manual checklist

- [ ] SHA-1 uploaded for debug + release + Play signing
- [ ] Web client ID in Flutter dart-define
- [ ] Same Web client ID (or allowed list) in API env
- [ ] Test on a real device (emulators may lack Google Play Services)
- [ ] Confirm backend stores `User.googleSub`
