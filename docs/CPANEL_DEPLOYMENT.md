# cPanel Deployment (Emergency App Control Fallback)

Primary app control is **Admin → Database → API**.  
cPanel hosting is the **emergency fallback** when the API is unreachable.

## Upload

Copy repo files to `public_html/kayan/`:

- `hosting/cpanel/kayan/status.json`
- `hosting/cpanel/kayan/status.php`
- See `hosting/cpanel/README.md`

Public URL example:

`https://www.rukn-eltatawer.com/kayan/status.json`

## Flutter behavior

1. Call `GET {API}/app/status`
2. On failure → fetch `KAYAN_STATUS_URL` (cPanel)
3. On both failures → use last-known-good cache (6h grace)
4. Otherwise fail-closed (block app)

## Operator kill-switch (emergency)

Edit `status.json`:

```json
{ "enabled": false, "messageAr": "...", "messageEn": "..." }
```

Or use `status.php?key=SECRET&action=off` after changing the PHP `$secret`.

**Rotate `CHANGE_ME_CPANEL_SECRET` before production upload.**

## Important

cPanel PHP/JSON **cannot** replace NestJS for auth, orders, or payments.  
Host the API on a Node-capable VPS / container host.
