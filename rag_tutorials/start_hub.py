#!/usr/bin/env python3
import http.server
import socketserver
import webbrowser
import os
import threading

PORT = 8000
DIRECTORY = os.path.join(os.path.dirname(os.path.abspath(__file__)), "rag_hub_ui")

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

def start_server():
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        print(f"RAG Copilot Hub is running at http://localhost:{PORT}")
        httpd.serve_forever()

if __name__ == "__main__":
    print("Starting RAG Hub UI...")
    # Start server in a separate thread
    server_thread = threading.Thread(target=start_server, daemon=True)
    server_thread.start()
    
    # Open browser automatically
    webbrowser.open(f"http://localhost:{PORT}")
    
    try:
        # Keep main thread alive
        server_thread.join()
    except KeyboardInterrupt:
        print("\nShutting down RAG Hub UI.")
