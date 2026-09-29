from http.server import HTTPServer, BaseHTTPRequestHandler
import json

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        payload = {"status": "success", "message": "Hello from local API!"}
        self.wfile.write(json.dumps(payload).encode('utf-8'))

HTTPServer(('192.168.1.41', 8000), SimpleHandler).serve_forever()