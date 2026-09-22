import { useEffect, useState } from 'react';
import { api } from '../api';
import AdminBar from '../components/AdminBar';
import { EmptyState, LoadingState, PageHeader } from '../components/Ui';

interface Entry {
  id: string;
  action: string;
  entity_type: string;
  entity_id: string | null;
  created_at: string;
}

export default function AuditLogs() {
  const [rows, setRows] = useState<Entry[]>([]);
  const [error, setError] = useState('');

  useEffect(() => {
    api<{ logs: Entry[] }>('/api/v1/admin/audit-logs?limit=100')
      .then((d) => setRows(d.logs))
      .catch((e: unknown) => setError(e instanceof Error ? e.message : 'Load failed'));
  }, []);

  return (
    <div className="admin-shell">
      <AdminBar />
      <main id="main-content" className="admin-main">
      <PageHeader eyebrow="Accountability" title="Audit log" intro="A chronological record of administrative and moderation actions." />
      {error && <p className="alert error" role="alert">{error}</p>}
      {rows.length ? <div className="table-wrap"><table>
        <thead><tr><th>When</th><th>Action</th><th>Entity</th></tr></thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.id}>
              <td>{String(r.created_at).slice(0, 19).replace('T', ' ')}</td>
              <td>{r.action}</td>
              <td>{r.entity_type}{r.entity_id ? ` ${r.entity_id.slice(0, 8)}…` : ''}</td>
            </tr>
          ))}
        </tbody>
      </table></div> : !error ? <LoadingState label="Loading audit activity…" /> : <EmptyState symbol="◎" title="Audit activity unavailable" description="The audit trail could not be loaded." />}
      </main>
    </div>
  );
}
