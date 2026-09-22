import { useEffect, useState } from 'react';
import { api } from '../api';
import AdminBar from '../components/AdminBar';
import { PageHeader, EmptyState, StatusBadge, Toolbar } from '../components/Ui';

interface Report {
  id: string;
  entity_type: string;
  entity_id: string;
  reason: string;
  description: string | null;
  status: string;
  reporter_name: string;
  created_at: string;
}

export default function Reports() {
  const [rows, setRows] = useState<Report[]>([]);
  const [status, setStatus] = useState('open');
  const [resolution, setResolution] = useState('');
  const [error, setError] = useState('');

  async function load(s = status) {
    try {
      setRows((await api<{ reports: Report[] }>(`/api/v1/admin/reports?status=${s}&limit=50`)).reports);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Load failed');
    }
  }

  useEffect(() => {
    void load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  async function resolve(id: string, st: string) {
    try {
      await api(`/api/v1/admin/reports/${id}/resolve`, {
        method: 'POST',
        body: JSON.stringify({ status: st, resolution: resolution || undefined }),
      });
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed');
    }
  }

  return (
    <div className="admin-shell">
      <AdminBar />
      <main id="main-content" className="admin-main">
      <PageHeader eyebrow="Safety" title="Reports" intro="Review community reports and tell reporters the outcome." />
      {error && <p className="alert error" role="alert">{error}</p>}
      <Toolbar>
        <label><span>Status</span><select value={status} onChange={(e) => { setStatus(e.target.value); void load(e.target.value); }}>
          <option value="open">open</option><option value="in_review">in review</option>
          <option value="resolved">resolved</option><option value="dismissed">dismissed</option>
        </select></label>
        <label className="grow"><span>Resolution note</span><input placeholder="Explain the decision for the record" value={resolution} onChange={(e) => setResolution(e.target.value)} /></label>
      </Toolbar>
      {rows.length ? <div className="queue-list">{rows.map((r) => (
        <div className="queue-item" key={r.id}>
          <span className="grow"><b>{r.reason}</b> on {r.entity_type} · by {r.reporter_name} · <StatusBadge value={r.status} />
            <br /><small>{r.description ?? ''}</small></span>
          <span className="actions">
            <button className="secondary" onClick={() => resolve(r.id, 'in_review')}>in review</button>
            <button onClick={() => resolve(r.id, 'resolved')}>resolve</button>
            <button className="danger-quiet" onClick={() => resolve(r.id, 'dismissed')}>dismiss</button>
          </span>
        </div>
      ))}</div>
        : <EmptyState symbol="🌳" title="No reports here" description="Nothing filed under this status. Good news for the community record." />}
      </main>
    </div>
  );
}
