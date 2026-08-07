# AGENTS.md

## Cursor Cloud specific instructions

### Product overview

KAYAN (`sa.kayan.app`) is a **Flutter mobile client** (Android in-repo; iOS scaffold present). It combines e-commerce, home services, food delivery, and classifieds using **mock/local data** — no backend container is required for UI development.

### Toolchain (this VM)

| Component | Location / notes |
|-----------|------------------|
| Flutter stable | On `PATH` (e.g. `/tmp/flutter/bin/flutter`) |
| Android SDK | `/workspace/.android-sdk` — export `ANDROID_HOME` and `ANDROID_SDK_ROOT` to this path before APK builds |
| Java | System OpenJDK 21 (`java` on PATH); used successfully for release APK builds |
| `android/local.properties` | Points `sdk.dir` → `/workspace/.android-sdk`, `flutter.sdk` → Flutter install |

Do **not** commit `.android-sdk/` or `dist/` (local build artifacts).

### Services to run

| Service | Required? | How to start |
|---------|-----------|--------------|
| Flutter app (web) | **Yes** (recommended) | `flutter run -d chrome --web-port=8080 --web-browser-flag="--no-sandbox"` |
| Flutter app (APK) | Optional | `flutter build apk --release --android-skip-build-dependency-validation` with `ANDROID_HOME=/workspace/.android-sdk` |
| Android emulator | No | **No KVM** in Cloud VM — use Chrome/web |
| Backend / Firebase | No | Mock providers; Firebase not initialized in `main.dart` |

Use **tmux** for long-running `flutter run` (e.g. session `kayan-web-dev`). App URL after web start: `http://127.0.0.1:8080`.

### Common commands

From repo root (`/workspace`):

```bash
flutter pub get          # VM startup (update script)
flutter analyze          # many info-level lints; exit 0 is normal
flutter test             # widget smoke test in test/widget_test.dart
flutter build apk --release --android-skip-build-dependency-validation
```

**Run in Chrome (recommended for Cloud Agents):**

```bash
# One-time if web/ is missing:
flutter create . --platforms=web

export ANDROID_HOME=/workspace/.android-sdk ANDROID_SDK_ROOT=/workspace/.android-sdk
flutter run -d chrome --web-port=8080 --web-browser-flag="--no-sandbox"
```

**Phase release ZIPs** (APK + README):

```bash
./scripts/package_phase_zip.sh phase-4-shop 1.0.0
# Output: dist/kayan-phase-4-shop-1.0.0.zip
```

See `RELEASES.md` for GitHub download links.

### Known gotchas

1. **Design system:** HTML-matched light theme uses `lib/core/theme/kayan_design_tokens.dart` and `lib/shared/widgets/design/`. Older dark/luxury widgets still exist under `lib/shared/widgets/luxury/`.

2. **GoRouter redirect loop on first launch (web):** If language/region and onboarding flags conflict, clear site data in Chrome DevTools.

3. **No KVM / emulator:** Use `flutter run -d chrome`, not `emulator`.

4. **Mock auth:** OTP accepts any 6 digits; **تخطي / Skip** on login works for smoke tests.

5. **Outbound HTTPS:** `picsum.photos` and `google_fonts` need network for full UI.

6. **Firebase / Maps / Stripe:** Optional for production; not required for mock-data dev (`README.md`, `lib/core/config/README_FIREBASE.md`).

7. **Android SDK:** `android/app/build.gradle` uses `compileSdk 36` / `targetSdk 36`.

8. **Branding:** After replacing `assets/images/kayan_icon.webp` / `kayan_logo.png`, run `python3 scripts/install_kayan_branding.py` then rebuild.

### Manual test flow (hello world)

1. Start web: `flutter run -d chrome` → open `http://127.0.0.1:8080`.
2. Language/region → onboarding (skip) → login (skip or any phone + 6-digit OTP).
3. Dashboard → tap **متجر تسوق** or bottom **التسوق** tab.
4. Confirm shop home: orange header **متجر كيان**, category pills, recommended products.
5. Optional: open a product detail, or build APK via `scripts/package_phase_zip.sh`.
