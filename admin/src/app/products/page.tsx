'use client';

import { useEffect, useState } from 'react';
import { AdminShell } from '@/components/AdminShell';
import { AdminProduct, adminApi } from '@/lib/api';

export default function ProductsPage() {
  const [items, setItems] = useState<AdminProduct[]>([]);
  const [error, setError] = useState<string | null>(null);

  async function load() {
    try {
      const res = await adminApi.products();
      setItems(res.items);
    } catch (e) {
      setError(e instanceof Error ? e.message : 'failed');
    }
  }

  useEffect(() => {
    void load();
  }, []);

  return (
    <AdminShell title="المنتجات">
      {error && <p className="error">{error}</p>}
      <div className="panel">
        <table>
          <thead>
            <tr>
              <th>الاسم</th>
              <th>السعر</th>
              <th>المخزون</th>
              <th>الحالة</th>
            </tr>
          </thead>
          <tbody>
            {items.map((p) => (
              <tr key={p.id}>
                <td>{p.nameAr}</td>
                <td>{p.price}</td>
                <td>{p.stock}</td>
                <td>
                  <select
                    className="status"
                    value={p.status}
                    onChange={async (e) => {
                      await adminApi.setProductStatus(p.id, e.target.value);
                      await load();
                    }}
                  >
                    <option value="ACTIVE">ACTIVE</option>
                    <option value="DRAFT">DRAFT</option>
                    <option value="ARCHIVED">ARCHIVED</option>
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
