import { useState, useEffect } from 'react';
import './App.css';

const API = process.env.REACT_APP_API_URL || 'http://localhost:5001';

const BARBERS = ['Marcus', 'Jordan', 'Leo'];
const TIMES = ['09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00'];

function App() {
  const [bookings, setBookings] = useState([]);
  const [form, setForm] = useState({ name: '', barber: '', date: '', time: '' });
  const [status, setStatus] = useState(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetchBookings();
  }, []);

  const fetchBookings = async () => {
    try {
      const res = await fetch(`${API}/bookings`);
      const data = await res.json();
      setBookings(data);
    } catch (err) {
      console.error('Failed to fetch bookings', err);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setStatus(null);
    try {
      const res = await fetch(`${API}/bookings`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(form),
      });
      const data = await res.json();
      if (res.ok) {
        setStatus({ type: 'success', msg: `Booking confirmed — ID: ${data.id}` });
        setForm({ name: '', barber: '', date: '', time: '' });
        fetchBookings();
      } else {
        setStatus({ type: 'error', msg: data.error });
      }
    } catch (err) {
      setStatus({ type: 'error', msg: 'Something went wrong' });
    }
    setLoading(false);
  };

  const handleCancel = async (id) => {
    try {
      await fetch(`${API}/bookings/${id}`, { method: 'DELETE' });
      fetchBookings();
    } catch (err) {
      console.error('Failed to cancel booking', err);
    }
  };

  return (
    <div className="app">
      <header className="header">
        <div className="header-inner">
          <div className="logo">✂ BarberOps<span>-X</span></div>
          <div className="tagline">// book your cut</div>
        </div>
      </header>

      <main className="main">
        <section className="form-section">
          <div className="section-label">// new booking</div>
          <form onSubmit={handleSubmit} className="form">
            <div className="form-row">
              <div className="field">
                <label>Name</label>
                <input
                  type="text"
                  placeholder="Your name"
                  value={form.name}
                  onChange={e => setForm({ ...form, name: e.target.value })}
                  required
                />
              </div>
              <div className="field">
                <label>Barber</label>
                <select
                  value={form.barber}
                  onChange={e => setForm({ ...form, barber: e.target.value })}
                  required
                >
                  <option value="">Select barber</option>
                  {BARBERS.map(b => <option key={b} value={b}>{b}</option>)}
                </select>
              </div>
            </div>
            <div className="form-row">
              <div className="field">
                <label>Date</label>
                <input
                  type="date"
                  value={form.date}
                  onChange={e => setForm({ ...form, date: e.target.value })}
                  required
                />
              </div>
              <div className="field">
                <label>Time</label>
                <select
                  value={form.time}
                  onChange={e => setForm({ ...form, time: e.target.value })}
                  required
                >
                  <option value="">Select time</option>
                  {TIMES.map(t => <option key={t} value={t}>{t}</option>)}
                </select>
              </div>
            </div>
            {status && (
              <div className={`status ${status.type}`}>{status.msg}</div>
            )}
            <button type="submit" disabled={loading}>
              {loading ? 'Booking...' : 'Book Appointment'}
            </button>
          </form>
        </section>

        <section className="bookings-section">
          <div className="section-label">// upcoming bookings</div>
          {bookings.length === 0 ? (
            <div className="empty">No bookings yet</div>
          ) : (
            <div className="bookings-grid">
              {bookings.map(b => (
                <div key={b.id} className="booking-card">
                  <div className="booking-top">
                    <span className="booking-name">{b.name}</span>
                    <span className="booking-barber">{b.barber}</span>
                  </div>
                  <div className="booking-bottom">
                    <span className="booking-time">{b.date} @ {b.time}</span>
                    <button className="cancel-btn" onClick={() => handleCancel(b.id)}>
                      Cancel
                    </button>
                  </div>
                </div>
              ))}
            </div>
          )}
        </section>
      </main>
    </div>
  );
}

export default App;