import { useEffect, useState } from 'react';
import { api } from '../api';
import AdminBar from '../components/AdminBar';
import { PageHeader, EmptyState, StatusBadge, Toolbar } from '../components/Ui';

interface UserRow {
  id: string;
  email: string;
  display_name: string;
  province: string | null;
  account_status: string;
  roles: string[];
  created_at: string;
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type Detail = { user: UserRow; contributions: Record<string, number>; moderationHistory: any[] } | null;

export default function Users() {
  const [q, setQ] = useState('');
  const [rows, setRows] = useState<UserRow[]>([]);
  const [detail, setDetail] = useState<Detail>(null);
  const [error, setError] = useState('');

  async function load() {
    try {
      const params = new URLSearchParams({ limit: '50' });
      if (q.trim()) params.set('search', q.trim());
      setRows((await api<{ users: UserRow[] }>(`/api/v1/admin/users?${params}`)).users);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Load failed');
    }
  }

  useEffect(() => {
    void load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  async function setStatus(id: string, status: string) {
    setError('');
    try {
      await api(`/api/v1/admin/users/${id}/status`, { method: 'PATCH', body: JSON.stringify({ status }) });
      await load();
      setDetail(await api<Detail>(`/api/v1/admin/users/${id}`));
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Action failed');
    }
  }

  async function toggleRole(id: string, role: 'moderator' | 'admin', has: boolean) {
    if (has) {
      await api(`/api/v1/admin/users/${id}/roles/${role}`, { method: 'DELETE' }).catch((e: unknown) => setError(e instanceof Error ? e.message : 'Failed'));
    } else {
      await api(`/api/v1/admin/users/${id}/roles`, { method: 'POST', body: JSON.stringify({ role }) }).catch((e: unknown) => setError(e instanceof Error ? e.message : 'Failed'));
    }
    await load();
    setDetail(await api<Detail>(`/api/v1/admin/users/${id}`));
  }

  return (
    <div className="admin-shell">
      <AdminBar />
      <main id="main-content" className="admin-main">
      <PageHeader eyebrow="Access control" title="Users" intro="Search accounts, review contributions, and manage roles and standing." />
      {error && <p className="alert error" role="alert">{error}</p>}
      <Toolbar>
        <label className="search-field"><span className="sr-only">Search users</span><input placeholder="Search email or name…" value={q} onChange={(e) => setQ(e.target.value)} onKeyDown={(e) => { if (e.key === 'Enter') void load(); }} /></label>
        <button onClick={load}>Search</button>
      </Toolbar>
      <div className="table-wrap"><table>
        <thead><tr><th>Name</th><th>Email</th><th>Roles</th><th>Status</th><th></th></tr></thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.id}>
              <td>{r.display_name}</td>
              <td>{r.email}</td>
              <td>{r.roles.join(', ')}</td>
              <td><StatusBadge value={r.account_status} /></td>
              <td><button onClick={() => api<Detail>(`/api/v1/admin/users/${r.id}`).then(setDetail).catch((e: unknown) => setError(e instanceof Error ? e.message : 'Failed'))}>View</button></td>
            </tr>
          ))}
        </tbody>
      </table></div>
      {!rows.length && !error && <EmptyState symbol="🌳" title="No accounts found" description="Try a different search term." />}
      {detail && (
        <aside className="detail-panel" aria-label="Selected user details">
          <h2>{detail.user.display_name} <small className="sci">{detail.user.email}</small></h2>
          <p>Province: {detail.user.province ?? '—'} · Joined: {detail.user.created_at.slice(0, 10)}</p>
          <p><b>Contributions:</b> {Object.entries(detail.contributions).map(([k, v]) => `${k}: ${v}`).join(' · ')}</p>
          <div className="actions">
            <button onClick={() => setStatus(detail.user.id, detail.user.account_status === 'active' ? 'suspended' : 'active')}>
              {detail.user.account_status === 'active' ? 'Suspend' : 'Reactivate'}
            </button>{' '}
            <button onClick={() => toggleRole(detail.user.id, 'moderator', detail.user.roles.includes('moderator'))}>
              {detail.user.roles.includes('moderator') ? 'Remove moderator' : 'Make moderator'}
            </button>{' '}
            <button onClick={() => toggleRole(detail.user.id, 'admin', detail.user.roles.includes('admin'))}>
              {detail.user.roles.includes('admin') ? 'Remove admin' : 'Make admin'}
            </button>
          </div>
          <h3>Moderation history ({detail.moderationHistory.length})</h3>
          <ul>{detail.moderationHistory.map((m, i) => <li key={i}>{m.action} on {m.entity_type} · {String(m.created_at).slice(0, 10)}</li>)}</ul>
        </aside>
      )}
      </main>
    </div>
  );
}
