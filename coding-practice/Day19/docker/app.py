
cat > coding-practice/Day19/docker/app.py <<'EOF'
from flask import Flask
import logging
import os

app = Flask(__name__)

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s"
)

@app.route("/")
def home():
    app.logger.info("Homepage endpoint accessed")
    return "Hello PathNex! Flask application is running.", 200

@app.route("/health")
def health():
    return {"status": "healthy"}, 200

@app.route("/metrics-info")
def metrics_info():
    return {
        "application": "pathnex-web-app",
        "environment": os.getenv("APP_ENV", "dev")
    }, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF
