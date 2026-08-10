# KAYAN — OTP SMS & Push Notifications (Phase 3)

## OTP providers

| `OTP_PROVIDER` | Behavior |
|----------------|----------|
| `dev` (default) | Logs SMS; accepts any 6-digit code except `000000` unless `OTP_STRICT=true` |
| `unifonic` | Sends via Unifonic REST; verifies **hashed** stored code only |
| `twilio` | Sends via Twilio Messages API; verifies **hashed** stored code only |

Codes are stored as SHA-256 hashes (never plaintext). Generation uses `crypto.randomInt`.

Production (`NODE_ENV=production`) **refuses** `OTP_PROVIDER=dev` and requires `OTP_STRICT=true` — see `docs/PRODUCTION.md`.

### Unifonic (recommended for GCC)

```env
OTP_PROVIDER=unifonic
OTP_STRICT=true
UNIFONIC_APP_SID=your_app_sid
UNIFONIC_SENDER_ID=KAYAN
```

### Twilio

```env
OTP_PROVIDER=twilio
OTP_STRICT=true
TWILIO_ACCOUNT_SID=ACxxx
TWILIO_AUTH_TOKEN=xxx
TWILIO_FROM_NUMBER=+1…
```

### Guards

- `OTP_COOLDOWN_SECONDS` (default 30)
- `OTP_MAX_PER_HOUR` (default 5)
- `OTP_TTL_MINUTES` (default 10)

## Push (FCM)

| Endpoint | Auth | Purpose |
|----------|------|---------|
| `POST /v1/devices/fcm` | Bearer | Register device token |
| `DELETE /v1/devices/fcm` | Bearer | Unregister |
| `POST /v1/notifications/push/me` | Bearer | Push to current user's devices |
| `POST /v1/notifications/push` | Bearer + **admin** | Push to explicit token list |

Order creation triggers a push attempt (`order_created`) in log or FCM admin mode.

### Flutter flags

| Define | Default | Meaning |
|--------|---------|---------|
| `KAYAN_ENABLE_FIREBASE` | `false` | Init Firebase + FCM + Analytics |
| `KAYAN_USE_MOCK_DATA` | `true` | Local repos (device repo mocks register) |
