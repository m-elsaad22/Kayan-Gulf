# KAYAN API

NestJS + Prisma REST API matching Flutter remote repositories.

**Database: PostgreSQL only** (see [docs/PRODUCTION.md](../docs/PRODUCTION.md)).

| Endpoint | Flutter repo |
|----------|----------------|
| `POST /v1/auth/otp/send` | `RemoteAuthRepository.sendOtp` |
| `POST /v1/auth/otp/verify` | `RemoteAuthRepository.verifyOtp` |
| `POST /v1/auth/login` | `RemoteAuthRepository.loginWithEmail` |
| `POST /v1/auth/signup` | `RemoteAuthRepository.signUp` |
| `POST /v1/auth/refresh` | `RemoteAuthRepository.refreshToken` |
| `POST /v1/auth/logout` | `RemoteAuthRepository.logout` |
| `GET /v1/home` | `RemoteHomeRepository.getHomeData` |
| `GET /v1/products` | `RemoteProductRepository.getProducts` |
| `GET /v1/products/:slug` | `RemoteProductRepository.getProductDetail` |
| `GET/POST… /v1/cart` | `RemoteCartRepository` |
| `GET/POST… /v1/addresses` | `RemoteOrderRepository` (addresses) |
| `POST/GET /v1/orders` | `RemoteOrderRepository` |
| `POST /v1/payments/intent` | `RemoteOrderRepository.createPaymentIntent` |
| `POST /v1/webhooks/payments` | HMAC-signed webhook (`x-kayan-signature`) |
| `POST /v1/devices/fcm` | `RemoteDeviceRepository.registerFcmToken` |
| `POST /v1/notifications/push/me` | FCM push to current user |
| `POST /v1/notifications/push` | Admin-only push to token list |
| `GET /v1/services…` | `RemoteServiceRepository` |
| `GET/POST /v1/bookings` | bookings lifecycle |
| `GET/POST /v1/classifieds…` | `RemoteClassifiedsRepository` |
| `GET /v1/admin/*` | Web admin (role=`admin` required) |

Admin seed: `admin@kayan.app` / `kayan@admin` — UI in [`/admin`](../admin/README.md).

OTP: set `OTP_PROVIDER=unifonic|twilio|dev` — see [docs/OTP_AND_PUSH.md](../docs/OTP_AND_PUSH.md).

## Quick start (local Postgres)

```bash
# Ensure Postgres is up, then:
cd backend
cp .env.example .env
npm install
npx prisma migrate deploy
npm run seed
npm run start:dev
```

Or with Compose (dev OTP allowed):

```bash
cd backend && docker compose -f docker-compose.dev.yml up --build
```

Health: http://127.0.0.1:3000/v1/health

Demo user: `demo@kayan.app` / `password123`  
Dev OTP: any 6 digits except `000000` (when `OTP_PROVIDER=dev` and `OTP_STRICT=false`)

## Production Compose

```bash
# Set required secrets in backend/.env — see .env.example + docs/PRODUCTION.md
cd backend && docker compose up --build
```

`NODE_ENV=production` refuses `OTP_PROVIDER=dev`, placeholder JWT, empty `CORS_ORIGINS`, and non-Postgres `DATABASE_URL`.

## Flutter

```bash
./scripts/run_api_mode.sh
```

See [docs/COMMERCIAL_LAUNCH.md](../docs/COMMERCIAL_LAUNCH.md) and [docs/PRODUCTION.md](../docs/PRODUCTION.md).
