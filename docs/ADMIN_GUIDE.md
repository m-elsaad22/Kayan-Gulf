# Admin Guide (Next.js)

## Login

URL: your admin host (e.g. `https://admin.YOUR_DOMAIN`)

Seed (change immediately):

- Email: `admin@kayan.app`
- Password: `kayan@admin`
- Role: `super_admin`

Allowed admin roles: `support`, `moderator`, `admin`, `super_admin`.

Privileged actions (suspend users, app control): `admin` | `super_admin`.

## Modules

| Page | Purpose |
|------|---------|
| لوحة التحكم | Counts + recent orders |
| المنتجات / الطلبات / الخدمات / الحجوزات / الإعلانات | Catalog & ops status |
| المستخدمون | Search, role, suspend/activate/soft-delete |
| تحكم التطبيق | Kill-switch, maintenance, minVersion, forceUpdate |
| سجل التدقيق | Recent admin mutations |

## App control fields

- `enabled` — master kill-switch
- `maintenanceMode` — maintenance screen
- `minVersion` / `forceUpdate` — force upgrade UX
- `messageAr` / `messageEn`
- `supportUrl` / `websiteUrl` / `apkUrl` / `playStoreUrl`

Changes apply via `GET /v1/app/status` (Flutter polls at splash and on resume paths).

## Notifications

FCM send APIs live under `/v1/notifications` (admin JWT). Configure Firebase Admin credentials on the API host — never embed server keys in the APK.
