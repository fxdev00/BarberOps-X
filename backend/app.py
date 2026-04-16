import logging
from flask import Flask
from flask_cors import CORS
from config import init_db
from routes import health_bp, bookings_bp

# Structured logging
logging.basicConfig(
    level=logging.INFO,
    format='{"time": "%(asctime)s", "level": "%(levelname)s", "msg": "%(message)s"}'
)

app = Flask(__name__)
CORS(app)

# Register Blueprint
app.register_blueprint(health_bp)
app.register_blueprint(bookings_bp)

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5001)
