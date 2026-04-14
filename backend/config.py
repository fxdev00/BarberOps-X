import os
import psycopg2
import logging

logger = logging.getLogger(__name__)

def get_db():
    return psycopg2.connect(
        host=os.environ['DB_HOST'],         # ← comes from ConfigMap
        database=os.environ['DB_NAME'],     # ← comes from Secret
        user=os.environ['DB_USER'],         # ← comes from Secret
        password=os.environ['DB_PASSWORD']  # ← comes from Secret
    )

def init_db():
    conn = get_db()
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS bookings (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            name VARCHAR(100) NOT NULL,
            barber VARCHAR(100) NOT NULL,
            date DATE NOT NULL,
            time VARCHAR(10) NOT NULL,
            created_at TIMESTAMP DEFAULT NOW(),
            UNIQUE(barber, date, time)
        )
    """)
    conn.commit()
    cur.close()
    conn.close()
    logger.info("Database Initialised")