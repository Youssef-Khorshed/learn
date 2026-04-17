#!/usr/bin/env bash
# Build a PKCS#12 from a CSR and the *same* private key that was used to create that CSR.
#
# This creates a self-signed X.509 from the CSR (ok for local/dev TLS tests only).
# For Apple (APNs, distribution): submit the CSR in Apple Developer, download the signed
# certificate, then run openssl pkcs12 -export with private.key + Apple-issued cert (+ chain).
#
# Usage:
#   ./scripts/generate_p12_from_csr.sh <request.csr> <private.key> <out.p12> '<password>'
# Empty password: pass '' as the last argument.
#
set -euo pipefail
if [[ $# -ne 4 ]]; then
  echo "Usage: $0 <file.csr> <private.key> <out.p12> '<password>'" >&2
  exit 1
fi
CSR="$1"
KEY="$2"
OUT="$3"
PASS="$4"

if [[ ! -f "$CSR" ]] || [[ ! -f "$KEY" ]]; then
  echo "CSR or key file not found." >&2
  exit 1
fi

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

openssl x509 -req -in "$CSR" -signkey "$KEY" -out "$TMP" -days 825 -sha256
openssl pkcs12 -export -legacy \
  -out "$OUT" \
  -inkey "$KEY" \
  -in "$TMP" \
  -name "CSR bundle" \
  -passout "pass:${PASS}"

echo "Wrote: $OUT (self-signed from CSR; not for Apple production signing)" >&2
