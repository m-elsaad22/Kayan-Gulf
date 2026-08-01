#!/usr/bin/env bash
# Build release APK and package into a downloadable ZIP.
# Usage: ./scripts/package_phase_zip.sh phase-3-services 1.0.0
set -euo pipefail

PHASE="${1:-build}"
VERSION="${2:-1.0.0}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

mkdir -p dist
flutter pub get
flutter build apk --release --android-skip-build-dependency-validation

STAGE="$ROOT/dist/stage-$PHASE"
rm -rf "$STAGE"
mkdir -p "$STAGE"
cp build/app/outputs/flutter-apk/app-release.apk "$STAGE/kayan-app.apk"
cat > "$STAGE/README.txt" <<EOF
KAYAN Gulf Super App
Phase: $PHASE
Version: $VERSION
APK: kayan-app.apk (install on Android)
EOF

ZIP="$ROOT/dist/kayan-${PHASE}-${VERSION}.zip"
rm -f "$ZIP"
(cd "$STAGE" && zip -r "$ZIP" .)
echo "Created $ZIP"
