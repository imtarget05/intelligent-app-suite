# Import necessary libraries
import os
import streamlit as st
from agno.agent import Agent
from agno.models.ollama import Ollama
from agno.knowledge.knowledge import Knowledge
from agno.vectordb.lancedb import LanceDb, SearchType
from agno.knowledge.embedder.ollama import OllamaEmbedder

st.set_page_config(page_title="Local RAG Agent", page_icon="🍜")
st.title("🍜 Local RAG Agent — Thai Recipes")
st.caption("Powered by llama3.2 + OllamaEmbedder + LanceDB (100% local, no API key)")

@st.cache_resource(show_spinner="Loading knowledge base...")
def build_agent():
    vector_db = LanceDb(
        table_name="thai-recipe-index",
        uri=os.path.expanduser("~/.cache/rag_tutorials/lancedb/local_rag"),
        search_type=SearchType.vector,
        embedder=OllamaEmbedder(id="llama3.2", dimensions=3072),
    )
    knowledge_base = Knowledge(vector_db=vector_db)
    knowledge_base.add_content(
        url="https://phi-public.s3.amazonaws.com/recipes/ThaiRecipes.pdf"
    )
    return Agent(
        name="Local RAG Agent",
        model=Ollama(id="llama3.2"),
        knowledge=knowledge_base,
        search_knowledge=True,
        markdown=True,
        instructions=[
            "Search the knowledge base for relevant Thai recipe information.",
            "Answer clearly and in detail. Use bullet points where helpful.",
        ],
    )

agent = build_agent()

if "messages" not in st.session_state:
    st.session_state.messages = []

for msg in st.session_state.messages:
    with st.chat_message(msg["role"]):
        st.markdown(msg["content"])

if prompt := st.chat_input("Ask about Thai recipes..."):
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)

    with st.chat_message("assistant"):
        with st.spinner("Thinking..."):
            response = agent.run(prompt)
            answer = response.content if hasattr(response, "content") else str(response)
            st.markdown(answer)
    st.session_state.messages.append({"role": "assistant", "content": answer})
