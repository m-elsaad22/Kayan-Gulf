'use client';

import { useEffect, useState } from 'react';
import { AdminShell } from '@/components/AdminShell';
import { AuditLogItem, adminApi } from '@/lib/api';

export default function AuditPage() {
  const [items, setItems] = useState<AuditLogItem[]>([]);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    adminApi
      .auditLogs()
      .then((r) => setItems(r.items))
      .catch((e: Error) => setError(e.message));
  }, []);

  return (
    <AdminShell title="سجل التدقيق">
      {error && <p className="error">{error}</p>}
      <div className="panel">
        <table>
          <thead>
            <tr>
              <th>الوقت</th>
              <th>الإجراء</th>
              <th>المورد</th>
              <th>المنفّذ</th>
              <th>نجاح</th>
            </tr>
          </thead>
          <tbody>
            {items.map((r) => (
              <tr key={r.id}>
                <td>{new Date(r.createdAt).toLocaleString('ar-SA')}</td>
                <td>{r.action}</td>
                <td>
                  {r.resource}
                  {r.resourceId ? `:${r.resourceId}` : ''}
                </td>
                <td>{r.actorEmail ?? r.actorName ?? '—'}</td>
                <td>{r.success ? 'نعم' : 'لا'}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </AdminShell>
  );
}
