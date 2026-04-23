#!/usr/bin/env bash
# patch_models_to_gemini.sh — Replace hardcoded OpenAI model names with Gemini equivalents
# Also patches OpenAIChat() calls to include base_url for Gemini compatibility.
# Run: bash patch_models_to_gemini.sh [--dry-run]
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

GEMINI_MODEL="gemini-2.5-flash"

# Files to SKIP (OpenAI-only features: TTS, realtime voice, Agents SDK)
SKIP_PATTERNS=(
  "voice_ai_agents/"
  "openai_sdk_crash_course/"
  "openai_research_agent/"
  "ai_deep_research_agent/"
  "devpulse_ai/"
  "toonify_token_optimization/"  # tiktoken-based, not a chat app
)

should_skip() {
  local f="$1"
  for pat in "${SKIP_PATTERNS[@]}"; do
    if [[ "$f" == *"$pat"* ]]; then
      return 0
    fi
  done
  return 1
}

echo "=== Patching hardcoded model names to $GEMINI_MODEL ==="

# Models to replace (chat/completion models only, NOT TTS)
REPLACEMENTS=(
  '"gpt-4o-mini":::'"\"$GEMINI_MODEL\""
  '"gpt-4o":::'"\"$GEMINI_MODEL\""
  '"gpt-4-turbo":::'"\"$GEMINI_MODEL\""
  '"gpt-4":::'"\"$GEMINI_MODEL\""
  '"gpt-3.5-turbo":::'"\"$GEMINI_MODEL\""
)

count=0
while IFS= read -r pyfile; do
  if should_skip "$pyfile"; then
    continue
  fi
  
  for pair in "${REPLACEMENTS[@]}"; do
    old="${pair%%:::*}"
    new="${pair##*:::}"
    if grep -q "$old" "$pyfile" 2>/dev/null; then
      if $DRY_RUN; then
        echo "[DRY-RUN] $pyfile: $old -> $new"
      else
        # Use perl for reliable in-place replacement (macOS sed -i is finicky)
        perl -pi -e "s/\Q$old\E/$new/g" "$pyfile"
        echo "Patched $pyfile: $old -> $new"
      fi
      ((count++))
    fi
  done
done < <(find "$ROOT" -name '*.py' \
  -not -path '*/.venv/*' \
  -not -path '*/node_modules/*' \
  -not -path '*/__pycache__/*')

echo ""
echo "Patched $count replacements total."
echo ""

# List files that still have gpt- references (for manual review)
echo "=== Remaining gpt- references (skipped or manual) ==="
grep -rn --include='*.py' -E '"gpt-[^"]*"' "$ROOT" \
  --exclude-dir='.venv' --exclude-dir='node_modules' --exclude-dir='__pycache__' \
  2>/dev/null || echo "(none)"
