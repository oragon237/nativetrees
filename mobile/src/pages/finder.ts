import { api, SpeciesCard, esc } from '../api';
import { treeCard, bindCards, icon, purposeMeta, pageHeader, emptyState, loadingState } from './ui';

const STEPS = [
  { key: 'purpose', title: 'What is your main purpose?', options: [] as { slug: string; name: string }[], skippable: false },
  { key: 'site', title: 'Where will you plant it?', options: [
    { slug: 'backyard', name: 'Backyard' }, { slug: 'farm', name: 'Farm' }, { slug: 'open-field', name: 'Open Field' },
    { slug: 'hillside', name: 'Hillside' }, { slug: 'riverbank', name: 'Riverbank' }, { slug: 'coastal-area', name: 'Coastal' },
    { slug: 'forest-edge', name: 'Forest Edge' }, { slug: 'forest-understory', name: 'Forest Understory' },
    { slug: 'urban-area', name: 'Urban Area' }] as { slug: string; name: string }[], skippable: false },
  { key: 'sunlight', title: 'How much sunlight?', options: [
    { slug: 'full-sun', name: 'Full Sun' }, { slug: 'partial-shade', name: 'Partial Shade' }, { slug: 'shade', name: 'Shade' },
    { slug: '', name: 'Not Sure' }] as { slug: string; name: string }[], skippable: true },
  { key: 'space', title: 'How much space is available?', options: [
    { slug: 'space-small', name: 'Small' }, { slug: 'space-medium', name: 'Medium' }, { slug: 'space-large', name: 'Large' },
    { slug: '', name: 'Not Sure' }] as { slug: string; name: string }[], skippable: true },
];

const answers: Record<string, string> = {};
let step = 0;

export async function renderFinder(root: HTMLElement) {
  step = 0;
  for (const k of Object.keys(answers)) delete answers[k];
  try {
    const p = await api<{ purposes: { slug: string; name: string }[] }>('/api/v1/purposes');
    STEPS[0].options = p.purposes;
  } catch {
    root.innerHTML = `${pageHeader('Find the right tree')}<div class="pad">${emptyState('Let’s try that again', 'We couldn’t load the planting options. Check your connection.', 'info')}<button class="kp-btn block" id="retry">Try again</button></div>`;
    root.querySelector('#retry')?.addEventListener('click', () => void renderFinder(root));
    return;
  }
  showStep(root);
}

function showStep(root: HTMLElement) {
  if (step >= STEPS.length) {
    void showResults(root);
    return;
  }
  const s = STEPS[step];
  const hints = ['Start with what you want your tree to do.', 'Choose the setting that best describes your planting site.', 'Think about the light your tree will receive each day.', 'Allow room for your tree to grow to its mature size.'];
  const labels = ['Purpose', 'Location', 'Sunlight', 'Space'];
  root.innerHTML = `
  ${pageHeader('Find the right tree', '#/home')}
  <div class="pad">
    <div class="wizard-meta"><span>Step ${step + 1} of ${STEPS.length}</span><span>${labels[step]}</span></div>
    <div class="wizard-progress" aria-label="Step ${step + 1} of ${STEPS.length}">${STEPS.map((_, i) => `<span class="${i <= step ? 'done' : ''}"></span>`).join('')}</div>
    <h1>${esc(s.title)}</h1><p class="page-intro">${hints[step]}</p>
    <div class="opt-list">
      ${s.options.map((o) => `<button class="opt" aria-pressed="${answers[s.key] === o.slug}" data-v="${esc(o.slug)}">${icon(purposeMeta[o.slug]?.icon ?? ['leaf', 'pin', 'sun', 'tree'][step])}<span>${esc(o.name)}</span></button>`).join('')}
    </div>
    <div class="wizard-actions">${step > 0 ? `<button class="kp-btn clear" id="back">← Back</button>` : '<span></span>'}<button class="kp-btn" id="next" ${s.key in answers ? '' : 'disabled'}>${step === STEPS.length - 1 ? 'See matching trees' : 'Continue'} ${icon('arrow')}</button></div>
    ${s.skippable ? `<button class="kp-btn clear block" id="skip">I’m not sure — skip this step</button>` : ''}
  </div>`;
  void (root.closest('ion-content') as HTMLIonContentElement | null)?.scrollToTop(0);
  const heading = root.querySelector('h1');
  if (heading) { heading.tabIndex = -1; heading.focus({ preventScroll: true }); }
  root.querySelectorAll('.opt').forEach((el) => {
    el.addEventListener('click', () => {
      answers[s.key] = (el as HTMLElement).dataset.v ?? '';
      root.querySelectorAll('.opt').forEach(option => option.setAttribute('aria-pressed', String(option === el)));
      (root.querySelector('#next') as HTMLButtonElement).disabled = false;
    });
  });
  root.querySelector('#next')?.addEventListener('click', () => { step++; showStep(root); });
  root.querySelector('#skip')?.addEventListener('click', () => {
    answers[s.key] = '';
    step++;
    showStep(root);
  });
  root.querySelector('#back')?.addEventListener('click', () => {
    step--;
    showStep(root);
  });
}

async function showResults(root: HTMLElement) {
  void (root.closest('ion-content') as HTMLIonContentElement | null)?.scrollToTop(0);
  const ps = new URLSearchParams({ limit: '20' });
  for (const [k, v] of Object.entries(answers)) if (v) ps.set(k, v);
  root.innerHTML = `${pageHeader('Matching trees')}<div class="pad">${loadingState('Finding trees for your space…')}</div>`;
  try {
    const list = await api<{ total: number; matches: SpeciesCard[] }>(`/api/v1/recommendations?${ps}`);
    root.innerHTML = `
    <ion-header><ion-toolbar><ion-title>Matching Trees</ion-title></ion-toolbar></ion-header>
    <div class="pad">
      <p class="eyebrow">Your planting shortlist</p><h1>Rooted in your needs.</h1>
      <p><b>${list.total}</b> native tree${list.total === 1 ? '' : 's'} matching your conditions</p>
      <div class="chips">${STEPS.map(s => { const option = s.options.find(o => o.slug === answers[s.key]); return option && option.slug ? `<ion-chip>${esc(option.name)}</ion-chip>` : ''; }).join('')}</div>
      <div class="info-note">${icon('info')}These matches are a starting point. Check each tree’s mature size and local growing conditions before planting.</div>
      ${list.matches.map((m) => treeCard(m) + (m.matchReasons?.length ? `<div class="reasons"><strong>Why it fits</strong><br/>${m.matchReasons.map((r) => `<small>✓ ${esc(r)}</small>`).join('<br/>')}</div>` : '')).join('') || emptyState('No matches just yet', 'Try fewer conditions to give your next tree more room to fit.', 'tree')}
      <button class="kp-btn block outline" id="edit">Adjust my answers</button><button class="kp-btn block clear" id="again">Start over</button>
    </div>`;
    root.querySelector('#again')?.addEventListener('click', () => void renderFinder(root));
    root.querySelector('#edit')?.addEventListener('click', () => { step = 0; showStep(root); });
    bindCards(root);
  } catch {
    root.innerHTML = `${pageHeader('Matching trees')}<div class="pad">${emptyState('We couldn’t find your matches', 'Your answers are still here. Check your connection and try again.', 'info')}<button class="kp-btn block" id="retry">Try again</button><button class="kp-btn block clear" id="edit">Adjust answers</button></div>`;
    root.querySelector('#retry')?.addEventListener('click', () => void showResults(root));
    root.querySelector('#edit')?.addEventListener('click', () => { step = 0; showStep(root); });
  }
}

