#!/usr/bin/env bash
# Build a REAL production release APK (mock OFF, HTTPS API, Rukn brand defines).
#
# Does NOT deploy anything. Requires you to pass a real HTTPS API once DNS+server exist.
# Planned production API host (not assumed live): https://api.rukn-eltatawer.com/v1
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

export ANDROID_HOME="${ANDROID_HOME:-/workspace/.android-sdk}"
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"

API_URL="${KAYAN_API_BASE_URL:-}"
if [[ -z "$API_URL" ]]; then
  echo "ERROR: Set KAYAN_API_BASE_URL to your production HTTPS API (…/v1)." >&2
  echo "When DNS exists: KAYAN_API_BASE_URL=https://api.rukn-eltatawer.com/v1 $0" >&2
  exit 1
fi
if [[ "$API_URL" != https://* ]]; then
  echo "ERROR: KAYAN_API_BASE_URL must use https://" >&2
  exit 1
fi
if [[ "$API_URL" == *"127.0.0.1"* ]] || [[ "$API_URL" == *"localhost"* ]] || [[ "$API_URL" == *"10.0.2.2"* ]]; then
  echo "ERROR: Production APK must not point at localhost / emulator hosts." >&2
  exit 1
fi
if [[ "$API_URL" == *"kayan.gulf"* ]]; then
  echo "ERROR: Placeholder host api.kayan.gulf is forbidden in production builds." >&2
  exit 1
fi

STATUS_URL="${KAYAN_STATUS_URL:-https://www.rukn-eltatawer.com/kayan/status.json}"
WEBSITE_URL="${KAYAN_WEBSITE_URL:-https://www.rukn-eltatawer.com/}"
PUBLISHER_URL="${KAYAN_PUBLISHER_URL:-$WEBSITE_URL}"
SUPPORT_URL="${KAYAN_SUPPORT_URL:-$WEBSITE_URL}"
PRIVACY_URL="${KAYAN_PRIVACY_URL:-https://www.rukn-eltatawer.com/privacy}"
TERMS_URL="${KAYAN_TERMS_URL:-https://www.rukn-eltatawer.com/terms}"
APP_DOWNLOAD_URL="${KAYAN_APP_DOWNLOAD_URL:-https://www.rukn-eltatawer.com/kayan/}"
REQUIRE_STATUS="${KAYAN_REQUIRE_REMOTE_STATUS:-true}"
GOOGLE_CLIENT="${KAYAN_GOOGLE_SERVER_CLIENT_ID:-}"

if [[ ! -f "$ROOT/android/key.properties" ]]; then
  echo "ERROR: android/key.properties missing. Configure release signing first." >&2
  exit 1
fi

echo "→ Building PRODUCTION APK (code-ready; does not deploy servers)"
echo "  api=$API_URL"
echo "  website=$WEBSITE_URL"
echo "  mock=false"

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
  --dart-define=KAYAN_WEBSITE_URL="$WEBSITE_URL"
  --dart-define=KAYAN_SUPPORT_URL="$SUPPORT_URL"
  --dart-define=KAYAN_PRIVACY_URL="$PRIVACY_URL"
  --dart-define=KAYAN_TERMS_URL="$TERMS_URL"
  --dart-define=KAYAN_APP_DOWNLOAD_URL="$APP_DOWNLOAD_URL"
)
if [[ -n "${KAYAN_WHATSAPP_URL:-}" ]]; then
  ARGS+=(--dart-define=KAYAN_WHATSAPP_URL="$KAYAN_WHATSAPP_URL")
fi
if [[ -n "${KAYAN_PHONE_URL:-}" ]]; then
  ARGS+=(--dart-define=KAYAN_PHONE_URL="$KAYAN_PHONE_URL")
fi
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
KAYAN / Rukn El Tatawer — Production APK build artifact
Created: $(date -u +%Y-%m-%dT%H:%M:%SZ)
API: $API_URL
Website: $WEBSITE_URL
Mock data: false

CODE READY FOR PRODUCTION DEPLOYMENT — not "production deployed".
Ensure API DNS/server, Google OAuth, and cPanel fallback upload before customer distribution.
See docs/RUKN_ELTATAWER_INTEGRATION.md and docs/FINAL_RELEASE_CHECKLIST.md
EOF

echo "APK: $OUT"
