#!/usr/bin/env bash
# setup_gemini.sh — Phân phối .env (Gemini config) tới tất cả app dirs trong repo.
# Chạy: bash setup_gemini.sh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
ENV_SRC="$ROOT/.env"

if [[ ! -f "$ENV_SRC" ]]; then
  echo "ERROR: $ENV_SRC not found"; exit 1
fi

echo "=== Distributing .env to all app directories ==="
count=0

# Find all directories containing requirements.txt (excluding .venv)
while IFS= read -r req; do
  dir="$(dirname "$req")"
  if [[ "$dir" == "$ROOT" ]]; then continue; fi
  cp -f "$ENV_SRC" "$dir/.env" 2>/dev/null || true
  ((count++))
done < <(find "$ROOT" -name requirements.txt -not -path '*/.venv/*' -not -path '*/node_modules/*')

echo "Copied .env to $count directories."

echo ""
echo "=== Files with hardcoded OpenAI model names ==="
# Show files that hardcode gpt-4o, gpt-3.5 etc. (for manual review)
grep -rn --include='*.py' -E '"gpt-[34][^"]*"' "$ROOT" \
  --exclude-dir='.venv' --exclude-dir='node_modules' --exclude-dir='__pycache__' \
  | grep -v '.venv/' || echo "(none found)"

echo ""
echo "Done. Review hardcoded model names above and patch as needed."
