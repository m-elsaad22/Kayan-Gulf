# KAYAN Web Admin (Phase 5)

Next.js admin dashboard — **separate from the Flutter in-app CMS**.

## Credentials (seed)

- Email: `admin@kayan.app`
- Password: `kayan@admin`
- Role: `admin` (enforced by `AdminGuard` on `/v1/admin/*`)

## Run

```bash
# Terminal 1 — API
cd backend && npm run start:dev

# Terminal 2 — Admin
cd admin
cp .env.example .env.local
npm install
npm run dev
# → http://127.0.0.1:3001
```

Default Next port is 3000; if the API already uses 3000, start with:

```bash
npm run dev -- -p 3001
```

## Features

- Login with JWT + role check
- Dashboard stats
- Products / Orders / Services / Bookings / Ads / Users
- Status updates for products, orders, and ads

The mobile app's hidden local admin (`admin` / `kayan@admin` device login) remains for design demos only — production ops should use this web panel.
