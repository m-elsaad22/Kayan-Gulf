# cPanel Emergency AppControl Fallback

**Primary:** Admin → PostgreSQL `AppControl` → `GET /v1/app/status` → Flutter  

**Emergency only:** static files on the existing WordPress/cPanel site.

## Upload (manual — not done by this repo)

Copy `hosting/cpanel/kayan/` → `public_html/kayan/` on https://www.rukn-eltatawer.com/

Planned URLs after upload:

- `https://www.rukn-eltatawer.com/kayan/status.json`
- `https://www.rukn-eltatawer.com/kayan/status.php`

**Do not claim these are live until you upload them.**

## Secret

In `status.php`, change:

```php
$secret = 'CHANGE_ME_CPANEL_SECRET';
```

Never put this secret in Flutter, GitHub Actions secrets for the app binary, or Admin JS.

## App Links (optional, later)

Template: `hosting/cpanel/kayan/.well-known/assetlinks.json.example`  

Publish as `https://www.rukn-eltatawer.com/.well-known/assetlinks.json` with your release/Play SHA-256. Until verified, the website opens normally when the app is missing — correct behavior.

## WordPress

Do not replace WordPress with NestJS. Do not connect Flutter to WordPress MySQL.
