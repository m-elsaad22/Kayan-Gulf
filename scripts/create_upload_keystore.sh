#!/usr/bin/env bash
# Create a Google Play upload keystore (keep offline backups!).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="${1:-$ROOT/secrets}"
ALIAS="${KEY_ALIAS:-kayan}"
JKS="$OUT_DIR/kayan-upload.jks"

mkdir -p "$OUT_DIR"
if [[ -f "$JKS" ]]; then
  echo "Keystore already exists: $JKS" >&2
  exit 1
fi

echo "Creating upload keystore at $JKS"
keytool -genkeypair -v \
  -keystore "$JKS" \
  -storetype JKS \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias "$ALIAS" \
  -dname "CN=KAYAN Gulf, OU=Mobile, O=KAYAN, L=Riyadh, ST=Riyadh, C=SA"

cat <<EOF

Next:
  1. Copy android/key.properties.example → android/key.properties
  2. Fill storePassword / keyPassword / keyAlias=$ALIAS
  3. Set storeFile=../../secrets/kayan-upload.jks
  4. Build: ./scripts/build_play_bundle.sh
  5. Back up $JKS + passwords offline (Play App Signing enrollment)

EOF
