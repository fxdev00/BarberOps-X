from flask import Blueprint, jsonify
from config import get_db
import logging

logger = logging.getLogger(__name__)
health_bp = Blueprint('health', __name__)


@health_bp.route('/health')
def health():
    try:
        conn = get_db()
        conn.close()
        return jsonify({'status': 'ok', 'db': 'connected'})
    except Exception as e:
        logger.error(f"Health check failed: {e}")
        return jsonify({'status': 'error'}), 500