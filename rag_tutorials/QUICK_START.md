# 🚀 QUICK START — 22 RAG Apps

> **Quy tắc vàng**: Mỗi app là một dự án độc lập. Luôn tạo venv riêng cho từng app để tránh xung đột thư viện.

---

## 📋 Mục lục

| # | Tên App | LLM | Vector DB | Offline? |
|---|---------|-----|-----------|----------|
| 1 | [Agentic RAG + EmbeddingGemma](#1-agentic-rag--embeddinggemma) | Llama 3.2 (Ollama) | LanceDB | ✅ |
| 2 | [Agentic RAG + GPT-5](#2-agentic-rag--gpt-5) | GPT-5 | LanceDB | ❌ |
| 3 | [Math Tutor Agentic RAG](#3-math-tutor-agentic-rag) | GPT-4.1 | Qdrant Cloud | ❌ |
| 4 | [Agentic RAG with Reasoning](#4-agentic-rag-with-reasoning) | Gemini 2.5 Flash | LanceDB | ❌ |
| 5 | [AI Blog Search](#5-ai-blog-search) | Gemini 2.0 Flash | Qdrant Cloud | ❌ |
| 6 | [Autonomous RAG](#6-autonomous-rag) | GPT-4o | PostgreSQL/PgVector | ❌ |
| 7 | [Contextual AI RAG Agent](#7-contextual-ai-rag-agent) | Contextual GLM | Contextual AI Cloud | ❌ |
| 8 | [Corrective RAG (CRAG)](#8-corrective-rag-crag) | Claude 3.5 Sonnet | Qdrant Cloud | ❌ |
| 9 | [DeepSeek Local RAG](#9-deepseek-local-rag) | DeepSeek R1 (Ollama) | Qdrant Cloud | Hybrid |
| 10 | [Gemini Agentic RAG](#10-gemini-agentic-rag) | Gemini 2.0 Flash | Qdrant Cloud | ❌ |
| 11 | [Hybrid Search RAG](#11-hybrid-search-rag) | Claude 3 Opus | PostgreSQL (Neon) | ❌ |
| 12 | [Knowledge Graph RAG](#12-knowledge-graph-rag) | Llama 3.2 (Ollama) | Neo4j (Docker) | ✅ |
| 13 | [Llama 3.1 Local RAG](#13-llama-31-local-rag) | Llama 3.1 (Ollama) | Chroma (local) | ✅ |
| 14 | [Local Hybrid Search RAG](#14-local-hybrid-search-rag) | Llama 3.2 (llama-cpp) | SQLite (local) | ✅ |
| 15 | [Local RAG Agent](#15-local-rag-agent) | Llama 3.2 (Ollama) | Qdrant (Docker) | ✅ |
| 16 | [Qwen Local RAG](#16-qwen-local-rag) | Qwen3 (Ollama) | Qdrant Cloud | Hybrid |
| 17 | [RAG-as-a-Service](#17-rag-as-a-service) | Claude 3.5 Sonnet | Ragie.ai Cloud | ❌ |
| 18 | [RAG Agent + Cohere](#18-rag-agent--cohere) | Command-R7B | Qdrant Cloud | ❌ |
| 19 | [RAG Chain (PharmaQuery)](#19-rag-chain-pharmaquery) | Gemini 1.5 Pro | ChromaDB (local) | ❌ |
| 20 | [RAG Database Routing](#20-rag-database-routing) | GPT-4o | Qdrant Cloud | ❌ |
| 21 | [RAG Failure Diagnostics](#21-rag-failure-diagnostics-clinic) | OpenAI-compatible | Không có | ❌ |
| 22 | [Vision RAG](#22-vision-rag) | Gemini 2.5 Flash | In-memory | ❌ |

---

## ⚙️ Cài đặt chung

```bash
# Cài Ollama (dùng cho các app Local)
# macOS/Linux:
curl -fsSL https://ollama.com/install.sh | sh

# Cài Docker (dùng cho Qdrant local, Neo4j, PgVector)
# https://docs.docker.com/get-docker/

# Tạo venv cho từng app (thực hiện trong thư mục app)
python -m venv .venv && source .venv/bin/activate   # macOS/Linux
python -m venv .venv && .venv\Scripts\activate       # Windows
```

---

## 1. Agentic RAG + EmbeddingGemma

```
PDF/URL ──► EmbeddingGemma (Ollama) ──► LanceDB
                                            │
User Question ──────────────────────────► Retriever ──► Llama 3.2 ──► Answer
```

**API Keys cần thiết**: Không (100% local)

**Cài Ollama models:**
```bash
ollama pull embeddinggemma:latest
ollama pull llama3.2:latest
```

**Chạy:**
```bash
cd rag_tutorials/agentic_rag_embedding_gemma
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
streamlit run agentic_rag_embeddinggemma.py
```

**Cách dùng**: Nhập URL PDF vào sidebar → nhấn "Add Source" → đặt câu hỏi trong chat.

---

## 2. Agentic RAG + GPT-5

```
URL ──► OpenAI Embeddings ──► LanceDB
                                  │
User Question ──────────────────► Retriever ──► GPT-5 ──► Answer (streaming)
```

**API Keys cần thiết**: `OPENAI_API_KEY`

**Chạy:**
```bash
cd rag_tutorials/agentic_rag_gpt5
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
export OPENAI_API_KEY="sk-..."
streamlit run agentic_rag_gpt5.py
```

**Cách dùng**: Nhập URL muốn hỏi → đặt câu hỏi. Câu trả lời streaming theo thời gian thực.

---

## 3. Math Tutor Agentic RAG

```
JEEBench Dataset ──► OpenAI Embeddings ──► Qdrant Vector DB
                                                 │
User Math Question ──► DSPy Input Guardrail ──► Router
                                                 ├── (found) ──► Qdrant ──► GPT-4.1
                                                 └── (not found) ──► Tavily Web Search ──► GPT-4o
                                                           │
                                        DSPy Output Guardrail ──► Feedback Loop ──► Answer
```

**API Keys cần thiết**: `OPENAI_API_KEY`, `TAVILY_API_KEY`, `QDRANT_API_KEY`, `QDRANT_URL`

**Chạy:**
```bash
cd rag_tutorials/agentic_rag_math_agent
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
# Tạo file .env:
echo "OPENAI_API_KEY=sk-..." > .env
echo "TAVILY_API_KEY=..." >> .env
echo "QDRANT_API_KEY=..." >> .env
echo "QDRANT_URL=https://xxx.qdrant.io" >> .env
streamlit run app/streamlit_app.py
```

**Cách dùng**: Chọn tab "Chat" → nhập câu hỏi toán học → nhận bài giải từng bước → rate 👍/👎.

---

## 4. Agentic RAG with Reasoning

```
URL ──► OpenAI Embeddings ──► LanceDB
                                  │
User Question ──► Agent ──► Retriever ──► Gemini 2.5 Flash
                    │              (ReasoningTools)
                    └──► Thinking Steps (hiển thị song song)
                                  │
                           Final Answer + Citations
```

**API Keys cần thiết**: `OPENAI_API_KEY`, `GOOGLE_API_KEY`

**Chạy:**
```bash
cd rag_tutorials/agentic_rag_with_reasoning
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
export OPENAI_API_KEY="sk-..."
export GOOGLE_API_KEY="AIza..."
streamlit run rag_reasoning_agent.py
```

**Cách dùng**: Nhập URL → đặt câu hỏi → xem quá trình suy luận ở cột trái và câu trả lời ở cột phải.

---

## 5. AI Blog Search

```
Blog URLs ──► WebBaseLoader ──► Gemini Embeddings ──► Qdrant
                                                          │
User Query ──► Grade Relevance? ──No──► Rewrite Query ──►┘
                    │ Yes
                    ▼
              Generate Answer (Gemini 2.0 Flash)
```

**API Keys cần thiết**: `GOOGLE_API_KEY`, `QDRANT_API_KEY`, `QDRANT_URL`

**Chạy:**
```bash
cd rag_tutorials/ai_blog_search
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
# Nhập API keys trực tiếp trong sidebar Streamlit
streamlit run app.py
```

**Cách dùng**: Paste URL blog vào sidebar → nhấn "Load Blogs" → đặt câu hỏi về nội dung.

---

## 6. Autonomous RAG

```
PDF Upload ──► GPT-4o Embeddings ──► PostgreSQL + PgVector
                                              │
User Question ──► Autonomous Agent ──► Vector Search ──► GPT-4o
                        │
                        └──► DuckDuckGo Web Search (fallback)
                                    │
                              Final Answer + Sources
```

**API Keys cần thiết**: `OPENAI_API_KEY`

**Yêu cầu thêm**: Docker (chạy PgVector)

**Chạy:**
```bash
# 1. Khởi động PgVector
docker run -d \
  -e POSTGRES_DB=ai \
  -e POSTGRES_USER=ai \
  -e POSTGRES_PASSWORD=ai \
  -p 5532:5432 \
  -v pgvolume:/var/lib/postgresql/data \
  agnohq/pgvector:16

# 2. Chạy app
cd rag_tutorials/autonomous_rag
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
export OPENAI_API_KEY="sk-..."
streamlit run autorag.py
```

**Cách dùng**: Upload PDF → agent tự xây dựng knowledge base → đặt câu hỏi, agent tự quyết định dùng RAG hay web search.

---

## 7. Contextual AI RAG Agent

```
Documents ──► Contextual AI Datastore (Cloud)
                          │
User Query ──► Contextual GLM ──► Grounded Answer + Citations
                    │
                    └──► Reranker ──► Retrieval Attribution (page image)
```

**API Keys cần thiết**: `CONTEXTUAL_API_KEY` (từ app.contextual.ai)

**Chạy:**
```bash
cd rag_tutorials/contextualai_rag_agent
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
streamlit run contextualai_rag_agent.py
```

**Cách dùng**: Paste API key vào sidebar → tạo datastore → upload document → tạo agent → chat.

---

## 8. Corrective RAG (CRAG)

```
PDF Upload ──► OpenAI Embeddings ──► Qdrant Cloud
                                          │
User Question ──► Retrieve Docs ──► Grade Relevance (Claude 4.5)?
                                          │
                     ┌────────── Yes ─────┴─── No ──────────────┐
                     ▼                                           ▼
              Generate Answer                         Rewrite Query ──► Tavily Web Search
              (Claude 4.5 Sonnet)                                              │
                     ▲                                                         ▼
                     └──────────────────────────────── Generate Answer (Claude 4.5 Sonnet)
```

**API Keys cần thiết**: `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `TAVILY_API_KEY`, `QDRANT_API_KEY`, `QDRANT_URL`

**Chạy:**
```bash
cd rag_tutorials/corrective_rag
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
# Nhập keys trong sidebar Streamlit
streamlit run corrective_rag.py
```

**Cách dùng**: Upload PDF → đặt câu hỏi → hệ thống tự sửa lỗi retrieval nếu kết quả không liên quan.

---

## 9. DeepSeek Local RAG

```
[Chế độ Local Chat]
User ──► DeepSeek R1 (Ollama) ──► Answer

[Chế độ RAG]
PDF/URL ──► Snowflake Embeddings ──► Qdrant Cloud
                                          │
User Question ──► Similarity Search ──► DeepSeek R1 / Llama3.2
                        │
                        └──► Exa Web Search (fallback)
                                    │
                              Answer + Sources + Thinking
```

**API Keys cần thiết**: `QDRANT_API_KEY`, `QDRANT_URL`, `EXA_API_KEY`

**Cài Ollama models:**
```bash
ollama pull deepseek-r1:1.5b   # hoặc 7b nếu máy mạnh
ollama pull llama3.2
```

**Chạy:**
```bash
cd rag_tutorials/deepseek_local_rag_agent
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
streamlit run deepseek_rag_agent.py
```

**Cách dùng**: Chọn chế độ Local Chat hoặc RAG → upload PDF/nhập URL → đặt câu hỏi.

---

## 10. Gemini Agentic RAG

```
PDF/URL ──► Gemini Embeddings ──► Qdrant Cloud
                                       │
User Question ──► Query Rewriter ──► Retriever ──► Gemini 2.0 Flash Thinking
                                       │
                                       └──► Exa Web Search (fallback)
                                                    │
                                              Answer + Sources
```

**API Keys cần thiết**: `GOOGLE_API_KEY`, `QDRANT_API_KEY`, `QDRANT_URL`, `EXA_API_KEY`

**Chạy:**
```bash
cd rag_tutorials/gemini_agentic_rag
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
streamlit run agentic_rag_gemini.py
```

**Cách dùng**: Nhập API keys vào sidebar → upload PDF hoặc nhập URL → đặt câu hỏi.

---

## 11. Hybrid Search RAG

```
PDF Upload ──► OpenAI Embeddings + BM25 ──► PostgreSQL (Neon Cloud)
                                                      │
User Question ──► Hybrid Search (Dense + Sparse) ──► Cohere Reranker
                                                      │
                                                 Top Context ──► Claude 3 Opus
                                                                      │
                                                               Final Answer
```

**API Keys cần thiết**: `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `COHERE_API_KEY`

**Yêu cầu thêm**: Database URL từ [Neon](https://neon.tech) (free tier)

**Chạy:**
```bash
cd rag_tutorials/hybrid_search_rag
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
# Nhập tất cả keys + DB URL trong sidebar Streamlit
streamlit run main.py
```

**Cách dùng**: Paste Neon DB URL + các API key → upload PDF → đặt câu hỏi.

---

## 12. Knowledge Graph RAG

```
Documents ──► Llama 3.2 (Ollama) ──► Extract Entities & Relations
                                              │
                                         Neo4j Graph DB (Docker)
                                              │
User Question ──► Entity Extraction ──► Graph Traversal (Multi-hop)
                                              │
                                    Answer + Reasoning Trace + Citations
```

**API Keys cần thiết**: Không (100% local)

**Yêu cầu thêm**: Docker

```bash
# Khởi động Neo4j
docker run -d \
  --name neo4j \
  -p 7474:7474 -p 7687:7687 \
  -e NEO4J_AUTH=neo4j/password \
  neo4j:latest

# Pull Ollama model
ollama pull llama3.2
```

**Chạy:**
```bash
cd rag_tutorials/knowledge_graph_rag_citations
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
streamlit run knowledge_graph_rag.py
```

**Cách dùng**: Upload tài liệu → app xây đồ thị tri thức → đặt câu hỏi phức tạp cần multi-hop.

---

## 13. Llama 3.1 Local RAG

```
Webpage URL ──► WebBaseLoader ──► Text Splitter
                                       │
                               Ollama Embeddings ──► ChromaDB (local)
                                                          │
User Question ──────────────────────────────────► RAG Chain ──► Llama 3.1 ──► Answer
```

**API Keys cần thiết**: Không (100% local, không cần internet)

**Cài Ollama models:**
```bash
ollama pull llama3.1
```

**Chạy:**
```bash
cd rag_tutorials/llama3.1_local_rag
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
streamlit run llama3.1_local_rag.py
```

**Cách dùng**: Nhập URL trang web → nhấn "Load" → đặt câu hỏi về nội dung trang đó.

---

## 14. Local Hybrid Search RAG

```
PDF Upload ──► BGE-M3 Embeddings (local GGUF) ──► SQLite + FTS5
                │                                       │
                └──► BM25 Sparse Index ─────────────────┤
                                                         │
User Question ──► Hybrid Search ──► FlashRank Reranker ──► Llama 3.2 GGUF ──► Answer
```

**API Keys cần thiết**: Không (100% local)

> **Lưu ý**: App tự tải model GGUF từ HuggingFace khi chạy lần đầu (~2-4GB).

**Chạy:**
```bash
cd rag_tutorials/local_hybrid_search_rag
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
streamlit run local_main.py
```

**Cách dùng**: Nhập model strings vào sidebar (dùng giá trị mặc định từ README):
- LLM: `bartowski/Llama-3.2-3B-Instruct-GGUF/Llama-3.2-3B-Instruct-Q4_K_M.gguf@4096`
- Embedder: `lm-kit/bge-m3-gguf/bge-m3-Q4_K_M.gguf@1024`

Upload PDF → đặt câu hỏi.

---

## 15. Local RAG Agent

```
PDF/URL ──► Ollama Embeddings ──► Qdrant (Docker local)
                                        │
User Question ──► Agno Agent ──► Similarity Search ──► Llama 3.2 ──► Answer
```

**API Keys cần thiết**: Không (100% local)

**Yêu cầu thêm**: Docker + Ollama

```bash
# Khởi động Qdrant local
docker pull qdrant/qdrant
docker run -p 6333:6333 qdrant/qdrant

# Pull models
ollama pull llama3.2
ollama pull openhermes   # dùng cho embeddings
```

**Chạy:**
```bash
cd rag_tutorials/local_rag_agent
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
streamlit run local_rag_agent.py
```

**Cách dùng**: Upload PDF hoặc nhập URL → agent tự index → đặt câu hỏi.

---

## 16. Qwen Local RAG

```
PDF/URL ──► Qdrant Embeddings ──► Qdrant Cloud
                                       │
User Question ──► Agno Agent ──► Similarity Search ──► Qwen3 / Gemma3 (Ollama)
                    │                                         │
                    └──► Exa Web Search (fallback) ──────────┤
                                                        Answer + Sources
```

**API Keys cần thiết**: `QDRANT_API_KEY`, `QDRANT_URL`, `EXA_API_KEY`

**Cài Ollama models:**
```bash
ollama pull qwen3:1.7b   # hoặc 8b
ollama pull gemma3:1b
```

**Chạy:**
```bash
cd rag_tutorials/qwen_local_rag
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
streamlit run qwen_local_rag_agent.py
```

**Cách dùng**: Chọn model → nhập API keys → upload PDF/nhập URL → đặt câu hỏi.

---

## 17. RAG-as-a-Service

```
Document URL ──► Ragie.ai (Cloud Processing + Storage)
                          │
User Query ──► Ragie.ai Retrieval ──► Claude 3.5 Sonnet ──► Answer
```

**API Keys cần thiết**: `ANTHROPIC_API_KEY`, `RAGIE_API_KEY`

> Đăng ký Ragie: https://www.ragie.ai

**Chạy:**
```bash
cd rag_tutorials/rag-as-a-service
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
streamlit run rag_app.py
```

**Cách dùng**: Nhập API keys → paste URL tài liệu → chờ ingest → đặt câu hỏi.

---

## 18. RAG Agent + Cohere

```
PDF Upload ──► Cohere Embeddings (embed-english-v3.0) ──► Qdrant Cloud
                                                                │
User Question ──► Similarity Search ──► Relevant? ──Yes──► Command-R7B ──► Answer
                                              │No
                                              ▼
                                   LangGraph Agent ──► DuckDuckGo Search ──► Answer
```

**API Keys cần thiết**: `COHERE_API_KEY`, `QDRANT_API_KEY`, `QDRANT_URL`

**Chạy:**
```bash
cd rag_tutorials/rag_agent_cohere
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
# Nhập keys trong sidebar
streamlit run rag_agent_cohere.py
```

**Cách dùng**: Upload PDF → đặt câu hỏi → nếu không tìm thấy trong tài liệu sẽ tự tìm web.

---

## 19. RAG Chain (PharmaQuery)

```
Research Papers (PDF) ──► Sentence Transformers ──► ChromaDB (local)
                                                         │
User Pharma Question ──────────────────────────► RAG Chain ──► Gemini 1.5 Pro ──► Answer
```

**API Keys cần thiết**: `GOOGLE_API_KEY`

**Chạy:**
```bash
cd rag_tutorials/rag_chain
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
streamlit run app.py
```

**Cách dùng**: Paste Google API key trong sidebar → upload PDF nghiên cứu dược → đặt câu hỏi chuyên ngành.

---

## 20. RAG Database Routing

```
PDF Upload ──► OpenAI Embeddings ──► Qdrant Cloud (3 collection riêng biệt)
                                      ├── Product Info DB
                                      ├── Customer Support DB
                                      └── Financial Info DB
                                              │
User Question ──► Agno Router Agent ──► Chọn DB phù hợp ──► LangChain RAG ──► GPT-4o
                                              │
                                              └──► (fallback) LangGraph + DuckDuckGo
```

**API Keys cần thiết**: `OPENAI_API_KEY`, `QDRANT_API_KEY`, `QDRANT_URL`

**Chạy:**
```bash
cd rag_tutorials/rag_database_routing
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
# Nhập keys trong sidebar
streamlit run rag_database_routing.py
```

**Cách dùng**: Upload PDF vào đúng loại DB → đặt câu hỏi → agent tự route đến đúng database.

---

## 21. RAG Failure Diagnostics Clinic

```
Mô tả bug RAG (plain text) ──► Phân loại vào pattern ──► OpenAI LLM
                                                                │
                                                    Đề xuất minimal structural fix
                                                                │
                                                      Lưu JSON report
```

**API Keys cần thiết**: `OPENAI_API_KEY`

> Đây là CLI app, **không có giao diện Streamlit**.

**Chạy:**
```bash
cd rag_tutorials/rag_failure_diagnostics_clinic
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
export OPENAI_API_KEY="sk-..."
python rag_failure_diagnostics_clinic.py
```

**Cách dùng**: Chạy script → paste mô tả lỗi RAG của bạn → nhận phân tích pattern + giải pháp → lưu JSON.

---

## 22. Vision RAG

```
Images / PDF pages ──► Cohere Embed-4 (multimodal) ──► In-memory index
                                                               │
Text Question ──────────────────────────────────────► Semantic Search
                                                               │
                                                    Top Image/Page ──► Gemini 2.5 Flash ──► Answer
```

**API Keys cần thiết**: `COHERE_API_KEY`, `GOOGLE_API_KEY`

**Chạy:**
```bash
cd rag_tutorials/vision_rag
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
streamlit run vision_rag.py
```

**Cách dùng**: Upload ảnh (PNG/JPG) hoặc PDF → đặt câu hỏi về nội dung hình ảnh, biểu đồ → Gemini trả lời dựa trên ảnh liên quan nhất.

---

## 🗂️ Tổng hợp API Keys cần thiết

| API Key | Dùng ở App # | Đăng ký miễn phí tại |
|---------|-------------|----------------------|
| `OPENAI_API_KEY` | 2, 3, 4, 6, 8, 11, 20, 21 | https://platform.openai.com |
| `GOOGLE_API_KEY` | 4, 5, 10, 19, 22 | https://aistudio.google.com |
| `ANTHROPIC_API_KEY` | 8, 11, 17 | https://console.anthropic.com |
| `COHERE_API_KEY` | 11, 18, 22 | https://dashboard.cohere.com |
| `QDRANT_API_KEY` + `QDRANT_URL` | 3, 5, 8, 9, 10, 15, 16, 18, 20 | https://cloud.qdrant.io |
| `EXA_API_KEY` | 9, 10, 16 | https://exa.ai |
| `TAVILY_API_KEY` | 3, 8 | https://app.tavily.com |
| `RAGIE_API_KEY` | 17 | https://www.ragie.ai |
| `CONTEXTUAL_API_KEY` | 7 | https://app.contextual.ai |
| Neon DB URL | 11 | https://neon.tech |

---

## 🐳 Docker Services cần thiết

```bash
# PgVector (App #6 - Autonomous RAG)
docker run -d \
  -e POSTGRES_DB=ai -e POSTGRES_USER=ai -e POSTGRES_PASSWORD=ai \
  -p 5532:5432 -v pgvolume:/var/lib/postgresql/data \
  agnohq/pgvector:16

# Qdrant local (App #15 - Local RAG Agent)
docker run -d -p 6333:6333 -p 6334:6334 qdrant/qdrant

# Neo4j (App #12 - Knowledge Graph RAG)
docker run -d --name neo4j \
  -p 7474:7474 -p 7687:7687 \
  -e NEO4J_AUTH=neo4j/password \
  neo4j:latest
```

---

## 🤖 Ollama Models cần pull

```bash
# App 1 - EmbeddingGemma
ollama pull embeddinggemma:latest
ollama pull llama3.2:latest

# App 12 - Knowledge Graph RAG
ollama pull llama3.2

# App 13 - Llama 3.1 Local RAG
ollama pull llama3.1

# App 15 - Local RAG Agent
ollama pull llama3.2
ollama pull openhermes

# App 9 - DeepSeek Local RAG
ollama pull deepseek-r1:1.5b
ollama pull llama3.2

# App 16 - Qwen Local RAG
ollama pull qwen3:1.7b
```

---

## ✅ 5 App chạy được ngay (không cần API key)

| # | App | Lệnh nhanh |
|---|-----|-----------|
| 1 | EmbeddingGemma RAG | `ollama pull embeddinggemma llama3.2 && streamlit run agentic_rag_embeddinggemma.py` |
| 12 | Knowledge Graph RAG | Docker Neo4j + `ollama pull llama3.2` + `streamlit run knowledge_graph_rag.py` |
| 13 | **Llama 3.1 Local RAG** ⭐ | `ollama pull llama3.1 && streamlit run llama3.1_local_rag.py` |
| 14 | Local Hybrid Search RAG | `streamlit run local_main.py` (tự tải GGUF) |
| 15 | Local RAG Agent | Docker Qdrant + `ollama pull llama3.2` + `streamlit run local_rag_agent.py` |

> ⭐ **Bắt đầu với App #13** nếu bạn muốn chạy thử ngay mà không cần bất kỳ API key nào.
