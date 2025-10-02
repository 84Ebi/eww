#!/usr/bin/env bash
set -euo pipefail

# If there's an argument, treat it as the text, else read stdin
if [ $# -ge 1 ]; then
  ENTRY="$1"
else
  ENTRY="$(cat -)"
fi

# Copy to system clipboard (wl-copy preferred, else xclip/xsel)
if command -v wl-copy >/dev/null 2>&1; then
  printf '%s' "$ENTRY" | wl-copy
elif command -v xclip >/dev/null 2>&1; then
  printf '%s' "$ENTRY" | xclip -selection clipboard
elif command -v xsel >/dev/null 2>&1; then
  printf '%s' "$ENTRY" | xsel --clipboard --input
else
  echo "No supported clipboard utility found (wl-copy/xclip/xsel)" >&2
  exit 1
fi
