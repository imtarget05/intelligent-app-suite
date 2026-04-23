#!/usr/bin/env zsh
# start_all_apps.sh — Launch ALL RAG tutorial apps (local + cloud)
# Auto-loads central .env at project root. Run: ./start_all_apps.sh

set -u

BASE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$BASE/.." && pwd)"

# Auto-load central .env
if [[ -f "$ROOT/.env" ]]; then
  set -a
  source "$ROOT/.env"
  set +a
  echo "Loaded $ROOT/.env"
fi

: "${OPENAI_API_KEY:?OPENAI_API_KEY missing (check $ROOT/.env)}"
: "${GOOGLE_API_KEY:?GOOGLE_API_KEY missing (check $ROOT/.env)}"
export GEMINI_API_KEY="${GEMINI_API_KEY:-$GOOGLE_API_KEY}"
export ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}"
export ANTHROPIC_BASE_URL="${ANTHROPIC_BASE_URL:-}"
export TAVILY_API_KEY="${TAVILY_API_KEY:-}"
export COHERE_API_KEY="${COHERE_API_KEY:-}"
export RAGIE_API_KEY="${RAGIE_API_KEY:-}"
export CONTEXTUAL_API_KEY="${CONTEXTUAL_API_KEY:-}"
export QDRANT_URL="${QDRANT_URL:-http://localhost:6333}"
export NEO4J_URI="${NEO4J_URI:-bolt://localhost:7687}"
export NEO4J_USERNAME="${NEO4J_USERNAME:-neo4j}"
export NEO4J_PASSWORD="${NEO4J_PASSWORD:-}"

# ── helpers ──────────────────────────────────────────────────────────────────
SKIP_LIST=()

ensure_venv() {
  local app_dir="$1"
  local name="$(basename "$app_dir")"
  if [[ ! -x "$app_dir/.venv/bin/streamlit" ]]; then
    echo "  [setup] $name: creating venv"
    python3 -m venv "$app_dir/.venv" >/dev/null 2>&1 || { echo "    [fail] venv creation"; return 1; }
    "$app_dir/.venv/bin/pip" install -q --upgrade pip >/dev/null 2>&1
    local piplog="/tmp/pip_${name}.log"
    if [[ -f "$app_dir/requirements.txt" ]]; then
      if ! "$app_dir/.venv/bin/pip" install -q -r "$app_dir/requirements.txt" >"$piplog" 2>&1; then
        echo "    [fail] pip install — see $piplog"
        return 1
      fi
    fi
    "$app_dir/.venv/bin/pip" install -q streamlit python-dotenv >/dev/null 2>&1
  fi
  return 0
}

start_app() {
  local port="$1" app_dir="$2" script="$3" label="$4"

  if ! ensure_venv "$app_dir"; then
    echo "  :$port  SKIP $label (venv/pip failed)"
    SKIP_LIST+=("$port:$label")
    return
  fi

  lsof -ti tcp:"$port" 2>/dev/null | xargs -r kill -9 2>/dev/null || true
  local log="/tmp/app_${port}.log"

  # Launch with all env vars passed directly (no eval, no string injection)
  (
    cd "$(dirname "$script")" && \
    OPENAI_API_KEY="$OPENAI_API_KEY" \
    GOOGLE_API_KEY="$GOOGLE_API_KEY" \
    GEMINI_API_KEY="$GEMINI_API_KEY" \
    ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY" \
    ANTHROPIC_BASE_URL="$ANTHROPIC_BASE_URL" \
    TAVILY_API_KEY="$TAVILY_API_KEY" \
    COHERE_API_KEY="$COHERE_API_KEY" \
    RAGIE_API_KEY="$RAGIE_API_KEY" \
    CONTEXTUAL_API_KEY="$CONTEXTUAL_API_KEY" \
    QDRANT_URL="$QDRANT_URL" \
    NEO4J_URI="$NEO4J_URI" NEO4J_USERNAME="$NEO4J_USERNAME" NEO4J_PASSWORD="$NEO4J_PASSWORD" \
    nohup "$app_dir/.venv/bin/streamlit" run "$script" \
      --server.port "$port" --server.headless true \
      >"$log" 2>&1 &
  )
  echo "  :$port  $label  (log: $log)"
}

echo "=== Starting Docker services ==="
docker start qdrant 2>/dev/null || docker run -d --name qdrant -p 6333:6333 qdrant/qdrant 2>/dev/null && echo "  Qdrant :6333"
docker start neo4j  2>/dev/null || docker run -d --name neo4j  -p 7474:7474 -p 7687:7687 -e NEO4J_AUTH=none neo4j:latest 2>/dev/null && echo "  Neo4j  :7687"

sleep 3

echo ""
echo "=== Starting local apps (Ollama-based) ==="
start_app 8501 "$BASE/llama3.1_local_rag"              "$BASE/llama3.1_local_rag/llama3.1_local_rag.py"                 "llama3.1_local_rag"
start_app 8502 "$BASE/agentic_rag_embedding_gemma"     "$BASE/agentic_rag_embedding_gemma/agentic_rag_embeddinggemma.py" "agentic_rag_embedding_gemma"
start_app 8503 "$BASE/local_rag_agent"                 "$BASE/local_rag_agent/local_rag_agent.py"                       "local_rag_agent"
start_app 8504 "$BASE/deepseek_local_rag_agent"        "$BASE/deepseek_local_rag_agent/deepseek_rag_agent.py"           "deepseek_local_rag_agent"

echo ""
echo "=== Starting cloud apps (OpenAI + Gemini) ==="
start_app 8505 "$BASE/qwen_local_rag"                  "$BASE/qwen_local_rag/qwen_local_rag_agent.py"                   "qwen_local_rag"
start_app 8506 "$BASE/agentic_rag_gpt5"                "$BASE/agentic_rag_gpt5/agentic_rag_gpt5.py"                     "agentic_rag_gpt5"
start_app 8507 "$BASE/agentic_rag_with_reasoning"      "$BASE/agentic_rag_with_reasoning/rag_reasoning_agent.py"        "agentic_rag_with_reasoning"
start_app 8508 "$BASE/autonomous_rag"                  "$BASE/autonomous_rag/autorag.py"                                "autonomous_rag"
start_app 8509 "$BASE/rag_chain"                       "$BASE/rag_chain/app.py"                                         "rag_chain"
start_app 8510 "$BASE/rag_database_routing"            "$BASE/rag_database_routing/rag_database_routing.py"             "rag_database_routing"
start_app 8511 "$BASE/agentic_rag_math_agent"          "$BASE/agentic_rag_math_agent/app/streamlit.py"                  "agentic_rag_math_agent"
start_app 8512 "$BASE/ai_blog_search"                  "$BASE/ai_blog_search/app.py"                                    "ai_blog_search"
start_app 8513 "$BASE/gemini_agentic_rag"              "$BASE/gemini_agentic_rag/agentic_rag_gemini.py"                 "gemini_agentic_rag"
start_app 8514 "$BASE/knowledge_graph_rag_citations"   "$BASE/knowledge_graph_rag_citations/knowledge_graph_rag.py"     "knowledge_graph_rag_citations"

echo ""
echo "=== Starting extra apps (Anthropic→Gemini patched, Cohere/Ragie/Contextual) ==="
start_app 8515 "$BASE/corrective_rag"                  "$BASE/corrective_rag/corrective_rag.py"                         "corrective_rag"
start_app 8516 "$BASE/hybrid_search_rag"               "$BASE/hybrid_search_rag/main.py"                                "hybrid_search_rag"
start_app 8517 "$BASE/rag-as-a-service"                "$BASE/rag-as-a-service/rag_app.py"                              "rag-as-a-service"
start_app 8518 "$BASE/rag_agent_cohere"                "$BASE/rag_agent_cohere/rag_agent_cohere.py"                     "rag_agent_cohere"
start_app 8519 "$BASE/contextualai_rag_agent"          "$BASE/contextualai_rag_agent/contextualai_rag_agent.py"         "contextualai_rag_agent"
start_app 8520 "$BASE/vision_rag"                      "$BASE/vision_rag/vision_rag.py"                                 "vision_rag"
start_app 8521 "$BASE/local_hybrid_search_rag"         "$BASE/local_hybrid_search_rag/local_main.py"                    "local_hybrid_search_rag"

echo ""
echo "=== Waiting 15s for apps to start... ==="
sleep 15

echo ""
echo "=== Health check ==="
ok_count=0
fail_count=0
PORTS=(8501 8502 8503 8504 8505 8506 8507 8508 8509 8510 8511 8512 8513 8514 8515 8516 8517 8518 8519 8520 8521)
for port in $PORTS; do
  code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 "http://localhost:$port" 2>/dev/null)
  if [[ "$code" == "200" ]] || [[ "$code" == "302" ]]; then
    echo "  :$port  ✓"
    ok_count=$((ok_count+1))
  else
    echo "  :$port  ✗  (code=$code)  → tail -30 /tmp/app_${port}.log"
    fail_count=$((fail_count+1))
  fi
done

echo ""
echo "Summary: $ok_count OK / $fail_count FAIL / ${#SKIP_LIST[@]} SKIP"
if (( ${#SKIP_LIST[@]} > 0 )); then
  echo "Skipped (venv/pip): ${SKIP_LIST[*]}"
fi

echo ""
echo "=== CLI-only (not Streamlit) ==="
echo "  rag_failure_diagnostics_clinic — python rag_failure_diagnostics_clinic.py"
echo ""
echo "Stop all: for p in {8501..8521}; do lsof -ti tcp:\$p | xargs kill -9 2>/dev/null; done"
