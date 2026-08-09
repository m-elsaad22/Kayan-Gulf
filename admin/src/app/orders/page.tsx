'use client';

import { useEffect, useState } from 'react';
import { AdminShell } from '@/components/AdminShell';
import { AdminOrder, adminApi } from '@/lib/api';

export default function OrdersPage() {
  const [items, setItems] = useState<AdminOrder[]>([]);
  const [error, setError] = useState<string | null>(null);

  async function load() {
    try {
      const res = await adminApi.orders();
      setItems(res.items);
    } catch (e) {
      setError(e instanceof Error ? e.message : 'failed');
    }
  }

  useEffect(() => {
    void load();
  }, []);

  return (
    <AdminShell title="الطلبات">
      {error && <p className="error">{error}</p>}
      <div className="panel">
        <table>
          <thead>
            <tr>
              <th>المعرّف</th>
              <th>العميل</th>
              <th>المبلغ</th>
              <th>الدفع</th>
              <th>الحالة</th>
            </tr>
          </thead>
          <tbody>
            {items.map((o) => (
              <tr key={o.id}>
                <td>{o.id}</td>
                <td>{o.userName ?? o.userEmail ?? '—'}</td>
                <td>
                  {o.total} {o.currency}
                </td>
                <td>{o.paymentMethod}</td>
                <td>
                  <select
                    className="status"
                    value={o.status}
                    onChange={async (e) => {
                      await adminApi.setOrderStatus(o.id, e.target.value);
                      await load();
                    }}
                  >
                    <option value="pending">pending</option>
                    <option value="paid">paid</option>
                    <option value="shipping">shipping</option>
                    <option value="delivered">delivered</option>
                    <option value="cancelled">cancelled</option>
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
