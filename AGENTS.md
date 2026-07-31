# AGENTS.md

## Cursor Cloud specific instructions

### Product overview

KAYAN (`sa.kayan.app`) is a **Flutter mobile client** (Android in-repo; iOS not checked in). It combines e-commerce, home services, and classifieds with mock data — no backend is required for local UI development.

### Toolchain

| Component | Location | Provisioned? |
|-----------|----------|--------------|
| Flutter stable (3.44.x, Dart 3.12.x) | `$HOME/flutter` | Yes — matches `pubspec.lock` (`flutter >=3.44.0`, `dart >=3.12.0`) |
| Chrome (web) | `google-chrome` on `PATH` | Yes |
| Android SDK | `$HOME/Android/Sdk` | No — not installed. Only needed for APK builds (see below) |
| JDK 17 (Android builds) | — | No — system Java is JDK 21 (`/usr/lib/jvm/java-21-openjdk-amd64`) |

`$HOME/flutter/bin` is on `PATH` via `~/.bashrc`. Open a new shell or `source ~/.bashrc` if `flutter` is not found. The startup update script runs `flutter pub get` automatically.

The **web target is the validated dev path** in this Cloud VM. APK builds are not provisioned by default: they require installing the Android SDK (platforms 35/36 + build-tools) and JDK 17, then setting `JAVA_HOME` and `android/local.properties`.

### Services to run

| Service | Required? | Notes |
|---------|-----------|-------|
| Flutter app | **Yes** | Only runnable product in this repo |
| Android emulator | Optional | **Does not work** in this Cloud VM (no `/dev/kvm`). Use Chrome/web instead. |
| Chrome (web) | **Recommended** | Best way to run and manually test in Cloud Agents |
| Backend / Firebase | No | Mock data; Firebase not initialized in `main.dart` |

### Common commands

From repo root (`/workspace`):

```bash
flutter pub get          # install Dart deps (also runs on VM startup)
flutter analyze          # static analysis
flutter test             # widget tests (if present)
flutter build apk --release --android-skip-build-dependency-validation
```

**Run in Chrome (recommended for Cloud Agents):**

```bash
# One-time if web/ is missing:
flutter create . --platforms=web

flutter run -d chrome --web-port=8080 --web-browser-flag="--no-sandbox"

# Headless alternative (serve only; drive the browser yourself). This is the
# form validated during env setup:
flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0
```

App URL: `http://127.0.0.1:8080` (first web compile takes ~30s).

**Android APK build** (not provisioned by default): install the Android SDK + JDK 17 first, then:

```bash
flutter build apk --debug --android-skip-build-dependency-validation
```

Ensure `android/local.properties` exists with `sdk.dir` and `flutter.sdk` (Flutter usually generates these on first build), and set `JAVA_HOME` to a JDK 17 install.

### Known gotchas

1. **Design system:** Shared luxury primitives live under `lib/shared/widgets/luxury/` (`LuxuryGlassPanel`, `LuxuryNeumorphicCard`, `LuxuryHubCard`). Motion/haptics: `lib/core/theme/kayan_motion.dart`. `flutter analyze` may report many info-level lints; release APK builds succeed on `main`.

2. **GoRouter redirect loop on first launch (web):** If both `language_region_done` and `seen_onboarding` are false, guards can bounce between `/language-region` and `/onboarding`. Clear site data in Chrome DevTools, or ensure onboarding redirect only runs after language/region is saved (`hasSelectedRegion == true`).

3. **No KVM / emulator:** Do not rely on `emulator -avd …` in this VM. Use `flutter run -d chrome` for interactive testing.

4. **Mock auth:** Phone OTP accepts any 6 digits after the simulated delay. Guest/skip flows may be available on auth screens.

5. **Outbound HTTPS:** Mock images use `picsum.photos`; `google_fonts` loads fonts at runtime — network is required for full UI fidelity.

6. **Firebase / Maps / Stripe:** Documented in `README.md` and `SETUP_COMPLETE.md` but not required for mock-data development.

7. **Branding assets:** Launcher icon and in-app logo must be separate owner files: `assets/images/kayan_icon.webp` (square 3D knot) and `assets/images/kayan_logo.png` (KAYAN + GULF SUPER APP wordmark). Do **not** use or crop legacy `1009078094.png` (gold K mark). After replacing files run `python3 scripts/install_kayan_branding.py` then rebuild APK.

### Manual test flow (hello world)

1. Open `http://127.0.0.1:8080` after `flutter run -d chrome`.
2. Select language/region → onboarding (skip ok) → phone auth (any number + 6-digit OTP) → profile setup.
3. Dashboard → **Shopping Store** → open a product detail page.
