# Firebase Setup — KAYAN (Phase 3)

Firebase is **optional** at compile time. Mock/API mode works without it.

Enable at runtime with:

```bash
flutter run \
  --dart-define=KAYAN_ENABLE_FIREBASE=true \
  --dart-define=KAYAN_USE_MOCK_DATA=false \
  --dart-define=KAYAN_API_BASE_URL=http://127.0.0.1:3000/v1
```

## Console setup

1. Create a project at https://console.firebase.google.com (e.g. `kayan-superapp`)
2. Add Android app — Application ID: `sa.kayan.app`
3. Download `google-services.json` → `android/app/`
4. (Optional) Add iOS + `GoogleService-Info.plist`
5. Enable: **Cloud Messaging**, **Analytics**, (optional) Crashlytics / Auth Phone

## FlutterFire options

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
# writes lib/firebase_options.dart
```

Then wire options in `lib/core/firebase/firebase_bootstrap.dart` (or import
`DefaultFirebaseOptions.currentPlatform` once the file exists).

## Backend FCM (push from API)

Place a Firebase **service account** JSON on the API host:

```bash
# backend/.env
FIREBASE_SERVICE_ACCOUNT_PATH=./secrets/firebase-service-account.json
```

Without it, `POST /v1/notifications/push*` runs in **log mode** (safe for local).

## Client ↔ API token sync

After login, call:

```dart
await syncDeviceToken(ref); // lib/features/notifications/presentation/device_token_sync.dart
```

This hits `POST /v1/devices/fcm` with `{ token, platform, locale }`.

## OTP note

Phone OTP for login is handled by the NestJS API (`OTP_PROVIDER=unifonic|twilio|dev`),
not Firebase Auth. Firebase Auth Phone remains an optional alternative later.
