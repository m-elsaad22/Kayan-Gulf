'use client';

import { FormEvent, useEffect, useState } from 'react';
import { AdminShell } from '@/components/AdminShell';
import { AdminUser, adminApi, getRole } from '@/lib/api';
import { isPrivilegedAdmin } from '@/lib/roles';

export default function UsersPage() {
  const [items, setItems] = useState<AdminUser[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [q, setQ] = useState('');
  const [status, setStatus] = useState('');
  const privileged = isPrivilegedAdmin(getRole());

  async function load(params?: { q?: string; status?: string }) {
    setError(null);
    try {
      const r = await adminApi.users(params);
      setItems(r.items);
    } catch (e) {
      setError(e instanceof Error ? e.message : 'load_failed');
    }
  }

  useEffect(() => {
    void load();
  }, []);

  async function onSearch(e: FormEvent) {
    e.preventDefault();
    await load({ q: q.trim() || undefined, status: status || undefined });
  }

  async function setUserStatus(id: string, next: string) {
    try {
      await adminApi.updateUser(id, { status: next });
      await load({ q: q.trim() || undefined, status: status || undefined });
    } catch (e) {
      setError(e instanceof Error ? e.message : 'update_failed');
    }
  }

  async function setUserRole(id: string, role: string) {
    try {
      await adminApi.updateUser(id, { role });
      await load({ q: q.trim() || undefined, status: status || undefined });
    } catch (e) {
      setError(e instanceof Error ? e.message : 'update_failed');
    }
  }

  return (
    <AdminShell title="المستخدمون">
      {error && <p className="error">{error}</p>}
      <form className="panel" onSubmit={onSearch} style={{ marginBottom: 16, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <input
          placeholder="بحث بالبريد / الجوال / الاسم"
          value={q}
          onChange={(e) => setQ(e.target.value)}
          style={{ minWidth: 220 }}
        />
        <select value={status} onChange={(e) => setStatus(e.target.value)}>
          <option value="">كل الحالات</option>
          <option value="active">active</option>
          <option value="suspended">suspended</option>
          <option value="deleted">deleted</option>
        </select>
        <button className="btn" type="submit">
          بحث
        </button>
      </form>
      <div className="panel">
        <table>
          <thead>
            <tr>
              <th>الاسم</th>
              <th>البريد</th>
              <th>الجوال</th>
              <th>المزوّد</th>
              <th>الدور</th>
              <th>الحالة</th>
              <th>آخر دخول</th>
              <th>أجهزة</th>
              {privileged && <th>إجراءات</th>}
            </tr>
          </thead>
          <tbody>
            {items.map((u) => (
              <tr key={u.id}>
                <td>{u.name ?? '—'}</td>
                <td>{u.email ?? '—'}</td>
                <td>{u.phone ?? '—'}</td>
                <td>
                  <span className="badge">{u.authProvider}</span>
                  {u.hasGoogle ? ' · Google' : ''}
                </td>
                <td>
                  {privileged ? (
                    <select
                      value={u.role}
                      onChange={(e) => void setUserRole(u.id, e.target.value)}
                    >
                      {['user', 'support', 'moderator', 'admin', 'super_admin'].map((r) => (
                        <option key={r} value={r}>
                          {r}
                        </option>
                      ))}
                    </select>
                  ) : (
                    <span className="badge">{u.role}</span>
                  )}
                </td>
                <td>
                  <span className="badge">{u.status}</span>
                </td>
                <td>{u.lastLoginAt ? new Date(u.lastLoginAt).toLocaleString('ar-SA') : '—'}</td>
                <td>{u.counts.devices}</td>
                {privileged && (
                  <td style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
                    {u.status !== 'active' && (
                      <button className="btn" type="button" onClick={() => void setUserStatus(u.id, 'active')}>
                        تفعيل
                      </button>
                    )}
                    {u.status === 'active' && (
                      <button
                        className="btn secondary"
                        type="button"
                        onClick={() => void setUserStatus(u.id, 'suspended')}
                      >
                        إيقاف
                      </button>
                    )}
                    {u.status !== 'deleted' && (
                      <button
                        className="btn secondary"
                        type="button"
                        onClick={() => void setUserStatus(u.id, 'deleted')}
                      >
                        حذف ناعم
                      </button>
                    )}
                  </td>
                )}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </AdminShell>
  );
}
