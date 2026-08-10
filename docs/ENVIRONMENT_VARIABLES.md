# Environment Variables

## Flutter (`--dart-define`)

| Define | Production intent |
|--------|-------------------|
| `KAYAN_ENV` | `production` |
| `KAYAN_USE_MOCK_DATA` | `false` |
| `KAYAN_API_BASE_URL` | `https://api.rukn-eltatawer.com/v1` **when DNS exists** |
| `KAYAN_WEBSITE_URL` | `https://www.rukn-eltatawer.com/` |
| `KAYAN_SUPPORT_URL` | same or support page |
| `KAYAN_PRIVACY_URL` | privacy page URL |
| `KAYAN_TERMS_URL` | terms page URL |
| `KAYAN_APP_DOWNLOAD_URL` | download landing |
| `KAYAN_WHATSAPP_URL` | optional `https://wa.me/…` |
| `KAYAN_PHONE_URL` | optional `+966…` |
| `KAYAN_STATUS_URL` | cPanel fallback JSON |
| `KAYAN_GOOGLE_SERVER_CLIENT_ID` | Web OAuth client |
| `KAYAN_REQUIRE_REMOTE_STATUS` | `true` |

## NestJS

See `backend/.env.example`. Production requires strong JWT, Postgres URL, OTP≠dev, CORS, Google client IDs, etc. (`assertProductionConfig`).

## Admin (Next.js)

| Variable | Notes |
|----------|-------|
| `NEXT_PUBLIC_KAYAN_API_BASE_URL` | Public API base only — **no secrets** |

## Dev-only hosts (never production binaries)

- `http://127.0.0.1:3000/v1`
- `http://10.0.2.2:3000/v1` (Android emulator)
- `localhost`
