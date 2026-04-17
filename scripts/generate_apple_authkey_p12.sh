#!/usr/bin/env bash
# Build a PKCS#12 from an Apple-downloaded AuthKey_*.p8 (EC private key only).
#
# ⚠️  FIREBASE / FCM / APPLE CLOUD — Do NOT upload this .p12 for APNs or App Store Connect.
#    Those consoles expect the original AuthKey_*.p8 (or Key ID + Team ID + .p8 path in CLI).
#    A converted .p12 is almost always rejected as "The credential is malformed" because the
#    server checks for a real Apple-issued certificate chain, not a local OpenSSL bundle.
#
#    Use: Project → Settings → Cloud Messaging → Apple app → APNs Authentication Key →
#    upload AuthKey_XXXXX.p8, Key ID, Team ID.
#
# PKCS#12 generation here is only for niche tools that explicitly require .p12 and accept
# synthetic bundles (rare).
#
# Default: self-signed certificate + private key (legacy PKCS#12).
# Optional: --key-only — only the private key.
#
# Usage:
#   ./scripts/generate_apple_authkey_p12.sh /path/to/AuthKey_XXXXX.p8 /path/to/out.p12 'password'
#   ./scripts/generate_apple_authkey_p12.sh --key-only AuthKey.p8 out.p12 'password'

set -euo pipefail

KEY_ONLY=0
ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --key-only) KEY_ONLY=1; shift ;;
    *) ARGS+=("$1"); shift ;;
  esac
done
set -- "${ARGS[@]}"

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 [--key-only] <AuthKey.p8> <output.p12> <password>" >&2
  exit 1
fi

KEY="$1"
OUT="$2"
PASS="$3"

if [[ ! -f "$KEY" ]]; then
  echo "Key file not found: $KEY" >&2
  exit 1
fi

if [[ "$KEY_ONLY" -eq 1 ]]; then
  openssl pkcs12 -export -legacy -nocerts \
    -out "$OUT" \
    -inkey "$KEY" \
    -name "Apple Auth Key" \
    -passout "pass:${PASS}"
else
  CERT_TMP="$(mktemp)"
  trap 'rm -f "$CERT_TMP"' EXIT
  openssl req -new -x509 -key "$KEY" -out "$CERT_TMP" -days 3650 -sha256 \
    -subj "/CN=Apple Auth Key/O=Apple Inc./C=US"
  openssl pkcs12 -export -legacy \
    -out "$OUT" \
    -inkey "$KEY" \
    -in "$CERT_TMP" \
    -name "Apple Auth Key" \
    -passout "pass:${PASS}"
fi

echo "Wrote: $OUT" >&2
echo >&2 ""
echo >&2 "If Firebase/Apple said 'credential is malformed': stop using this .p12 — upload the"
echo >&2 "original .p8 in Firebase Console (APNs Authentication Key), with Key ID + Team ID."
