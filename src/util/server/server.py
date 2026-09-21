import http.server
import socketserver

PORT = 8000
Handler = http.server.SimpleHTTPRequestHandler

'''
The eventual plan with this is to make it such that someone
could spin up a server that hosts their DB on a home server
and connect to it rather than have it hosted locally
'''

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Book Depot open at port {PORT}")
    httpd.serve_forever()