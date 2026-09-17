import http.server
import socketserver

PORT = 8000
Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Book Depot open at port {PORT}")
    httpd.serve_forever()

    '''
    List of todos: 
    1. Add listeners for adding cases, shelves, books
    2. Add lookup for books
    3. Add sqlite backend
    4. Add startup command
    '''