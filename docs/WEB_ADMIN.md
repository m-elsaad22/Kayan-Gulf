# KAYAN Web Admin (Phase 5)

Centralized operations console — **not** the Flutter in-app CMS.

## Access

| Item | Value |
|------|-------|
| URL | http://127.0.0.1:3001 |
| Email | `admin@kayan.app` |
| Password | `kayan@admin` |
| API | `GET /v1/admin/stats` (Bearer JWT, `role=admin`) |

## Architecture

```
admin/ (Next.js)  --JWT-->  backend /v1/admin/*
                              └─ JwtAuthGuard + AdminGuard
```

Login uses the same `POST /v1/auth/login` as the mobile app; the response includes `role`. Non-admin users receive `403 admin_required` on admin routes.

## In-app admin vs web admin

| | In-app CMS | Web admin |
|--|------------|-----------|
| Location | Flutter hidden panel | `/admin` Next.js |
| Auth | Local `admin` / `kayan@admin` | API user with `role=admin` |
| Data | Device Hive / AdminDataService | Central Postgres/SQLite API |
| Production | Demo / design only | **Use this** |

## Runbook

```bash
cd backend && npm run seed && npm run start:dev
cd admin && npm run dev
```
