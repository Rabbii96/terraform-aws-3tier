#!/bin/bash
# Minimal demo app: answers /health so the ALB health check passes.
set -euo pipefail
dnf install -y python3
mkdir -p /opt/app && cd /opt/app
cat > app.py <<'PY'
from http.server import BaseHTTPRequestHandler, HTTPServer
class H(BaseHTTPRequestHandler):
    def do_GET(self):
        body = b'{"status":"ok"}' if self.path == "/health" else b"three-tier demo"
        self.send_response(200); self.end_headers(); self.wfile.write(body)
HTTPServer(("0.0.0.0", 8080), H).serve_forever()
PY
nohup python3 app.py >/var/log/app.log 2>&1 &
