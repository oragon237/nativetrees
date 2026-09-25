import { useEffect, useState } from 'react';
import { api } from '../api';
import AdminBar from '../components/AdminBar';
import { PageHeader, SecHead, EmptyState, StatusBadge } from '../components/Ui';

type Kind = 'species' | 'photos';
type Status = '' | 'pending' | 'under_review' | 'needs_more_info' | 'approved' | 'rejected';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type Detail = any;

const STATUSES: { v: Status; label: string }[] = [
  { v: '', label: 'All' },
  { v: 'pending', label: 'Pending' },
  { v: 'under_review', label: 'Under review' },
  { v: 'needs_more_info', label: 'Needs more info' },
  { v: 'approved', label: 'Approved' },
  { v: 'rejected', label: 'Rejected' },
];

export default function Contributions() {
  const [kind, setKind] = useState<Kind>('species');
  const [status, setStatus] = useState<Status>('pending');
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const [rows, setRows] = useState<any[]>([]);
  const [detail, setDetail] = useState<Detail>(null);
  const [error, setError] = useState('');
  const [msg, setMsg] = useState('');
  const [message, setMessage] = useState('');
  const [approve, setApprove] = useState({ family: '', scientific_name: '', common_name: '' });

  async function load(k = kind, s = status) {
    try {
      const base = k === 'species' ? '/api/v1/admin/species-contributions' : '/api/v1/admin/photo-contributions';
      const params = new URLSearchParams({ limit: '50' });
      if (s) params.set('status', s);
      setRows((await api<{ contributions: unknown[] }>(`${base}?${params}`)).contributions);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Load failed');
    }
  }

  useEffect(() => {
    void load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  function switchKind(k: Kind) {
    setKind(k);
    setDetail(null);
    void load(k, status);
  }

  function switchStatus(s: Status) {
    setStatus(s);
    setDetail(null);
    void load(kind, s);
  }

  async function open(id: string) {
    try {
      const base = kind === 'species' ? '/api/v1/admin/species-contributions' : '/api/v1/admin/photo-contributions';
      const d = await api<Detail>(`${base}/${id}`);
      setDetail(d);
      const c = d.contribution;
      setApprove({
        family: '',
        scientific_name: c.proposed_scientific_name ?? '',
        common_name: c.proposed_common_name ?? '',
      });
      setMessage(c.review_notes ?? '');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Load failed');
    }
  }

  async function act(path: string, body: unknown = {}) {
    setError('');
    setMsg('');
    try {
      const out = await api<Detail>(path, { method: 'POST', body: JSON.stringify(body) });
      setMsg('Done.');
      await load();
      if (detail) await open(detail.contribution.id);
      return out;
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Action failed');
      throw err;
    }
  }

  const base = kind === 'species' ? '/api/v1/admin/species-contributions' : '/api/v1/admin/photo-contributions';

  return (
    <div className="admin-shell">
      <AdminBar />
      <main id="main-content" className="admin-main">
        <PageHeader eyebrow="Community" title="Contributions" intro="Review proposed species and gallery photos. Nothing becomes official data without approval here." />
        {error && <p className="alert error" role="alert">{error}</p>}
        {msg && <p className="alert success" role="status">{msg}</p>}
        <div style={{ marginBottom: 12 }}>
          <button onClick={() => switchKind('species')} disabled={kind === 'species'}>New species</button>{' '}
          <button onClick={() => switchKind('photos')} disabled={kind === 'photos'}>Species photos</button>{' '}
          <select value={status} onChange={(e) => switchStatus(e.target.value as Status)}>
            {STATUSES.map((s) => <option key={s.v} value={s.v}>{s.label}</option>)}
          </select>
        </div>
        {rows.length ? (
          <div className="queue-list">{rows.map((r) => (
            <div className="queue-item" key={r.id}>
              <span className="grow">
                <b>{kind === 'species' ? r.proposed_common_name : (r.species_name ?? r.scientific_name)}</b>
                {kind === 'species' && r.proposed_scientific_name ? <span className="sci"> {r.proposed_scientific_name}</span> : null}
                {' '}· {r.contributor ?? r.contributor_name ?? ''} · <StatusBadge value={r.status} />
              </span>
              <span className="actions"><button onClick={() => open(r.id)}>Review</button></span>
            </div>
          ))}</div>
        ) : (
          <EmptyState symbol="🌳" title="Queue clear" description="No contributions under this filter." />
        )}

        {detail && kind === 'species' && (
          <div className="editor-panel" style={{ marginTop: 16 }}>
            <SecHead title={detail.contribution.proposed_common_name} />
            <p>Contributor: {detail.contribution.contributor ?? detail.contributor?.display_name ?? '—'}
              {detail.contribution.proposed_scientific_name ? <span className="sci"> · {detail.contribution.proposed_scientific_name}</span> : ' · scientific name unknown'}</p>
            <p>{detail.contribution.description}</p>
            <p><small>
              Location: {detail.contribution.location_text ?? '—'} ({detail.contribution.location_precision}) ·
              Observed: {detail.contribution.observed_at?.slice(0, 10) ?? '—'} ·
              Source: {detail.contribution.source_reference ?? '—'}
            </small></p>
            {detail.contribution.review_notes && <p className="info-note">Feedback: {detail.contribution.review_notes}</p>}
            <div className="imgrow">{detail.photos.map((p: { id: string; file_url: string; photo_type: string }) => (
              <img key={p.id} src={p.file_url} alt={p.photo_type} />
            ))}</div>
            {!!detail.possibleDuplicates?.length && (
              <div className="info-note"><div><strong>Possible duplicates:</strong>
                {detail.possibleDuplicates.map((m: { id: string; primary_name: string | null; scientific_name: string }) => (
                  <span key={m.id}> {m.primary_name ?? m.scientific_name} (<span className="sci">{m.scientific_name}</span>);</span>
                ))}
              </div></div>
            )}
            <SecHead title="Publish (admin)" />
            <div className="form-grid">
              <div><label><span>Family *</span><input value={approve.family} onChange={(e) => setApprove({ ...approve, family: e.target.value })} placeholder="e.g. Dipterocarpaceae" /></label></div>
              <div><label><span>Scientific name</span><input value={approve.scientific_name} onChange={(e) => setApprove({ ...approve, scientific_name: e.target.value })} /></label></div>
              <div><label><span>Common name</span><input value={approve.common_name} onChange={(e) => setApprove({ ...approve, common_name: e.target.value })} /></label></div>
            </div>
            <div style={{ marginTop: 8 }}>
              <button onClick={() => act(`${base}/${detail.contribution.id}/approve`, {
                family: approve.family,
                ...(approve.scientific_name ? { scientific_name: approve.scientific_name } : {}),
                ...(approve.common_name ? { common_name: approve.common_name } : {}),
              })}>Approve & publish</button>{' '}
              <button onClick={() => act(`${base}/${detail.contribution.id}/request-info`, { message })}>Request more info</button>{' '}
              <button onClick={() => act(`${base}/${detail.contribution.id}/reject`, { message })}>Reject</button>
            </div>
            <div style={{ marginTop: 8 }}>
              <label><span>Reviewer message</span><input value={message} onChange={(e) => setMessage(e.target.value)} style={{ width: '100%' }} placeholder="e.g. Please upload a clear leaf photo." /></label>
            </div>
          </div>
        )}

        {detail && kind === 'photos' && (
          <div className="editor-panel" style={{ marginTop: 16 }}>
            <SecHead title="Photo review" />
            <img src={detail.contribution.file_url} alt={detail.contribution.photo_type} style={{ maxWidth: 320, borderRadius: 12 }} />
            <p>Species: <span className="sci">{detail.contribution.scientific_name}</span> · Category: {detail.contribution.photo_type.replace(/_/g, ' ')} · by {detail.contribution.contributor}</p>
            {detail.contribution.caption && <p>{detail.contribution.caption}</p>}
            {detail.contribution.review_notes && <p className="info-note">Feedback: {detail.contribution.review_notes}</p>}
            <div style={{ marginTop: 8 }}>
              <button onClick={() => act(`${base}/${detail.contribution.id}/approve`)}>Approve to gallery</button>{' '}
              <button onClick={() => act(`${base}/${detail.contribution.id}/request-info`, { message })}>Request more info</button>{' '}
              <button onClick={() => act(`${base}/${detail.contribution.id}/reject`, { message })}>Reject</button>
            </div>
            <div style={{ marginTop: 8 }}>
              <label><span>Reviewer message</span><input value={message} onChange={(e) => setMessage(e.target.value)} style={{ width: '100%' }} /></label>
            </div>
          </div>
        )}
      </main>
    </div>
  );
}
