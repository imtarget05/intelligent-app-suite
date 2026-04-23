#!/usr/bin/env bash
# ============================================================
#  run_local.sh — Chạy các RAG app local (không cần API key)
# ============================================================
set -e

BASE="$(cd "$(dirname "$0")" && pwd)"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

banner() { echo -e "\n${CYAN}══════════════════════════════════════${NC}"; echo -e "${CYAN}  $1${NC}"; echo -e "${CYAN}══════════════════════════════════════${NC}"; }
ok()     { echo -e "${GREEN}✔ $1${NC}"; }
warn()   { echo -e "${YELLOW}⚠ $1${NC}"; }
err()    { echo -e "${RED}✘ $1${NC}"; }

# ── Danh sách apps ──────────────────────────────────────────
declare -A APPS=(
  [1]="llama3.1_local_rag|llama3.1_local_rag.py|8501|llama3.1"
  [2]="agentic_rag_embedding_gemma|agentic_rag_embeddinggemma.py|8502|llama3.2 embeddinggemma:latest"
  [3]="local_rag_agent|local_rag_agent.py|8503|llama3.2"
  [4]="deepseek_local_rag_agent|deepseek_rag_agent.py|8504|deepseek-r1:1.5b"
  [5]="qwen_local_rag|qwen_local_rag_agent.py|8505|qwen3:1.7b"
)

check_ollama() {
  banner "Kiểm tra Ollama"
  if ! command -v ollama &>/dev/null; then
    err "Ollama chưa cài. Cài tại: https://ollama.com"
    exit 1
  fi
  if ! ollama list &>/dev/null; then
    err "Ollama chưa chạy. Khởi động bằng: ollama serve"
    exit 1
  fi
  ok "Ollama đang chạy"
}

pull_models() {
  banner "Kéo Ollama models"
  local models=("$@")
  for model in "${models[@]}"; do
    if ollama list | grep -q "^${model}"; then
      ok "Model $model đã có"
    else
      warn "Đang tải $model ..."
      ollama pull "$model"
      ok "$model đã tải xong"
    fi
  done
}

setup_venv() {
  local dir="$1"
  if [ ! -f "$dir/.venv/bin/python" ]; then
    warn "Tạo venv cho $dir ..."
    python3 -m venv "$dir/.venv"
    "$dir/.venv/bin/pip" install -r "$dir/requirements.txt" beautifulsoup4 lxml chromadb langchain-text-splitters -q
    ok "venv đã sẵn sàng"
  else
    ok "venv đã có"
  fi
}

run_app() {
  local folder="$1"
  local script="$2"
  local port="$3"
  local dir="$BASE/$folder"

  banner "Chạy: $folder  →  http://localhost:$port"
  setup_venv "$dir"
  echo -e "${GREEN}Mở trình duyệt: http://localhost:${port}${NC}"
  cd "$dir"
  .venv/bin/streamlit run "$script" --server.port "$port"
}

# ── Menu ────────────────────────────────────────────────────
show_menu() {
  banner "🚀 RAG Local Apps"
  echo ""
  for key in $(echo "${!APPS[@]}" | tr ' ' '\n' | sort -n); do
    IFS='|' read -r folder _ port models <<< "${APPS[$key]}"
    printf "  ${YELLOW}[%s]${NC} %-40s  :%-5s  models: %s\n" "$key" "$folder" "$port" "$models"
  done
  echo ""
  echo -e "  ${YELLOW}[0]${NC} Pull tất cả models cần thiết"
  echo -e "  ${YELLOW}[q]${NC} Thoát"
  echo ""
  echo -n "Chọn app để chạy: "
}

check_ollama

while true; do
  show_menu
  read -r choice
  case "$choice" in
    0)
      all_models=()
      for key in "${!APPS[@]}"; do
        IFS='|' read -r _ _ _ models <<< "${APPS[$key]}"
        for m in $models; do all_models+=("$m"); done
      done
      pull_models "${all_models[@]}"
      ;;
    [1-5])
      IFS='|' read -r folder script port models <<< "${APPS[$choice]}"
      pull_models $models
      run_app "$folder" "$script" "$port"
      ;;
    q|Q) echo "Thoát."; exit 0 ;;
    *) warn "Lựa chọn không hợp lệ" ;;
  esac
done
