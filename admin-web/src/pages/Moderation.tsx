import { useEffect, useState } from 'react';
import { api } from '../api';
import AdminBar from '../components/AdminBar';
import { PageHeader, SecHead, EmptyState, LoadingState, StatusBadge } from '../components/Ui';

interface Queue {
  observations: { id: string; status: string; province: string | null; contributor: string; created_at: string }[];
  identifications: { id: string; status: string; province: string | null; suggestion_count: number; created_at: string }[];
  listings: { id: string; title: string; material_type: string; province: string; seller_name: string; created_at: string }[];
  corrections: { id: string; field_name: string; proposed_value: string; scientific_name: string; submitted_by: string }[];
  reports: { id: string; entity_type: string; reason: string; created_at: string }[];
}

export default function Moderation() {
  const [q, setQ] = useState<Queue | null>(null);
  const [nurseries, setNurseries] = useState<{ id: string; business_name: string; province: string | null; display_name: string }[]>([]);
  const [orgs, setOrgs] = useState<{ id: string; name: string; org_type: string; display_name: string }[]>([]);
  const [error, setError] = useState('');
  const [reason, setReason] = useState('');

  async function load() {
    try {
      const [queue, n, o] = await Promise.all([
        api<Queue>('/api/v1/admin/review-queue?limit=30'),
        api<{ pending: { id: string; business_name: string; province: string | null; display_name: string }[] }>('/api/v1/admin/nurseries').catch(() => ({ pending: [] })),
        api<{ pending: { id: string; name: string; org_type: string; display_name: string }[] }>('/api/v1/admin/organizations').catch(() => ({ pending: [] })),
      ]);
      setQ(queue);
      setNurseries(n.pending);
      setOrgs(o.pending);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Load failed');
    }
  }

  useEffect(() => {
    void load();
  }, []);

  async function act(path: string, body: unknown = {}) {
    setError('');
    try {
      await api(path, { method: 'POST', body: JSON.stringify(body) });
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Action failed');
    }
  }

  if (!q) return <div className="admin-shell"><AdminBar /><main id="main-content" className="admin-main">{error ? <p className="alert error" role="alert">{error}</p> : <LoadingState label="Loading moderation queue…" />}</main></div>;

  const total = nurseries.length + orgs.length + q.observations.length + q.identifications.length + q.listings.length + q.corrections.length;

  const section = (title: string, count: number, empty: string, items: React.ReactNode) => (
    <div>
      <SecHead title={`${title} (${count})`} />
      {count ? <div className="queue-list">{items}</div> : <EmptyState symbol="🌳" title={empty} description="Nothing waiting here right now." />}
    </div>
  );

  return (
    <div className="admin-shell">
      <AdminBar />
      <main id="main-content" className="admin-main">
      <PageHeader eyebrow="Community review" title="Moderation Queue" intro={`${total} item(s) waiting across observations, identifications, listings, corrections, verifications.`} />
      {error && <p className="alert error" role="alert">{error}</p>}
      <div className="review-note"><label><span>Moderator note</span><input placeholder="Required when rejecting or requesting information" value={reason} onChange={(e) => setReason(e.target.value)} /></label><small>This note is applied to the next relevant action.</small></div>

      {section('🏪 Nursery verifications', nurseries.length, 'No nurseries waiting', nurseries.map((n) => (
        <div className="queue-item" key={n.id}>
          <span className="grow"><b>{n.business_name}</b> · {n.province ?? '—'} · by {n.display_name}</span>
          <span className="actions">
            <button onClick={() => act(`/api/v1/admin/nurseries/${n.id}/approve`)}>verify</button>
            <button onClick={() => act(`/api/v1/admin/nurseries/${n.id}/reject`)}>reject</button>
          </span>
        </div>
      )))}

      {section('🏢 Organizations', orgs.length, 'No organizations waiting', orgs.map((o) => (
        <div className="queue-item" key={o.id}>
          <span className="grow"><b>{o.name}</b> ({o.org_type}) · by {o.display_name}</span>
          <span className="actions">
            <button onClick={() => act(`/api/v1/admin/organizations/${o.id}/approve`)}>verify</button>
            <button onClick={() => act(`/api/v1/admin/organizations/${o.id}/reject`)}>reject</button>
          </span>
        </div>
      )))}

      {section('🌱 Observations', q.observations.length, 'No observations waiting', q.observations.map((o) => (
        <div className="queue-item" key={o.id}>
          <span className="grow">{o.contributor} · {o.province ?? '—'} · <StatusBadge value={o.status} /></span>
          <span className="actions">
            <button onClick={() => act(`/api/v1/observations/${o.id}/approve`)}>approve</button>
            <button onClick={() => act(`/api/v1/observations/${o.id}/request-info`, { reason })}>request info</button>
            <button onClick={() => act(`/api/v1/observations/${o.id}/reject`, { reason })}>reject</button>
          </span>
        </div>
      )))}

      {section('📷 Identifications', q.identifications.length, 'No identifications waiting', q.identifications.map((r) => (
        <div className="queue-item" key={r.id}>
          <span className="grow">{r.id.slice(0, 8)}… · {r.province ?? '—'} · {r.suggestion_count} suggestions · <StatusBadge value={r.status} /></span>
          <span className="actions">
            <button onClick={() => act(`/api/v1/identifications/${r.id}/review`)}>needs review</button>
            <button onClick={() => act(`/api/v1/identifications/${r.id}/unresolved`, { reason })}>unresolved</button>
          </span>
        </div>
      )))}

      {section('🛒 Marketplace listings', q.listings.length, 'No listings waiting', q.listings.map((l) => (
        <div className="queue-item" key={l.id}>
          <span className="grow"><b>{l.title}</b> · {l.material_type} · {l.province} · {l.seller_name}</span>
          <span className="actions">
            <button onClick={() => act(`/api/v1/marketplace/${l.id}/approve`)}>approve</button>
            <button onClick={() => act(`/api/v1/marketplace/${l.id}/reject`, { reason })}>reject</button>
          </span>
        </div>
      )))}

      {section('✏️ Corrections', q.corrections.length, 'No corrections waiting', q.corrections.map((c) => (
        <div className="queue-item" key={c.id}>
          <span className="grow"><span className="sci">{c.scientific_name}</span> · {c.field_name} → “{c.proposed_value.slice(0, 80)}” · by {c.submitted_by}</span>
          <span className="actions">
            <button onClick={() => act(`/api/v1/corrections/${c.id}/approve`)}>approve & apply</button>
            <button onClick={() => act(`/api/v1/corrections/${c.id}/reject`, { reason })}>reject</button>
          </span>
        </div>
      )))}
      <p className="brand-footer">Discover. Identify. Plant Native.</p>
      </main>
    </div>
  );
}
