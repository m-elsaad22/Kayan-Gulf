'use client';

import { useEffect, useState } from 'react';
import { AdminShell } from '@/components/AdminShell';
import { AdminService, adminApi } from '@/lib/api';

export default function ServicesPage() {
  const [items, setItems] = useState<AdminService[]>([]);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    adminApi
      .services()
      .then((r) => setItems(r.items))
      .catch((e: Error) => setError(e.message));
  }, []);

  return (
    <AdminShell title="الخدمات">
      {error && <p className="error">{error}</p>}
      <div className="panel">
        <table>
          <thead>
            <tr>
              <th>الخدمة</th>
              <th>السعر</th>
              <th>الحجوزات</th>
              <th>متاحة</th>
            </tr>
          </thead>
          <tbody>
            {items.map((s) => (
              <tr key={s.id}>
                <td>{s.nameAr}</td>
                <td>{s.basePrice}</td>
                <td>{s.totalBookings}</td>
                <td>{s.isAvailable ? 'نعم' : 'لا'}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </AdminShell>
  );
}
