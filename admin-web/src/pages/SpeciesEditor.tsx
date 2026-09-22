import { useEffect, useState } from 'react';
import { Link, useNavigate, useParams } from 'react-router-dom';
import { api } from '../api';
import AdminBar from '../components/AdminBar';
import { LoadingState, PageHeader, StatusBadge } from '../components/Ui';

interface Detail {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  species: any;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  names: any[];
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  photos: any[];
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  purposes: any[];
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  plantingConditions: any[];
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  distribution: any[];
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  references: any[];
}

const TABS = ['General', 'Names', 'Purposes', 'Conditions', 'Distribution', 'References', 'Photos'];

function MergeBox({ id, onDone }: { id: string; onDone: () => void }) {
  const [q, setQ] = useState('');
  const [opts, setOpts] = useState<{ id: string; scientific_name: string }[]>([]);
  const [msg, setMsg] = useState('');
  async function search() {
    const d = await api<{ species: { id: string; scientific_name: string }[] }>(
      `/api/v1/admin/species?q=${encodeURIComponent(q)}&limit=5`).catch(() => ({ species: [] }));
    setOpts(d.species.filter((s) => s.id !== id));
  }
  async function merge(into: string) {
    if (!window.confirm('Merge this record into the selected species? This archives the current record.')) return;
    try {
      await api(`/api/v1/admin/species/${id}/merge`, { method: 'POST', body: JSON.stringify({ into_id: into }) });
      setMsg('Merged.');
      onDone();
    } catch (e) {
      setMsg(e instanceof Error ? e.message : 'Merge failed');
    }
  }
  return (
    <div className="merge-box">
      <div className="inline-form"><input aria-label="Search target species" placeholder="Search target species…" value={q} onChange={(e) => setQ(e.target.value)} />
      <button onClick={search}>Search</button>
      </div>
      {opts.map((o) => <p key={o.id}><i>{o.scientific_name}</i> <button onClick={() => merge(o.id)}>Merge into this</button></p>)}
      {msg && <p>{msg}</p>}
    </div>
  );
}

export default function SpeciesEditor() {
  const { id } = useParams();
  const isNew = id === 'new';
  const nav = useNavigate();
  const [tab, setTab] = useState('General');
  const [detail, setDetail] = useState<Detail | null>(null);
  const [purposes, setPurposes] = useState<{ slug: string; name: string }[]>([]);
  const [conditions, setConditions] = useState<Record<string, { slug: string; name: string }[]>>({});
  const [error, setError] = useState('');
  const [msg, setMsg] = useState('');
  // create-form state
  const [form, setForm] = useState({
    scientific_name: '', genus: '', species_epithet: '', family: '',
    native_status: 'native', description: '', common_name: '',
  });
  // general-edit state
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const [gen, setGen] = useState<any>({});
  const [newName, setNewName] = useState({ name: '', name_type: 'common', is_primary: true });
  const [newPurpose, setNewPurpose] = useState('');
  const [newCondition, setNewCondition] = useState('');
  const [newDist, setNewDist] = useState({ province: '', island_group: '' });
  const [newRef, setNewRef] = useState({ title: '', organization: '' });
  const [photoType, setPhotoType] = useState('whole_tree');
  const [photoFile, setPhotoFile] = useState<File | null>(null);

  async function load() {
    try {
      const [d, p, c] = await Promise.all([
        api<Detail>(`/api/v1/admin/species/${id}`),
        api<{ purposes: { slug: string; name: string }[] }>('/api/v1/purposes'),
        api<{ conditions: Record<string, { slug: string; name: string }[]> }>('/api/v1/planting-conditions'),
      ]);
      setDetail(d);
      setGen({
        description: d.species.description ?? '',
        growth_form: d.species.growth_form ?? '',
        growth_rate: d.species.growth_rate ?? '',
        min_height_m: d.species.min_height_m ?? '',
        max_height_m: d.species.max_height_m ?? '',
        min_canopy_m: d.species.min_canopy_m ?? '',
        max_canopy_m: d.species.max_canopy_m ?? '',
        fruit_bearing: !!d.species.fruit_bearing,
        flowering: !!d.species.flowering,
        conservation_status: d.species.conservation_status ?? '',
      });
      setPurposes(p.purposes);
      setConditions(c.conditions);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Load failed');
    }
  }

  useEffect(() => {
    if (!isNew) void load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id]);

  async function mutate<T>(path: string, init?: RequestInit): Promise<T> {
    setError('');
    setMsg('');
    try {
      const out = await api<T>(path, init);
      await load();
      setMsg('Saved.');
      return out;
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed');
      throw err;
    }
  }

  async function create(e: React.FormEvent) {
    e.preventDefault();
    try {
      const out = await api<{ species: { id: string } }>('/api/v1/admin/species', {
        method: 'POST',
        body: JSON.stringify({
          ...form,
          names: form.common_name.trim()
            ? [{ name: form.common_name.trim(), name_type: 'common', is_primary: true }]
            : [],
        }),
      });
      nav(`/species/${out.species.id}`);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Create failed');
    }
  }

  if (isNew) {
    return (
      <div className="admin-shell">
        <AdminBar />
        <main id="main-content" className="admin-main editor-main">
        <Link className="back-link" to="/">← Back to species</Link>
        <PageHeader eyebrow="Tree database" title="Create species record" intro="Start with the accepted scientific identity. You can add ecology, purposes, distribution, references, and photos after creating the draft." />
        {error && <p className="alert error" role="alert">{error}</p>}
        <form className="editor-panel form-grid" onSubmit={create}>
          {(['scientific_name', 'genus', 'species_epithet', 'family', 'common_name'] as const).map((k) => (
            <div key={k} className={k === 'scientific_name' || k === 'common_name' ? 'full' : ''}>
              <label><span>{k.replace(/_/g, ' ')}</span>
                <input value={form[k]} onChange={(e) => setForm({ ...form, [k]: e.target.value })} required={k !== 'common_name'} />
              </label>
            </div>
          ))}
          <div><label><span>Native status</span>
            <select value={form.native_status} onChange={(e) => setForm({ ...form, native_status: e.target.value })}>
              <option value="native">native</option><option value="endemic">endemic</option>
            </select></label>
          </div>
          <div className="full"><label><span>Description</span>
            <textarea value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} rows={5} />
          </label></div>
          <div className="full form-actions"><Link className="kp-btn secondary" to="/">Cancel</Link><button type="submit">Create draft</button></div>
        </form>
        </main>
      </div>
    );
  }

  if (!detail) return <div className="admin-shell"><AdminBar /><main id="main-content" className="admin-main">{error ? <p className="alert error" role="alert">{error}</p> : <LoadingState label="Loading species record…" />}</main></div>;
  const s = detail.species;

  return (
    <div className="admin-shell">
      <AdminBar />
      <main id="main-content" className="admin-main editor-main">
      <Link className="back-link" to="/">← Back to species</Link>
      <div className="species-heading"><div><p className="eyebrow">Species record</p><h1>{detail.names.find((n) => n.is_primary)?.name ?? s.scientific_name}</h1><p className="page-intro"><i>{s.scientific_name}</i> · <StatusBadge value={s.verification_status} /></p></div>
      <div className="record-actions">
        <button onClick={() => mutate(`/api/v1/admin/species/${id}/publish`, { method: 'POST' })}>Publish record</button>
        <button className="secondary" onClick={() => mutate(`/api/v1/admin/species/${id}`, { method: 'PATCH', body: JSON.stringify({ is_featured: !s.is_featured }) })}>{s.is_featured ? '★ Featured' : '☆ Feature'}</button>
        <button className="danger-quiet" onClick={() => mutate(`/api/v1/admin/species/${id}/archive`, { method: 'POST' })}>Archive</button>
      </div></div>
      <div className="editor-tabs" role="tablist" aria-label="Species record sections">
        {TABS.map((t) => (
          <button key={t} role="tab" aria-selected={tab === t} onClick={() => setTab(t)}>{t}</button>
        ))}
      </div>
      <details className="merge-details">
        <summary>Merge duplicate into another species…</summary>
        <MergeBox id={id!} onDone={load} />
      </details>
      {error && <p className="alert error" role="alert">{error}</p>}
      {msg && <p className="alert success" role="status">{msg}</p>}

      {tab === 'General' && (
        <div className="editor-panel form-grid">
          {(['description', 'growth_form', 'growth_rate', 'min_height_m', 'max_height_m', 'min_canopy_m', 'max_canopy_m', 'conservation_status'] as const).map((k) => (
            <div key={k} className={k === 'description' ? 'full' : ''}><label><span>{k.replace(/_/g, ' ')}</span>
              <input value={gen[k] ?? ''} onChange={(e) => setGen({ ...gen, [k]: e.target.value })} />
            </label></div>
          ))}
          <label className="check-field"><input type="checkbox" checked={gen.fruit_bearing} onChange={(e) => setGen({ ...gen, fruit_bearing: e.target.checked })} /> Fruit-bearing</label>
          <label className="check-field"><input type="checkbox" checked={gen.flowering} onChange={(e) => setGen({ ...gen, flowering: e.target.checked })} /> Flowering</label>
          <div className="full form-actions">
            <button onClick={() => mutate(`/api/v1/admin/species/${id}`, { method: 'PATCH', body: JSON.stringify(gen) })}>Save general</button>
          </div>
        </div>
      )}

      {tab === 'Names' && (
        <div className="editor-panel">
          <ul>{detail.names.map((n) => (
            <li key={n.id}>{n.name} ({n.name_type}{n.is_primary ? ', primary' : ''})
              <button onClick={() => mutate(`/api/v1/admin/species/${id}/names/${n.id}`, { method: 'DELETE' })}>remove</button>
            </li>))}
          </ul>
          <input placeholder="Name" value={newName.name} onChange={(e) => setNewName({ ...newName, name: e.target.value })} />
          <select value={newName.name_type} onChange={(e) => setNewName({ ...newName, name_type: e.target.value })}>
            <option value="common">common</option><option value="local">local</option><option value="alternative">alternative</option>
          </select>
          <label><input type="checkbox" checked={newName.is_primary} onChange={(e) => setNewName({ ...newName, is_primary: e.target.checked })} /> primary</label>
          <button onClick={() => mutate(`/api/v1/admin/species/${id}/names`, { method: 'POST', body: JSON.stringify(newName) })}>Add</button>
        </div>
      )}

      {tab === 'Purposes' && (
        <div className="editor-panel">
          <ul>{detail.purposes.map((p) => (
            <li key={p.id}>{p.name} ({p.suitability})
              <button onClick={() => mutate(`/api/v1/admin/species/${id}/purposes/${p.id}`, { method: 'DELETE' })}>remove</button>
            </li>))}
          </ul>
          <select value={newPurpose} onChange={(e) => setNewPurpose(e.target.value)}>
            <option value="">Select purpose…</option>
            {purposes.map((p) => <option key={p.slug} value={p.slug}>{p.name}</option>)}
          </select>
          <button disabled={!newPurpose} onClick={() => mutate(`/api/v1/admin/species/${id}/purposes`, { method: 'POST', body: JSON.stringify({ purpose_slug: newPurpose }) })}>Add</button>
        </div>
      )}

      {tab === 'Conditions' && (
        <div className="editor-panel">
          <ul>{detail.plantingConditions.map((c) => (
            <li key={c.id}>{c.name} ({c.category}, {c.suitability})
              <button onClick={() => mutate(`/api/v1/admin/species/${id}/conditions/${c.id}`, { method: 'DELETE' })}>remove</button>
            </li>))}
          </ul>
          <select value={newCondition} onChange={(e) => setNewCondition(e.target.value)}>
            <option value="">Select condition…</option>
            {Object.entries(conditions).map(([cat, list]) => (
              <optgroup key={cat} label={cat}>
                {list.map((c) => <option key={c.slug} value={c.slug}>{c.name}</option>)}
              </optgroup>
            ))}
          </select>
          <button disabled={!newCondition} onClick={() => mutate(`/api/v1/admin/species/${id}/conditions`, { method: 'POST', body: JSON.stringify({ condition_slug: newCondition }) })}>Add</button>
        </div>
      )}

      {tab === 'Distribution' && (
        <div className="editor-panel">
          <ul>{detail.distribution.map((d) => (
            <li key={d.id}>{[d.province, d.region, d.island_group].filter(Boolean).join(', ') || '—'} ({d.distribution_type})
              <button onClick={() => mutate(`/api/v1/admin/species/${id}/distribution/${d.id}`, { method: 'DELETE' })}>remove</button>
            </li>))}
          </ul>
          <input placeholder="Province" value={newDist.province} onChange={(e) => setNewDist({ ...newDist, province: e.target.value })} />
          <select value={newDist.island_group} onChange={(e) => setNewDist({ ...newDist, island_group: e.target.value })}>
            <option value="">Island group…</option><option value="Luzon">Luzon</option><option value="Visayas">Visayas</option><option value="Mindanao">Mindanao</option>
          </select>
          <button onClick={() => mutate(`/api/v1/admin/species/${id}/distribution`, { method: 'POST', body: JSON.stringify(newDist) })}>Add</button>
        </div>
      )}

      {tab === 'References' && (
        <div className="editor-panel">
          <ul>{detail.references.map((r) => (
            <li key={r.id}>{r.title}{r.organization ? ` — ${r.organization}` : ''}
              <button onClick={() => mutate(`/api/v1/admin/species/${id}/references/${r.id}`, { method: 'DELETE' })}>remove</button>
            </li>))}
          </ul>
          <input placeholder="Title" value={newRef.title} onChange={(e) => setNewRef({ ...newRef, title: e.target.value })} />
          <input placeholder="Organization" value={newRef.organization} onChange={(e) => setNewRef({ ...newRef, organization: e.target.value })} />
          <button onClick={() => mutate(`/api/v1/admin/species/${id}/references`, { method: 'POST', body: JSON.stringify(newRef) })}>Add</button>
        </div>
      )}

      {tab === 'Photos' && (
        <div className="editor-panel photo-panel">
          <ul>{detail.photos.map((p) => (
            <li key={p.id}>
              {p.file_url && <a href={p.file_url} target="_blank" rel="noreferrer">{p.photo_type}</a>}
              {!p.file_url && p.photo_type} [{p.verification_status}] {p.caption ?? ''}
              <button onClick={() => mutate(`/api/v1/admin/species/${id}/photos/${p.id}`, { method: 'PATCH', body: JSON.stringify({ verification_status: 'verified' }) })}>verify</button>
              <button onClick={() => mutate(`/api/v1/admin/species/${id}/photos/${p.id}`, { method: 'DELETE' })}>remove</button>
            </li>))}
          </ul>
          <input type="file" accept="image/*" onChange={(e) => setPhotoFile(e.target.files?.[0] ?? null)} />
          <select value={photoType} onChange={(e) => setPhotoType(e.target.value)}>
            {['whole_tree', 'leaf', 'bark', 'flower', 'fruit', 'seed', 'seedling'].map((t) => <option key={t} value={t}>{t}</option>)}
          </select>
          <button disabled={!photoFile} onClick={async () => {
            if (!photoFile) return;
            const fd = new FormData();
            fd.append('photo', photoFile);
            fd.append('photo_type', photoType);
            await mutate(`/api/v1/admin/species/${id}/photos`, { method: 'POST', body: fd });
            setPhotoFile(null);
          }}>Upload</button>
        </div>
      )}
      </main>
    </div>
  );
}
