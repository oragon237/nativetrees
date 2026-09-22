import { api, getToken, esc } from '../api';
import { bindAsyncAction, toast, emptyState, icon } from './ui';

interface Project {
  id: string;
  title: string;
  description: string;
  goal_trees: number;
  province: string | null;
  status: string;
  owner_name: string;
  participants: number;
  pledged: number;
}

export async function renderProjects(root: HTMLElement) {
  const data = await api<{ projects: Project[] }>('/api/v1/projects').catch(() => ({ projects: [] }));
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-title>Planting Projects</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    <p class="eyebrow">Growing together</p><h1>Plant a shared future.</h1><p class="page-intro">Join your community in bringing native trees back.</p>
    ${getToken() ? `<button class="kp-btn block" data-href="#/project/new">${icon('sprout')} Start a project</button>` : '<p><a href="#/login">Log in</a> to start or join projects.</p>'}
    ${data.projects.map((p) => `
      <ion-card button data-id="${p.id}">
        <ion-card-header><ion-card-title>${esc(p.title)}</ion-card-title>
        <ion-card-subtitle>${p.pledged}/${p.goal_trees} trees pledged · ${p.participants} participants</ion-card-subtitle></ion-card-header>
        <ion-card-content>${esc(p.province ?? '')} · by ${esc(p.owner_name)}</ion-card-content>
      </ion-card>`).join('') || emptyState('Room for something bigger', 'Community planting projects will appear here. Start one to bring people together.', 'tree')}
  </div>`;
  root.querySelectorAll('ion-card[data-id]').forEach((el) => {
    el.addEventListener('click', () => (window.location.hash = `#/project/${(el as HTMLElement).dataset.id}`));
  });
}

export async function renderProjectDetail(root: HTMLElement, id: string) {
  const d = await api<{ project: Project; participants: { display_name: string; pledged_trees: number }[] }>(
    `/api/v1/projects/${id}`).catch(() => null);
  if (!d) {
    root.innerHTML = `<div class="pad"><p>Project not found.</p></div>`;
    return;
  }
  const p = d.project;
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-buttons slot="start"><button class="kp-btn clear" data-href="#/projects" aria-label="Back">←</button></ion-buttons>
  <ion-title>Project</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    <h2 class="brand-word">${esc(p.title)}</h2>
    <p>${p.pledged}/${p.goal_trees} trees pledged · ${p.participants} participants<br/>${esc(p.province ?? '')} · by ${esc(p.owner_name)}</p>
    <p>${esc(p.description)}</p>
    ${getToken() ? '<ion-item><ion-input label-placement="stacked" id="pledge" label="Trees I pledge" type="number" value="1"></ion-input></ion-item><button class="kp-btn block" id="join">Join project</button>' : '<p><a href="#/login">Log in</a> to join.</p>'}
    <h3>Participants</h3>
    ${d.participants.map((x) => `<p>${esc(x.display_name)} · ${x.pledged_trees} pledged</p>`).join('') || '<p>No participants yet.</p>'}
  </div>`;
  root.querySelector('#join')?.addEventListener('click', async () => {
    const n = parseInt((((root.querySelector('#pledge') as HTMLIonInputElement).value as string) ?? '1'), 10) || 1;
    try {
      await api(`/api/v1/projects/${id}/join`, { method: 'POST', body: JSON.stringify({ pledged_trees: n }) });
      toast('Joined! Thank you 🌱');
      void renderProjectDetail(root, id);
    } catch (e) {
      toast(e instanceof Error ? e.message : 'Failed');
    }
  });
}

export function renderProjectNew(root: HTMLElement) {
  if (!getToken()) {
    window.location.hash = '#/login';
    return;
  }
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-title>New Project</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    <ion-item><ion-input label-placement="stacked" id="t" label="Title (e.g. 1,000 Native Trees for Watershed)"></ion-input></ion-item>
    <ion-item><ion-input label-placement="stacked" id="g" label="Goal (trees)" type="number" value="100"></ion-input></ion-item>
    <ion-item><ion-input label-placement="stacked" id="prov" label="Province"></ion-input></ion-item>
    <ion-item><ion-textarea label-placement="stacked" id="d" label="Description"></ion-textarea></ion-item>
    <p id="err" role="alert"></p>
    <button class="kp-btn block" id="go">Create project</button>
  </div>`;
  bindAsyncAction(root, '#go', async () => {
    const v = (s: string) => ((root.querySelector(s) as HTMLIonInputElement)?.value as string) ?? '';
    try {
      const created = await api<{ project: { id: string } }>('/api/v1/projects', {
        method: 'POST',
        body: JSON.stringify({
          title: v('#t'),
          goal_trees: parseInt(v('#g') || '100', 10),
          province: v('#prov') || undefined,
          description: ((root.querySelector('#d') as HTMLIonTextareaElement).value as string) ?? '',
        }),
      });
      window.location.hash = `#/project/${created.project.id}`;
    } catch (e) {
      (root.querySelector('#err') as HTMLElement).textContent = e instanceof Error ? e.message : 'Failed';
    }
  });
}

export async function renderOrganization(root: HTMLElement) {
  if (!getToken()) {
    window.location.hash = '#/login';
    return;
  }
  const mine = await api<{ organization: { name: string; org_type: string; status: string; province: string | null } | null }>(
    '/api/v1/organizations/mine').catch(() => ({ organization: null }));
  const pub = await api<{ organizations: { name: string; org_type: string; province: string | null }[] }>(
    '/api/v1/organizations').catch(() => ({ organizations: [] }));
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-title>Organizations</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    ${mine.organization
      ? `<p><b>${esc(mine.organization.name)}</b> (${esc(mine.organization.org_type)}) · <span class="kp-badge ${mine.organization.status === 'verified' ? 'verified' : 'pending'}">${esc(mine.organization.status)}</span></p>`
      : `<ion-item><ion-input label-placement="stacked" id="oname" label="Organization name"></ion-input></ion-item>
         <ion-item><ion-select label-placement="stacked" id="otype" label="Type"><ion-select-option value="school">School</ion-select-option><ion-select-option value="ngo">NGO</ion-select-option><ion-select-option value="lgu">LGU</ion-select-option><ion-select-option value="society">Native-tree society</ion-select-option><ion-select-option value="other">Other</ion-select-option></ion-select></ion-item>
         <ion-item><ion-input label-placement="stacked" id="oprov" label="Province"></ion-input></ion-item>
         <button class="kp-btn block" id="ogo">Register organization</button>`}
    <h3>Verified organizations</h3>
    ${pub.organizations.map((o) => `<p><b>${esc(o.name)}</b> (${esc(o.org_type)})${o.province ? ` · ${esc(o.province)}` : ''}</p>`).join('') || '<p>None yet.</p>'}
  </div>`;
  root.querySelector('#ogo')?.addEventListener('click', async () => {
    const v = (s: string) => ((root.querySelector(s) as HTMLIonInputElement)?.value as string) ?? '';
    try {
      await api('/api/v1/organizations', {
        method: 'POST',
        body: JSON.stringify({
          name: v('#oname'),
          org_type: ((root.querySelector('#otype') as HTMLIonSelectElement).value as string) || 'other',
          province: v('#oprov') || undefined,
        }),
      });
      toast('Organization submitted — pending verification');
      void renderOrganization(root);
    } catch (e) {
      toast(e instanceof Error ? e.message : 'Failed');
    }
  });
}

