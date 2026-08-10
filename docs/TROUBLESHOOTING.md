# Troubleshooting

## App stuck on “unavailable”

1. Check `GET /v1/app/status` → `enabled: true`
2. Check cPanel `status.json` if API is down
3. Clear app data if grace cache holds an old `enabled:false`
4. Confirm `KAYAN_REQUIRE_REMOTE_STATUS` — set `false` only for local UI work

## Google Sign-In fails

| Symptom | Fix |
|---------|-----|
| `google_id_token_required` | Ensure Web client ID dart-define; Play Services present |
| `invalid_google_audience` | Align API `GOOGLE_CLIENT_IDS` with Web/Android clients |
| `google_account_mismatch` | Email already linked to another Google `sub` |
| `account_suspended` | Activate user in Admin |

## Admin login `admin_required`

User role must be one of `support|moderator|admin|super_admin`. Seed uses `super_admin`.

## API refuses to start in production

Read the thrown `Production config invalid` list — usually JWT, Postgres URL, OTP=dev, CORS, or missing Google client IDs.

## Payments

HyperPay/Paymob are not production-complete. Use `mock`/`cod` or Tap with secrets + webhook HMAC.

## Build APK

- Missing `key.properties` → production script exits; distribution script can generate a local keystore
- Flutter 3.32 API changes: prefer `activeColor` on Switch, avoid deprecated Dropdown `initialValue`
