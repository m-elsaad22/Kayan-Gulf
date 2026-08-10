#!/usr/bin/env bash
# Build a REAL production release APK (mock OFF, HTTPS API, status via API + cPanel fallback).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

export ANDROID_HOME="${ANDROID_HOME:-/workspace/.android-sdk}"
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"

API_URL="${KAYAN_API_BASE_URL:-}"
if [[ -z "$API_URL" ]]; then
  echo "ERROR: Set KAYAN_API_BASE_URL to your production HTTPS API (…/v1)." >&2
  echo "Example: KAYAN_API_BASE_URL=https://api.example.com/v1 $0" >&2
  exit 1
fi
if [[ "$API_URL" != https://* ]]; then
  echo "ERROR: KAYAN_API_BASE_URL must use https://" >&2
  exit 1
fi
if [[ "$API_URL" == *"127.0.0.1"* ]] || [[ "$API_URL" == *"localhost"* ]]; then
  echo "ERROR: Production APK must not point at localhost." >&2
  exit 1
fi

STATUS_URL="${KAYAN_STATUS_URL:-https://www.rukn-eltatawer.com/kayan/status.json}"
PUBLISHER_URL="${KAYAN_PUBLISHER_URL:-https://www.rukn-eltatawer.com/}"
REQUIRE_STATUS="${KAYAN_REQUIRE_REMOTE_STATUS:-true}"
GOOGLE_CLIENT="${KAYAN_GOOGLE_SERVER_CLIENT_ID:-}"

if [[ ! -f "$ROOT/android/key.properties" ]]; then
  echo "ERROR: android/key.properties missing. Configure release signing first." >&2
  echo "See docs/PLAY_STORE.md / scripts/setup_upload_keystore.sh" >&2
  exit 1
fi

echo "→ Building PRODUCTION APK"
echo "  api=$API_URL"
echo "  mock=false"
echo "  status_fallback=$STATUS_URL"

flutter pub get
ARGS=(
  build apk
  --release
  --android-skip-build-dependency-validation
  --dart-define=KAYAN_ENV=production
  --dart-define=KAYAN_USE_MOCK_DATA=false
  --dart-define=KAYAN_API_BASE_URL="$API_URL"
  --dart-define=KAYAN_REQUIRE_REMOTE_STATUS="$REQUIRE_STATUS"
  --dart-define=KAYAN_STATUS_URL="$STATUS_URL"
  --dart-define=KAYAN_PUBLISHER_URL="$PUBLISHER_URL"
)
if [[ -n "$GOOGLE_CLIENT" ]]; then
  ARGS+=(--dart-define=KAYAN_GOOGLE_SERVER_CLIENT_ID="$GOOGLE_CLIENT")
else
  echo "WARNING: KAYAN_GOOGLE_SERVER_CLIENT_ID unset — Google Sign-In may not return idToken." >&2
fi

flutter "${ARGS[@]}"

APK="$ROOT/build/app/outputs/flutter-apk/app-release.apk"
mkdir -p "$ROOT/dist"
STAMP="$(date +%Y%m%d)"
OUT="$ROOT/dist/kayan-production-$STAMP.apk"
cp "$APK" "$OUT"

cat > "$ROOT/dist/kayan-production-$STAMP.README.txt" <<EOF
KAYAN Gulf — Production Release Candidate APK
Created: $(date -u +%Y-%m-%dT%H:%M:%SZ)
API: $API_URL
Mock data: false
Status fallback: $STATUS_URL
Google server client: ${GOOGLE_CLIENT:-UNSET}

This APK talks to the real NestJS API. Ensure:
1) API is deployed with PostgreSQL + production env (docs/PRODUCTION_DEPLOYMENT.md)
2) Admin App Control is configured
3) cPanel status.json uploaded as emergency fallback
4) Google OAuth clients + SHA-1 configured (docs/GOOGLE_SIGN_IN_SETUP.md)
EOF

echo "APK: $OUT"
