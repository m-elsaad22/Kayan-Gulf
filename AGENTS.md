# AGENTS.md

## Cursor Cloud specific instructions

### Product overview

KAYAN (`sa.kayan.app`) is a **Flutter mobile client** (Android in-repo; iOS not checked in). It combines e-commerce, home services, and classifieds with mock data — no backend is required for local UI development.

### Toolchain (pre-installed on the VM)

| Component | Location |
|-----------|----------|
| Flutter stable | `$HOME/flutter` |
| Android SDK 35/36 | `$HOME/Android/Sdk` |
| JDK 17 (Android builds) | `$HOME/jdk/jdk-17` |

Shell PATH is configured in `~/.bashrc`. Open a new shell or `source ~/.bashrc` if `flutter` is not found.

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
```

App URL: `http://127.0.0.1:8080`

**Android APK build** (requires JDK 17 — set `JAVA_HOME=$HOME/jdk/jdk-17`):

```bash
flutter build apk --debug --android-skip-build-dependency-validation
```

Ensure `android/local.properties` exists with `sdk.dir` and `flutter.sdk` (Flutter usually generates these on first build).

### Known gotchas

1. **`main` branch compile errors:** As of setup, `main` has Dart compile errors (missing imports, router/screen API mismatches, syntax issues). CI targets release APK builds but may fail on a clean analyze. The branch `cursor/fix-apk-dart-compile-errors-9c38` is closer to buildable; merge or cherry-pick its fixes before expecting a green `flutter build apk`.

2. **GoRouter redirect loop on first launch (web):** If both `language_region_done` and `seen_onboarding` are false, guards can bounce between `/language-region` and `/onboarding`. Clear site data in Chrome DevTools, or ensure onboarding redirect only runs after language/region is saved (`hasSelectedRegion == true`).

3. **No KVM / emulator:** Do not rely on `emulator -avd …` in this VM. Use `flutter run -d chrome` for interactive testing.

4. **Mock auth:** Phone OTP accepts any 6 digits after the simulated delay. Guest/skip flows may be available on auth screens.

5. **Outbound HTTPS:** Mock images use `picsum.photos`; `google_fonts` loads fonts at runtime — network is required for full UI fidelity.

6. **Firebase / Maps / Stripe:** Documented in `README.md` and `SETUP_COMPLETE.md` but not required for mock-data development.

### Manual test flow (hello world)

1. Open `http://127.0.0.1:8080` after `flutter run -d chrome`.
2. Select language/region → onboarding (skip ok) → phone auth (any number + 6-digit OTP) → profile setup.
3. Dashboard → **Shopping Store** → open a product detail page.
