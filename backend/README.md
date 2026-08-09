# KAYAN API (Phase 1)

NestJS + Prisma REST API matching Flutter remote repositories:

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
| `POST /v1/devices/fcm` | `RemoteDeviceRepository.registerFcmToken` |
| `POST /v1/notifications/push/me` | FCM push to current user |

OTP: set `OTP_PROVIDER=unifonic|twilio|dev` — see [docs/OTP_AND_PUSH.md](../docs/OTP_AND_PUSH.md).

## Quick start (SQLite)

```bash
cd backend
cp .env.example .env
npm install
npx prisma migrate dev --name init
npm run seed
npm run start:dev
```

Health: http://127.0.0.1:3000/v1/health

Demo user: `demo@kayan.app` / `password123`  
Dev OTP: any 6 digits except `000000`

## Flutter

```bash
# from repo root
./scripts/run_api_mode.sh
```

## Postgres / Docker

1. Set `DATABASE_URL=postgresql://kayan:kayan@localhost:5432/kayan` in `.env`
2. Change `provider = "postgresql"` in `prisma/schema.prisma`
3. `docker compose up --build`

See [docs/COMMERCIAL_LAUNCH.md](../docs/COMMERCIAL_LAUNCH.md) for the full roadmap.
