# KAYAN — Google Play release (Phase 6)

Package ID: **`sa.kayan.app`** · Target SDK 36 · Format: **Android App Bundle (AAB)**

## Prerequisites

| Item | Notes |
|------|--------|
| Google Play Console developer account | One-time registration |
| Production / staging API URL | HTTPS, e.g. `https://api.your-domain.com/v1` |
| Upload keystore | Created once; back up offline forever |
| Privacy policy URL | Public HTTPS page (required for listing) |
| Store listing assets | Icon 512×512, feature graphic 1024×500, phone screenshots |

Optional: Firebase (`google-services.json` locally only — never commit), Maps API key in `android/local.properties`.

## 1. Create upload keystore

```bash
./scripts/create_upload_keystore.sh
# → secrets/kayan-upload.jks  (gitignored)

cp android/key.properties.example android/key.properties
# Edit passwords; keep storeFile=../../secrets/kayan-upload.jks
```

Enroll **Play App Signing** on first upload (Google holds the app signing key; you keep the upload key).

## 2. Preflight + build AAB

```bash
export KAYAN_API_BASE_URL=https://api.your-domain.com/v1
# optional: export KAYAN_ENABLE_FIREBASE=true
# optional: export BUILD_NAME=1.0.0 BUILD_NUMBER=2

./scripts/verify_release_config.sh
./scripts/build_play_bundle.sh
# → dist/kayan-play-YYYYMMDD.aab
```

The build forces:

- `KAYAN_USE_MOCK_DATA=false`
- your `KAYAN_API_BASE_URL`
- release minify / shrink + signing from `android/key.properties`

Version comes from `pubspec.yaml` (`version: x.y.z+build`) unless `BUILD_NAME` / `BUILD_NUMBER` override.

## 3. Play Console — create app

1. Create app → default language **Arabic (ar)** (or EN + add AR).
2. App category: Shopping / Lifestyle (pick closest).
3. Free app.
4. Complete **App content**: privacy policy, ads declaration, Data safety, target audience, content rating questionnaire.
5. Countries: start with **Saudi Arabia** (+ Gulf as needed).

## 4. Store listing (AR + EN)

| Field | Arabic (example) | English (example) |
|-------|------------------|-------------------|
| App name | كيان | KAYAN |
| Short description | تسوق، خدمات منزلية، طلبات، وإعلانات في تطبيق واحد | Shop, home services, orders, and classifieds in one app |
| Full description | سوبر آب خليجي يجمع المتجر والخدمات والتوصيل والإعلانات المبوّبة. | Gulf super-app for commerce, services, delivery, and classifieds. |

Assets:

- High-res icon: `assets/images/kayan_icon.webp` → export 512×512 PNG
- Feature graphic: brand orange + wordmark (1024×500)
- Phone screenshots: dashboard, shop, product, cart/checkout, services (min 2)

## 5. Data safety & privacy

Declare based on what you ship:

| Data | If enabled |
|------|------------|
| Phone / account | OTP login, profile |
| Location | Addresses / maps (if Maps key set) |
| Purchases | Orders / payments |
| Device IDs / push tokens | FCM when Firebase on |
| Photos | Classifieds / profile uploads |

Link a real privacy policy URL. In-app copy lives at the privacy policy screen; host a public HTML version for Play.

## 6. Content rating

Complete IARC questionnaire honestly (shopping, UGC classifieds, messaging). Expect “Everyone” / “PEGI 3” class outcomes unless you enable mature ad categories.

## 7. Upload & tracks

1. **Internal testing** → upload AAB → add testers → smoke with production API.
2. **Closed / open testing** (optional).
3. **Production** → review → publish.

Play Console → Release → Production (or Internal) → Create release → upload `dist/kayan-play-*.aab`.

## Checklist before first production submit

- [ ] `applicationId` is `sa.kayan.app` and matches Play Console
- [ ] Upload keystore backed up offline (JKS + passwords)
- [ ] `android/key.properties` not committed
- [ ] AAB built with mock data **off** and real API URL
- [ ] Privacy policy URL live
- [ ] Data safety form filled
- [ ] Content rating completed
- [ ] AR (+ EN) listing + screenshots
- [ ] Internal test install succeeds (login OTP, shop order, services, classifieds)
- [ ] Backend HTTPS + CORS / mobile clients OK
- [ ] Payment provider not left on unsafe defaults for real money (see Phase 2)

## CI (optional)

Workflow `.github/workflows/build_play_aab.yml` runs on `workflow_dispatch`. Provide repository secrets:

| Secret | Purpose |
|--------|---------|
| `KAYAN_UPLOAD_KEYSTORE_BASE64` | `base64 -w0 secrets/kayan-upload.jks` |
| `KAYAN_KEY_PROPERTIES` | Full contents of `android/key.properties` (with `storeFile=upload.jks` path used in CI) |
| `KAYAN_API_BASE_URL` | Production/staging API |

## Related

- Signing scripts: `scripts/create_upload_keystore.sh`, `scripts/build_play_bundle.sh`
- API mode: `docs/API_SWITCH.md`
- Commercial plan: `docs/COMMERCIAL_LAUNCH.md`
- iOS later: `docs/IOS_RELEASE.md`
