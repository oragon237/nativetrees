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
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(0);
  const [limit, setLimit] = useState(20);
  const [error, setError] = useState('');

  const pageCount = Math.max(1, Math.ceil(total / limit));

  async function load(p = page, l = limit) {
    try {
      const params = new URLSearchParams({ limit: String(l), offset: String(p * l) });
      if (q.trim()) params.set('q', q.trim());
      if (status) params.set('status', status);
      const data = await api<{ species: Row[]; total: number }>(`/api/v1/admin/species?${params}`);
      setRows(data.species);
      setTotal(data.total);
      setPage(p);
      setLimit(l);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Load failed');
    }
  }

  function search() {
    setPage(0);
    void load(0, limit);
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
        <label><span>Per page</span><select value={limit} onChange={(e) => { setLimit(Number(e.target.value)); setPage(0); void load(0, Number(e.target.value)); }}>
          <option value={10}>10</option>
          <option value={20}>20</option>
          <option value={50}>50</option>
        </select></label>
        <button onClick={search}>Search</button>
      </Toolbar>
      {error && <p className="alert error" role="alert">{error}</p>}
      {total > 0 && <p className="result-count" role="status">{total} species · page {page + 1} of {pageCount}</p>}
      {rows.length ? (
        <>
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
        <nav className="pagination" aria-label="Species pages">
          <button disabled={page === 0} onClick={() => void load(page - 1, limit)}>← Prev</button>
          {Array.from({ length: pageCount }, (_, i) => i)
            .filter((i) => i === 0 || i === pageCount - 1 || Math.abs(i - page) <= 2)
            .reduce<(number | '…')[]>((acc, i, _, arr) => {
              const prev = arr[arr.indexOf(i) - 1];
              if (typeof prev === 'number' && i - prev > 1) acc.push('…');
              acc.push(i);
              return acc;
            }, [])
            .map((i, k) => i === '…' ? <span key={`gap${k}`} className="page-gap">…</span> : (
              <button key={i} aria-current={i === page ? 'page' : undefined} aria-label={`Page ${i + 1}`}
                disabled={i === page} onClick={() => void load(i, limit)}>{i + 1}</button>
            ))}
          <button disabled={page >= pageCount - 1} onClick={() => void load(page + 1, limit)}>Next →</button>
        </nav>
        </>
      ) : (
        <EmptyState symbol="🌳" title="No species found" description="Try a different search, or add the first record to the tree database." action={{ label: '＋ Add Species', href: '/species/new' }} />
      )}
      </main>
    </div>
  );
}
