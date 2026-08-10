#!/usr/bin/env bash
# Preflight checks before a Play Store build.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
OK=0

check() {
  local label="$1"
  shift
  if "$@"; then
    echo "✓ $label"
  else
    echo "✗ $label"
    OK=1
  fi
}

check "pubspec version present" grep -q '^version:' pubspec.yaml
check "applicationId sa.kayan.app" grep -q 'applicationId "sa.kayan.app"' android/app/build.gradle
check "key.properties exists" test -f android/key.properties
check "key.properties.example tracked" test -f android/key.properties.example
check "KAYAN_API_BASE_URL set" test -n "${KAYAN_API_BASE_URL:-}"
if [[ -n "${KAYAN_API_BASE_URL:-}" ]]; then
  check "KAYAN_API_BASE_URL uses https" [[ "$KAYAN_API_BASE_URL" == https://* ]]
  check "KAYAN_API_BASE_URL not placeholder kayan.gulf" [[ "$KAYAN_API_BASE_URL" != *kayan.gulf* ]]
  check "KAYAN_API_BASE_URL not localhost" [[ "$KAYAN_API_BASE_URL" != *localhost* && "$KAYAN_API_BASE_URL" != *127.0.0.1* && "$KAYAN_API_BASE_URL" != *10.0.2.2* ]]
  check "KAYAN_USE_MOCK_DATA false for release" [[ "${KAYAN_USE_MOCK_DATA:-false}" == "false" ]]
fi
check "Flutter on PATH" command -v flutter >/dev/null
check "no google-services.json committed" ! git ls-files --error-unmatch android/app/google-services.json >/dev/null 2>&1

if [[ -f android/key.properties ]]; then
  STORE_FILE="$(grep '^storeFile=' android/key.properties | cut -d= -f2-)"
  # Resolve relative to android/app as Gradle does for file()
  if [[ -n "$STORE_FILE" ]]; then
    if [[ "$STORE_FILE" = /* ]]; then
      check "keystore file exists ($STORE_FILE)" test -f "$STORE_FILE"
    else
      check "keystore file exists (android/app/$STORE_FILE)" test -f "android/app/$STORE_FILE"
    fi
  fi
fi

VERSION="$(grep '^version:' pubspec.yaml | awk '{print $2}')"
echo
echo "pubspec version: $VERSION"
echo "API: ${KAYAN_API_BASE_URL:-<unset>}"
exit "$OK"
