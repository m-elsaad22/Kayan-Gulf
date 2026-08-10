#!/usr/bin/env bash
# Build a distributable release APK for end users (sideload / direct download).
# Default: mock data ON + remote kill-switch on rukn-eltatawer.com
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

export ANDROID_HOME="${ANDROID_HOME:-/workspace/.android-sdk}"
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"

STATUS_URL="${KAYAN_STATUS_URL:-https://www.rukn-eltatawer.com/kayan/status.json}"
PUBLISHER_URL="${KAYAN_PUBLISHER_URL:-https://www.rukn-eltatawer.com/}"
USE_MOCK="${KAYAN_USE_MOCK_DATA:-true}"
REQUIRE_STATUS="${KAYAN_REQUIRE_REMOTE_STATUS:-true}"

# Ensure a signing key exists (do not commit secrets/)
if [[ ! -f "$ROOT/android/key.properties" ]]; then
  echo "→ Creating local upload keystore for distribution signing..."
  mkdir -p "$ROOT/secrets"
  if [[ ! -f "$ROOT/secrets/kayan-upload.jks" ]]; then
    keytool -genkeypair -v \
      -keystore "$ROOT/secrets/kayan-upload.jks" \
      -storetype JKS \
      -keyalg RSA -keysize 2048 -validity 10000 \
      -alias kayan \
      -storepass "kayan-dist-change-me" \
      -keypass "kayan-dist-change-me" \
      -dname "CN=KAYAN Distribution, OU=Mobile, O=Rukn Eltatawer, L=Riyadh, ST=Riyadh, C=SA"
  fi
  cat > "$ROOT/android/key.properties" <<EOF
storePassword=kayan-dist-change-me
keyPassword=kayan-dist-change-me
keyAlias=kayan
storeFile=../../secrets/kayan-upload.jks
EOF
  echo "  (Back up secrets/kayan-upload.jks — required for future APK updates)"
fi

echo "→ Building distribution APK"
echo "  mock=$USE_MOCK"
echo "  status=$STATUS_URL"
echo "  publisher=$PUBLISHER_URL"

flutter pub get
ARGS=(
  build apk
  --release
  --android-skip-build-dependency-validation
  --dart-define=KAYAN_USE_MOCK_DATA="$USE_MOCK"
  --dart-define=KAYAN_REQUIRE_REMOTE_STATUS="$REQUIRE_STATUS"
  --dart-define=KAYAN_STATUS_URL="$STATUS_URL"
  --dart-define=KAYAN_PUBLISHER_URL="$PUBLISHER_URL"
)
if [[ -n "${KAYAN_GOOGLE_SERVER_CLIENT_ID:-}" ]]; then
  ARGS+=(--dart-define=KAYAN_GOOGLE_SERVER_CLIENT_ID="$KAYAN_GOOGLE_SERVER_CLIENT_ID")
fi
if [[ -n "${KAYAN_API_BASE_URL:-}" ]]; then
  ARGS+=(--dart-define=KAYAN_API_BASE_URL="$KAYAN_API_BASE_URL")
fi

flutter "${ARGS[@]}"

APK="$ROOT/build/app/outputs/flutter-apk/app-release.apk"
mkdir -p "$ROOT/dist"
STAMP="$(date +%Y%m%d)"
OUT="$ROOT/dist/kayan-rukn-$STAMP.apk"
cp "$APK" "$OUT"

cat > "$ROOT/dist/kayan-rukn-$STAMP.README.txt" <<EOF
KAYAN — APK للتوزيع عبر ركن التطور
Created: $(date -u +%Y-%m-%dT%H:%M:%SZ)
Mock data: $USE_MOCK
Status URL: $STATUS_URL
Publisher: $PUBLISHER_URL

1) ارفع hosting/cpanel/kayan/* إلى public_html/kayan/ على cPanel
2) تأكد أن status.json يعيد enabled=true
3) وزّع هذا الـ APK (تثبيت مباشر / رابط تحميل من الموقع)
4) لإيقاف الجميع: enabled=false أو احذف الملف من cPanel

احتفظ بنسخة من secrets/kayan-upload.jks لتحديثات APK القادمة بنفس التوقيع.
EOF

echo "APK: $OUT"
