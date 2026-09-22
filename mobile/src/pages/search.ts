import { api, SpeciesCard, esc } from '../api';
import { treeCard, bindCards, icon, emptyState, loadingState, pageHeader } from './ui';

const FILTERS = [
  { key: 'purpose', label: 'Purpose', options: [] as { slug: string; name: string }[] },
  { key: 'sunlight', label: 'Sunlight', options: [
    { slug: 'full-sun', name: 'Full Sun' }, { slug: 'partial-shade', name: 'Partial Shade' }, { slug: 'shade', name: 'Shade' }] },
  { key: 'site', label: 'Environment', options: [
    { slug: 'backyard', name: 'Backyard' }, { slug: 'farm', name: 'Farm' }, { slug: 'open-field', name: 'Open Field' },
    { slug: 'hillside', name: 'Hillside' }, { slug: 'riverbank', name: 'Riverbank' }, { slug: 'coastal-area', name: 'Coastal' },
    { slug: 'urban-area', name: 'Urban Area' }, { slug: 'large-property', name: 'Large Property' }] },
  { key: 'space', label: 'Space', options: [
    { slug: 'space-small', name: 'Small' }, { slug: 'space-medium', name: 'Medium' },
    { slug: 'space-large', name: 'Large' }, { slug: 'space-very-large', name: 'Very Large' }] },
];

export async function renderSearch(root: HTMLElement, params: URLSearchParams) {
  try {
    const p = await api<{ purposes: { slug: string; name: string }[] }>('/api/v1/purposes');
    FILTERS[0].options = p.purposes;
  } catch {
    /* filters still render with empty purpose list */
  }

  const current: Record<string, string> = {};
  for (const k of ['q', 'purpose', 'sunlight', 'site', 'space']) current[k] = params.get(k) ?? '';

  root.innerHTML = `
  ${pageHeader('Explore native trees', '#/home')}
  <div class="pad">
    <p class="page-intro">Meet the trees that make the Philippines unique.</p>
    <ion-searchbar id="q" debounce="300" aria-label="Search native trees" value="${esc(current.q)}" placeholder="Common, local or scientific name"></ion-searchbar>
    <details class="filters" ${Object.entries(current).some(([k, v]) => k !== 'q' && v) ? 'open' : ''}><summary>${icon('filter')} Refine your search <span id="filter-count"></span></summary><div class="filter-fields">
    ${FILTERS.map((f) => `
      <ion-item><ion-select label-placement="stacked" id="f-${f.key}" label="${f.label}" value="${esc(current[f.key])}">
        <ion-select-option value="">Any</ion-select-option>
        ${f.options.map((o) => `<ion-select-option value="${esc(o.slug)}">${esc(o.name)}</ion-select-option>`).join('')}
      </ion-select></ion-item>`).join('')}
    <div class="filter-actions"><button class="kp-btn" id="apply">Apply filters</button><button class="kp-btn clear" id="reset">Clear all</button></div>
    </div></details><div id="results" aria-live="polite"></div>
  </div>`;

  let request = 0;
  async function run() {
    const requestId = ++request;
    const box = root.querySelector('#results')!;
    box.innerHTML = loadingState('Finding native trees…');
    const qv = (root.querySelector('#q') as HTMLIonSearchbarElement)?.value ?? '';
    const ps = new URLSearchParams();
    if (qv.trim()) ps.set('q', qv.trim());
    for (const f of FILTERS) {
      const v = (root.querySelector(`#f-${f.key}`) as HTMLIonSelectElement)?.value;
      if (v) ps.set(f.key, String(v));
    }
    ps.set('limit', '30');
    const filterCount = FILTERS.filter(f => ps.has(f.key)).length;
    root.querySelector('#filter-count')!.textContent = filterCount ? `(${filterCount})` : '';
    if (root.isConnected) history.replaceState(null, '', `#/search?${ps}`);
    try {
    const data = await api<{ total: number; species: SpeciesCard[] }>(`/api/v1/species?${ps}`);
    if (requestId !== request) return;
    box.innerHTML = `<p class="result-summary"><span><b>${data.total}</b> native tree${data.total === 1 ? '' : 's'} found</span>${data.total > data.species.length ? `<small>Showing ${data.species.length}</small>` : ''}</p><div class="tree-grid">${data.species.map(treeCard).join('') || emptyState('No trees found', 'Try a different name or clear a filter to explore more trees.', 'search')}</div>`;
    bindCards(box as HTMLElement);
    } catch {
      if (requestId !== request) return;
      box.innerHTML = emptyState('Trees couldn’t be loaded', 'Check your connection, then try again.', 'info') + '<button class="kp-btn block outline" id="retry-search">Try again</button>';
      box.querySelector('#retry-search')?.addEventListener('click', () => void run());
    }
  }

  root.querySelector('#apply')?.addEventListener('click', () => void run());
  root.querySelector('#q')?.addEventListener('ionInput', () => void run());
  root.querySelector('#reset')?.addEventListener('click', () => {
    (root.querySelector('#q') as HTMLIonSearchbarElement).value = '';
    for (const f of FILTERS) (root.querySelector(`#f-${f.key}`) as HTMLIonSelectElement).value = '';
    void run();
  });
  void run();
}

