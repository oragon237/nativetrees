import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { api } from '../api';
import AdminBar from '../components/AdminBar';
import { PageHeader, SecHead, StatGrid, StatCard, EmptyState, LoadingState } from '../components/Ui';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type Buckets = { status: string; n: number }[];

export default function Dashboard() {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const [a, setA] = useState<any>(null);
  const [error, setError] = useState('');

  useEffect(() => {
    api('/api/v1/admin/analytics').then(setA).catch((e: unknown) => setError(e instanceof Error ? e.message : 'Failed'));
  }, []);

  if (!a) return <div className="admin-shell"><AdminBar /><main id="main-content" className="admin-main">{error ? <p className="alert error" role="alert">{error}</p> : <LoadingState label="Loading dashboard…" />}</main></div>;
  const buckets = (b: Buckets) => b.map((x) => `${x.status}: ${x.n}`).join(' · ') || '—';
  const openReports = (a.reports as Buckets).find((x) => x.status === 'open')?.n ?? 0;

  return (
    <div className="admin-shell">
      <AdminBar />
      <main id="main-content" className="admin-main">
      <PageHeader eyebrow="System overview" title="Dashboard" intro="The health of the native-tree platform at a glance." />
      {error && <p className="alert error" role="alert">{error}</p>}
      <StatGrid>
        <StatCard kicker="Verified species" value={String((a.species as Buckets).find((x) => x.status === 'verified')?.n ?? 0)} sub={buckets(a.species)} />
        <StatCard kicker="Users" value={String(a.users.total)} sub={`${a.users.new_30d} new in 30 days`} />
        <StatCard kicker="Observations" value={String((a.observations as Buckets).reduce((s, x) => s + x.n, 0))} sub={buckets(a.observations)} />
        <StatCard kicker="Identifications" value={String((a.identifications as Buckets).reduce((s, x) => s + x.n, 0))} sub={buckets(a.identifications)} />
        <StatCard kicker="Listings" value={String((a.listings as Buckets).reduce((s, x) => s + x.n, 0))} sub={buckets(a.listings)} />
        <StatCard kicker="Open reports" value={String(openReports)} sub={buckets(a.reports)} />
        <StatCard kicker="Pending corrections" value={String(a.corrections.pending)} sub={`${a.favorites.total} saved trees`} />
        <StatCard kicker="Moderation actions" value={String(a.moderationActions.total)} sub="Logged and auditable" />
      </StatGrid>
      <SecHead title="Needs attention" action={<Link to="/moderation">Open queue</Link>} />
      {openReports + a.corrections.pending === 0
        ? <EmptyState symbol="🌳" title="All clear" description="No open reports or pending corrections. The community record is up to date." />
        : <p className="info-note">{openReports} open report(s) and {a.corrections.pending} pending correction(s) await review in the Moderation queue.</p>}
      <SecHead title="Top purposes" />
      <ul className="purpose-summary">{a.topPurposes.map((p: { slug: string; name: string; species_count: number }) => (
        <li key={p.slug}><span>{p.name}</span><strong>{p.species_count} species</strong></li>))}</ul>
      <p className="brand-footer">Discover. Identify. Plant Native.</p>
      </main>
    </div>
  );
}
