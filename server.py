import http.server
import socketserver

PORT = 8000
Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Book Depot open at port {PORT}")
    httpd.serve_forever()

    '''
    TODO 
    1. Add listeners for adding cases, shelves, books
        a. Needs to have data validation to check for duplicates
    2. Add lookup for books
    3. Add sqlite backend with persistence
    4. Add startup command
    5. Add support to run locally without remote server
    '''