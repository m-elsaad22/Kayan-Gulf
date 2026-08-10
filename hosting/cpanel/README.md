# cPanel package — Rukn El Tatawer (emergency AppControl)

Upload contents of `kayan/` to `public_html/kayan/` on **https://www.rukn-eltatawer.com/**

This is an **emergency fallback**. Primary control = NestJS Admin AppControl.

## Before upload

1. Edit `kayan/status.php` — set `$secret` to a long random value (`CHANGE_ME_CPANEL_SECRET` must not ship).
2. Confirm `status.json` has `enabled: true` for launch.
3. Do **not** put the PHP secret in the Flutter app.

## After upload (manual verification)

- https://www.rukn-eltatawer.com/kayan/status.json
- https://www.rukn-eltatawer.com/kayan/status.php

These URLs are **not** live until you upload.

## Optional App Links

See `kayan/.well-known/assetlinks.json.example` → publish under site root `.well-known/assetlinks.json`.

## Flutter dart-defines

| Define | Typical value |
|--------|----------------|
| `KAYAN_STATUS_URL` | `https://www.rukn-eltatawer.com/kayan/status.json` |
| `KAYAN_WEBSITE_URL` / `KAYAN_PUBLISHER_URL` | `https://www.rukn-eltatawer.com/` |
