#!/usr/bin/env bash
set -euo pipefail

HIST_FILE="$HOME/.config/eww/clipboard_history.b64"
MAX_ITEMS=40

mkdir -p "$(dirname "$HIST_FILE")"
touch "$HIST_FILE"

# Read current clipboard (prefer wl-paste, fallback to xclip/xsel).
CURRENT=""
if command -v wl-paste >/dev/null 2>&1; then
  CURRENT="$(wl-paste || true)"
elif command -v xclip >/dev/null 2>&1; then
  CURRENT="$(xclip -selection clipboard -o || true)"
elif command -v xsel >/dev/null 2>&1; then
  CURRENT="$(xsel --clipboard --output || true)"
fi

# If there's content and it's different from last entry, prepend it (base64-encoded)
if [ -n "${CURRENT:-}" ]; then
  # base64 encode (no line breaks)
  B64="$(printf '%s' "$CURRENT" | base64 | tr -d '\n')"
  LAST="$(head -n1 "$HIST_FILE" 2>/dev/null || true)"
  if [ "$B64" != "$LAST" ]; then
    printf '%s\n%s\n' "$B64" "$(cat "$HIST_FILE" 2>/dev/null || true)" > "$HIST_FILE.tmp"
    head -n "$MAX_ITEMS" "$HIST_FILE.tmp" > "$HIST_FILE"
    rm -f "$HIST_FILE.tmp"
  fi
fi

# If history empty -> output []
if [ ! -s "$HIST_FILE" ]; then
  printf "[]"
  exit 0
fi

# Output JSON array: decode each base64 line and JSON-encode safely.
first=1
printf "["
while IFS= read -r b64line; do
  # decode
  decoded="$(printf '%s' "$b64line" | { base64 --decode 2>/dev/null || base64 -d 2>/dev/null || true; } )"
  # json-encode the decoded string: prefer jq, fall back to python3
  if command -v jq >/dev/null 2>&1; then
    json="$(jq -Rn --arg s "$decoded" '$s')"
  else
    # python fallback
    json="$(python3 - <<PY
import json,sys
s = sys.stdin.read()
print(json.dumps(s))
PY
<<<"$decoded")"
  fi

  if [ $first -eq 0 ]; then printf ","; fi
  printf "%s" "$json"
  first=0
done < "$HIST_FILE"
printf "]"
