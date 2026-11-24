FROM python:3.12-slim
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
ENV PYTHONUNBUFFERED=1
ENV WATCH_SECONDS=0
EXPOSE 8080
CMD ["sh","-c","python - <<'PY' &\nfrom http.server import BaseHTTPRequestHandler, HTTPServer\nclass H(BaseHTTPRequestHandler):\n    def do_GET(self):\n        self.send_response(200); self.end_headers(); self.wfile.write(b'ok')\n    def log_message(self,*a): pass\nHTTPServer(('0.0.0.0',8080), H).serve_forever()\nPY\nexec python bot.py --watch"]
