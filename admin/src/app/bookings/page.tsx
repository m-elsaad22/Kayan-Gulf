'use client';

import { useEffect, useState } from 'react';
import { AdminShell } from '@/components/AdminShell';
import { AdminBooking, adminApi } from '@/lib/api';

export default function BookingsPage() {
  const [items, setItems] = useState<AdminBooking[]>([]);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    adminApi
      .bookings()
      .then((r) => setItems(r.items))
      .catch((e: Error) => setError(e.message));
  }, []);

  return (
    <AdminShell title="الحجوزات">
      {error && <p className="error">{error}</p>}
      <div className="panel">
        <table>
          <thead>
            <tr>
              <th>الرقم</th>
              <th>الخدمة</th>
              <th>العميل</th>
              <th>الموعد</th>
              <th>الحالة</th>
            </tr>
          </thead>
          <tbody>
            {items.map((b) => (
              <tr key={b.id}>
                <td>{b.bookingNumber}</td>
                <td>{b.serviceNameAr}</td>
                <td>{b.userEmail ?? '—'}</td>
                <td>{b.scheduledAt.slice(0, 16).replace('T', ' ')}</td>
                <td>
                  <span className="badge">{b.status}</span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </AdminShell>
  );
}
