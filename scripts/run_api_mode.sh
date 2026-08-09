#!/usr/bin/env bash
# Run Flutter against the local KAYAN NestJS API (Phase 1).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
API_URL="${KAYAN_API_BASE_URL:-http://127.0.0.1:3000/v1}"
DEVICE="${1:-chrome}"

echo "→ API: $API_URL"
echo "→ Device: $DEVICE"
echo "  Ensure backend is running: (cd backend && npm run start:dev)"

cd "$ROOT"
export ANDROID_HOME="${ANDROID_HOME:-/workspace/.android-sdk}"
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"

if [[ "$DEVICE" == "chrome" ]]; then
  exec flutter run -d chrome --web-port=8080 \
    --web-browser-flag="--no-sandbox" \
    --dart-define=KAYAN_USE_MOCK_DATA=false \
    --dart-define=KAYAN_API_BASE_URL="$API_URL"
fi

exec flutter run -d "$DEVICE" \
  --dart-define=KAYAN_USE_MOCK_DATA=false \
  --dart-define=KAYAN_API_BASE_URL="$API_URL"
