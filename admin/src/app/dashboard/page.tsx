'use client';

import { useEffect, useState } from 'react';
import { AdminShell } from '@/components/AdminShell';
import { AdminStats, adminApi } from '@/lib/api';

export default function DashboardPage() {
  const [stats, setStats] = useState<AdminStats | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    adminApi
      .stats()
      .then(setStats)
      .catch((e: Error) => setError(e.message));
  }, []);

  const cards = stats
    ? [
        ['مستخدمون', stats.counts.users],
        ['منتجات', stats.counts.products],
        ['طلبات', stats.counts.orders],
        ['خدمات', stats.counts.services],
        ['حجوزات', stats.counts.bookings],
        ['إعلانات', stats.counts.ads],
        ['بنرات', stats.counts.banners],
      ]
    : [];

  return (
    <AdminShell title="لوحة التحكم">
      {error && <p className="error">{error}</p>}
      <div className="grid">
        {cards.map(([label, value]) => (
          <div className="card" key={String(label)}>
            <div className="label">{label}</div>
            <div className="value">{value}</div>
          </div>
        ))}
      </div>
      <div className="panel" style={{ marginTop: 20 }}>
        <table>
          <thead>
            <tr>
              <th>طلب</th>
              <th>الحالة</th>
              <th>المبلغ</th>
              <th>الدفع</th>
              <th>التاريخ</th>
            </tr>
          </thead>
          <tbody>
            {(stats?.recentOrders ?? []).map((o) => (
              <tr key={o.id}>
                <td>{o.id}</td>
                <td>
                  <span className="badge">{o.status}</span>
                </td>
                <td>
                  {o.total} {o.currency}
                </td>
                <td>{o.paymentMethod}</td>
                <td>{o.createdAt.slice(0, 10)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </AdminShell>
  );
}
