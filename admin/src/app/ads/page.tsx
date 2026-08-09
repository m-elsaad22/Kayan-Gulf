'use client';

import { useEffect, useState } from 'react';
import { AdminShell } from '@/components/AdminShell';
import { AdminAd, adminApi } from '@/lib/api';

export default function AdsPage() {
  const [items, setItems] = useState<AdminAd[]>([]);
  const [error, setError] = useState<string | null>(null);

  async function load() {
    try {
      const res = await adminApi.ads();
      setItems(res.items);
    } catch (e) {
      setError(e instanceof Error ? e.message : 'failed');
    }
  }

  useEffect(() => {
    void load();
  }, []);

  return (
    <AdminShell title="الإعلانات">
      {error && <p className="error">{error}</p>}
      <div className="panel">
        <table>
          <thead>
            <tr>
              <th>العنوان</th>
              <th>المدينة</th>
              <th>السعر</th>
              <th>الحالة</th>
            </tr>
          </thead>
          <tbody>
            {items.map((row) => (
              <tr key={row.ad.id}>
                <td>{row.ad.title}</td>
                <td>{row.ad.city}</td>
                <td>{row.ad.price ?? 'مجاني'}</td>
                <td>
                  <select
                    className="status"
                    value={row.status}
                    onChange={async (e) => {
                      await adminApi.setAdStatus(row.ad.id, e.target.value);
                      await load();
                    }}
                  >
                    <option value="ACTIVE">ACTIVE</option>
                    <option value="PAUSED">PAUSED</option>
                    <option value="SOLD">SOLD</option>
                    <option value="EXPIRED">EXPIRED</option>
                  </select>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </AdminShell>
  );
}
