from flask import Blueprint, request, jsonify
from config import get_db
import psycopg2
import logging


logger = logging.getLogger(__name__)
bookings_bp = Blueprint('bookings', __name__)


@bookings_bp.route('/bookings', methods=['GET'])
def get_bookings():
    conn = get_db()
    cur = conn.cursor()
    cur.execute("SELECT id, name, barber, date::text, time FROM bookings ORDER BY date, time")
    rows = cur.fetchall()
    logger.info(f"Fetched {len(rows)} bookings")
    return jsonify([
        {'id': str(r[0]), 'name': r[1], 'barber': r[2], 'date': r[3], 'time': r[4]}
        for r in rows
    ])


@bookings_bp.route('/bookings', methods=['POST'])
def create_bookings():
    data = request.json
    if not all(k in data for k in ['name', 'barber', 'date', 'time']):
        return jsonify({'error': 'Missing required fields'}), 400
    try:
        conn = get_db()
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO bookings (name, barber, date, time) VALUES (%s,%s,%s,%s) RETURNING id",
            (data['name'], data['barber'], data['date'], data['time'])
        )
        booking_id = cur.fetchone()[0]
        conn.commit()
        cur.close()
        conn.close()
        logger.info(f"Booking created: {booking_id}")
        return jsonify({'id': str(booking_id)}), 201
    except psycopg2.errors.UniqueViolation:
        return jsonify({'error': 'Slot already booked'}), 409


@bookings_bp.route('/bookings/<booking_id>', methods=['DELETE'])
def cancel_booking(booking_id):
    conn = get_db()
    cur = conn.cursor()
    cur.execute("DELETE FROM bookings WHERE id=%s", (booking_id,))
    conn.commit()
    cur.close()
    conn.close()
    logger.info(f"Booking cancelled: {booking_id}")
    return jsonify({'cancelled': booking_id})
