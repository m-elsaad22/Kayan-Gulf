'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { getRole, getToken } from '@/lib/api';

export default function Home() {
  const router = useRouter();
  useEffect(() => {
    const token = getToken();
    const role = getRole();
    router.replace(token && role === 'admin' ? '/dashboard' : '/login');
  }, [router]);
  return (
    <div className="login-wrap">
      <p className="muted">جارٍ التوجيه…</p>
    </div>
  );
}
