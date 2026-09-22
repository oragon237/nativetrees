import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { api } from '../api';
import AdminBar from '../components/AdminBar';
import { PageHeader, EmptyState, Toolbar } from '../components/Ui';

interface Row {
  id: string;
  scientific_name: string;
  primary_name: string | null;
  family: string;
  verification_status: string;
}

export default function SpeciesList() {
  const [q, setQ] = useState('');
  const [status, setStatus] = useState('');
  const [rows, setRows] = useState<Row[]>([]);
  const [error, setError] = useState('');

  async function load() {
    try {
      const params = new URLSearchParams({ limit: '50' });
      if (q.trim()) params.set('q', q.trim());
      if (status) params.set('status', status);
      const data = await api<{ species: Row[] }>(`/api/v1/admin/species?${params}`);
      setRows(data.species);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Load failed');
    }
  }

  useEffect(() => {
    void load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <div className="admin-shell">
      <AdminBar />
      <main id="main-content" className="admin-main">
      <div className="page-title-row"><PageHeader eyebrow="Tree database" title="Species" intro="Curate the verified native-tree record: names, ecology, photos, and references." /><Link className="kp-btn" to="/species/new">＋ Add species</Link></div>
      <Toolbar>
        <label className="search-field"><span className="sr-only">Search species</span><input placeholder="Search common or scientific name…" value={q} onChange={(e) => setQ(e.target.value)} onKeyDown={(e) => { if (e.key === 'Enter') void load(); }} /></label>
        <label><span>Status</span><select value={status} onChange={(e) => setStatus(e.target.value)}>
          <option value="">All statuses</option>
          <option value="draft">Draft</option>
          <option value="verified">Verified</option>
          <option value="archived">Archived</option>
        </select></label>
        <button onClick={load}>Search</button>
      </Toolbar>
      {error && <p className="alert error" role="alert">{error}</p>}
      {rows.length ? (
        <div className="table-wrap"><table>
          <thead><tr><th>Common</th><th>Scientific</th><th>Status</th><th></th></tr></thead>
          <tbody>
            {rows.map((r) => (
              <tr key={r.id}>
                <td>{r.primary_name ?? '—'}</td>
                <td><span className="sci">{r.scientific_name}</span></td>
                <td><span className={`badge ${r.verification_status}`}>{r.verification_status}</span></td>
                <td><Link to={`/species/${r.id}`}>Edit</Link></td>
              </tr>
            ))}
          </tbody>
        </table></div>
      ) : (
        <EmptyState symbol="🌳" title="No species found" description="Try a different search, or add the first record to the tree database." action={{ label: '＋ Add Species', href: '/species/new' }} />
      )}
      </main>
    </div>
  );
}
