# 🚀 Bắt đầu nhanh với RAG Tutorials

Tài liệu này cung cấp hướng dẫn nhanh cách chạy và triển khai 22 ứng dụng trong thư mục `rag_tutorials`.

## 📦 Yêu cầu chung
- Python 3.10+
- Khuyến nghị sử dụng môi trường ảo (`venv` hoặc `conda`) cho từng ứng dụng để tránh xung đột thư viện.
- Cài đặt Ollama (nếu dùng các app Local RAG): https://ollama.com

---

## 🛠️ Hướng dẫn Workflow & Chạy 22 ứng dụng RAG

Dưới đây là danh sách 22 ứng dụng RAG, mô tả workflow cơ bản và cách chạy:

### 1. Agentic RAG Embedding Gemma (`agentic_rag_embedding_gemma`)
- **Workflow**: RAG dùng mô hình nhúng (embedding) Gemma.
- **Chạy**:
  ```bash
  cd rag_tutorials/agentic_rag_embedding_gemma
  pip install -r requirements.txt
  streamlit run app.py # Thay bằng tên file thực tế nếu khác
  ```

### 2. Agentic RAG GPT-5 (`agentic_rag_gpt5`)
- **Workflow**: (Dự kiến) Agentic RAG với mô hình GPT.
- **Chạy**: (Tương tự, tìm file `.py` chính và chạy bằng Streamlit)

### 3. Agentic RAG Math Agent (`agentic_rag_math_agent`)
- **Workflow**: RAG kết hợp với khả năng giải toán của Agent.
- **Chạy**: (Tương tự)

### 4. Agentic RAG with Reasoning (`agentic_rag_with_reasoning`)
- **Workflow**: RAG được tăng cường khả năng lập luận.
- **Chạy**: (Tương tự)

### 5. AI Blog Search (`ai_blog_search`)
- **Workflow**: Tìm kiếm và hỏi đáp trên các bài blog.
- **Chạy**: (Tương tự)

### 6. Autonomous RAG (`autonomous_rag`)
- **Workflow**: Hệ thống RAG tự động xử lý tài liệu.
- **Chạy**:
  ```bash
  cd rag_tutorials/autonomous_rag
  pip install -r requirements.txt
  streamlit run autonomous_rag.py
  ```

### 7. Contextual AI RAG Agent (`contextualai_rag_agent`)
- **Workflow**: RAG hiểu ngữ cảnh (Contextual AI).
- **Chạy**: (Tương tự)

### 8. Corrective RAG (`corrective_rag`)
- **Workflow**: (CRAG) Tự động đánh giá và sửa lỗi kết quả truy xuất trước khi tạo câu trả lời.
- **Chạy**: (Tương tự)

### 9. DeepSeek Local RAG Agent (`deepseek_local_rag_agent`)
- **Workflow**: RAG chạy cục bộ (local) với mô hình DeepSeek qua Ollama.
- **Chạy**:
  ```bash
  ollama pull deepseek-coder # Hoặc model deepseek tương ứng
  cd rag_tutorials/deepseek_local_rag_agent
  pip install -r requirements.txt
  streamlit run app.py
  ```

### 10. Gemini Agentic RAG (`gemini_agentic_rag`)
- **Workflow**: RAG kết hợp tác vụ Agent sử dụng Google Gemini.
- **Chạy**: Cần cung cấp `GOOGLE_API_KEY`. (Tương tự)

### 11. Hybrid Search RAG (`hybrid_search_rag`)
- **Workflow**: Kết hợp tìm kiếm từ khóa (BM25) và tìm kiếm vector (Dense retrieval) để cải thiện độ chính xác.
- **Chạy**: (Tương tự)

### 12. Knowledge Graph RAG Citations (`knowledge_graph_rag_citations`)
- **Workflow**: GraphRAG - dùng đồ thị tri thức để truy xuất và có trích dẫn nguồn.
- **Chạy**: (Tương tự)

### 13. LLaMA 3.1 Local RAG (`llama3.1_local_rag`)
- **Workflow**: RAG chạy 100% cục bộ với Llama 3.1 và Nomic embeddings qua Ollama. An toàn cho dữ liệu riêng tư.
- **Chạy**:
  ```bash
  ollama pull llama3.1
  ollama pull nomic-embed-text
  cd rag_tutorials/llama3.1_local_rag
  pip install -r requirements.txt
  streamlit run llama3.1_local_rag.py
  ```

### 14. Local Hybrid Search RAG (`local_hybrid_search_rag`)
- **Workflow**: Hybrid search chạy hoàn toàn cục bộ (local).
- **Chạy**: (Tương tự mục 13, cần pull model phù hợp)

### 15. Local RAG Agent (`local_rag_agent`)
- **Workflow**: Agent hỏi đáp tài liệu chạy trên máy cá nhân.
- **Chạy**: Cần cài Ollama. (Tương tự)

### 16. Qwen Local RAG (`qwen_local_rag`)
- **Workflow**: Local RAG sử dụng mô hình Qwen của Alibaba.
- **Chạy**:
  ```bash
  ollama pull qwen
  cd rag_tutorials/qwen_local_rag
  # ...
  ```

### 17. RAG as a Service (`rag-as-a-service`)
- **Workflow**: Khung triển khai RAG như một API Service (có thể dùng FastAPI).
- **Chạy**: Kiểm tra README trong thư mục để xem chạy bằng `uvicorn` hay `streamlit`.

### 18. RAG Agent Cohere (`rag_agent_cohere`)
- **Workflow**: RAG Agent dùng LLM và Embeddings của Cohere.
- **Chạy**: Cần `COHERE_API_KEY`. (Tương tự)

### 19. RAG Chain (`rag_chain`)
- **Workflow**: Chuỗi xử lý RAG cơ bản (Retriever -> Prompt -> LLM).
- **Chạy**: (Tương tự)

### 20. RAG Database Routing (`rag_database_routing`)
- **Workflow**: Agent có khả năng quyết định truy xuất từ cơ sở dữ liệu nào dựa trên câu hỏi.
- **Chạy**: (Tương tự)

### 21. RAG Failure Diagnostics Clinic (`rag_failure_diagnostics_clinic`)
- **Workflow**: Ứng dụng chẩn đoán và khắc phục lỗi trong pipeline RAG (đánh giá retrieval, hallucination...).
- **Chạy**: (Tương tự)

### 22. Vision RAG (`vision_rag`)
- **Workflow**: RAG đa phương thức, có thể xử lý hình ảnh trong tài liệu (PDF chứa biểu đồ, ảnh).
- **Chạy**: Thường cần mô hình hỗ trợ Vision (ví dụ: gpt-4o, claude-3.5-sonnet). (Tương tự)

---

## 🚀 Cách triển khai nhanh (Deploy)

Hầu hết các ứng dụng này được xây dựng bằng **Streamlit**, giúp việc triển khai rất dễ dàng:

### 1. Triển khai lên Streamlit Community Cloud (Miễn phí)
1. Đẩy mã nguồn lên GitHub của bạn.
2. Đăng nhập https://share.streamlit.io/.
3. Chọn "New app", trỏ đến repository của bạn, chọn thư mục và file `.py` của app bạn muốn chạy.
4. Cấu hình các biến môi trường (Secrets) như `OPENAI_API_KEY` trong phần cài đặt của app.

### 2. Triển khai bằng Docker
Tạo file `Dockerfile` trong thư mục của ứng dụng bạn muốn chạy:

```dockerfile
FROM python:3.10-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8501
CMD ["streamlit", "run", "tên_file_app.py", "--server.address=0.0.0.0"]
```

Build và chạy:
```bash
docker build -t my-rag-app .
docker run -p 8501:8501 -e OPENAI_API_KEY="sk-..." my-rag-app
```

*(Lưu ý: Các ứng dụng Local RAG dùng Ollama cần thiết lập Docker phức tạp hơn để liên kết với Ollama container, khuyến nghị chạy trực tiếp trên máy hoặc host có GPU)*
