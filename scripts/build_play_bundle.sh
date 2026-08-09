#!/usr/bin/env bash
# Build a signed Android App Bundle (AAB) for Google Play upload.
#
# Required:
#   - Flutter + Android SDK
#   - android/key.properties (see key.properties.example)
#   - KAYAN_API_BASE_URL pointing at production/staging API
#
# Optional env:
#   KAYAN_ENABLE_FIREBASE=true
#   BUILD_NAME / BUILD_NUMBER  (override pubspec version)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

API_URL="${KAYAN_API_BASE_URL:-}"
if [[ -z "$API_URL" ]]; then
  echo "Error: set KAYAN_API_BASE_URL (e.g. https://api.your-domain.com/v1)" >&2
  exit 1
fi

KEYPROPS="$ROOT/android/key.properties"
if [[ ! -f "$KEYPROPS" ]]; then
  echo "Error: missing $KEYPROPS — copy key.properties.example and fill secrets." >&2
  exit 1
fi

export ANDROID_HOME="${ANDROID_HOME:-/workspace/.android-sdk}"
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"

BUILD_NAME="${BUILD_NAME:-}"
BUILD_NUMBER="${BUILD_NUMBER:-}"
FIREBASE_FLAG="${KAYAN_ENABLE_FIREBASE:-false}"

ARGS=(
  build appbundle
  --release
  --android-skip-build-dependency-validation
  --dart-define=KAYAN_USE_MOCK_DATA=false
  --dart-define=KAYAN_API_BASE_URL="$API_URL"
  --dart-define=KAYAN_ENABLE_FIREBASE="$FIREBASE_FLAG"
)

if [[ -n "$BUILD_NAME" ]]; then
  ARGS+=(--build-name="$BUILD_NAME")
fi
if [[ -n "$BUILD_NUMBER" ]]; then
  ARGS+=(--build-number="$BUILD_NUMBER")
fi

echo "→ flutter ${ARGS[*]}"
flutter pub get
flutter "${ARGS[@]}"

AAB="$ROOT/build/app/outputs/bundle/release/app-release.aab"
mkdir -p "$ROOT/dist"
STAMP="$(date +%Y%m%d)"
OUT="$ROOT/dist/kayan-play-${STAMP}.aab"
cp "$AAB" "$OUT"

cat > "$ROOT/dist/kayan-play-${STAMP}.README.txt" <<EOF
KAYAN Gulf — Google Play upload bundle
Created: $(date -u +%Y-%m-%dT%H:%M:%SZ)
API: $API_URL
Mock: false
Firebase flag: $FIREBASE_FLAG
AAB: $(basename "$OUT")

Upload in Play Console → Production / Internal testing → Create release.
See docs/PLAY_STORE.md for listing checklist (AR/EN).
EOF

echo "AAB: $OUT"
echo "README: dist/kayan-play-${STAMP}.README.txt"
