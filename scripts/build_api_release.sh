#!/usr/bin/env bash
# Release APK wired to a real API (production / staging).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
API_URL="${KAYAN_API_BASE_URL:-https://api.my-domain.com/v1}"

if [[ "$API_URL" == "https://api.my-domain.com/v1" ]]; then
  echo "Warning: using placeholder API URL. Set KAYAN_API_BASE_URL to your domain." >&2
fi

cd "$ROOT"
export ANDROID_HOME="${ANDROID_HOME:-/workspace/.android-sdk}"
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"

flutter build apk --release \
  --android-skip-build-dependency-validation \
  --dart-define=KAYAN_USE_MOCK_DATA=false \
  --dart-define=KAYAN_API_BASE_URL="$API_URL"

echo "APK: build/app/outputs/flutter-apk/app-release.apk"
echo "API: $API_URL"
