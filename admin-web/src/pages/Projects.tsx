import { useEffect, useState } from 'react';
import { api } from '../api';
import AdminBar from '../components/AdminBar';
import { PageHeader, EmptyState, StatusBadge } from '../components/Ui';

interface Project {
  id: string;
  title: string;
  goal_trees: number;
  province: string | null;
  status: string;
  owner_name: string;
  participants: number;
  pledged: number;
}

export default function Projects() {
  const [rows, setRows] = useState<Project[]>([]);
  const [status, setStatus] = useState('active');
  const [error, setError] = useState('');

  async function load(s = status) {
    try {
      setRows((await api<{ projects: Project[] }>(`/api/v1/projects?status=${s}`)).projects);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Load failed');
    }
  }

  useEffect(() => {
    void load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  async function updateStatus(id: string, st: string) {
    try {
      await api(`/api/v1/projects/${id}`, { method: 'PATCH', body: JSON.stringify({ status: st }) });
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed');
    }
  }

  return (
    <div className="admin-shell">
      <AdminBar />
      <main id="main-content" className="admin-main">
      <PageHeader eyebrow="Community" title="Planting Projects" intro="Follow pledges and progress; complete or cancel projects here." />
      {error && <p className="alert error" role="alert">{error}</p>}
      <label className="standalone-filter"><span>Status</span><select value={status} onChange={(e) => { setStatus(e.target.value); void load(e.target.value); }}>
        <option value="active">active</option><option value="draft">draft</option>
        <option value="completed">completed</option><option value="cancelled">cancelled</option>
      </select></label>
      {rows.length ? <div className="queue-list">{rows.map((p) => (
        <div className="queue-item" key={p.id}>
          <span className="grow"><b>{p.title}</b> · {p.pledged}/{p.goal_trees} pledged · {p.participants} participants · {p.province ?? '—'} · by {p.owner_name} · <StatusBadge value={p.status} /></span>
          <span className="actions">
            <button onClick={() => updateStatus(p.id, 'completed')}>complete</button>
            <button className="danger-quiet" onClick={() => updateStatus(p.id, 'cancelled')}>cancel</button>
          </span>
        </div>
      ))}</div>
        : <EmptyState symbol="🌱" title="No projects here" description="No projects with this status yet." />}
      </main>
    </div>
  );
}
