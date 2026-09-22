import { api, getToken, setToken, esc } from '../api';
import { bindAsyncAction, toast, icon, pageHeader } from './ui';
import { loadDrafts, syncDrafts } from './offline';

export function renderLogin(root: HTMLElement) {
  root.innerHTML = `
  ${pageHeader('Welcome back', '#/home')}
  <div class="pad auth-page">
    <img class="kp-logo" src="/logo-symbol.png" alt="Katutubong Puno logo" />
    <p class="kp-tagline brand-serif">Discover. Identify. Plant Native.</p>
    <h1>Welcome back.</h1><p class="page-intro">Your next native tree discovery is waiting.</p>
    <ion-item><ion-input label-placement="stacked" id="email" label="Email" type="email" autocomplete="email" inputmode="email"></ion-input></ion-item>
    <ion-item><ion-input label-placement="stacked" id="pass" label="Password" type="password" autocomplete="current-password"><ion-input-password-toggle slot="end"></ion-input-password-toggle></ion-input></ion-item>
    <p id="err" role="alert"></p>
    <button class="kp-btn block" id="go">Log in</button>
    <p>No account? <a href="#/register">Create one</a></p>
    <a class="kp-btn clear block" href="#/home">Continue exploring as a guest</a>
  </div>`;
  bindAsyncAction(root, '#go', async () => {
    const email = (root.querySelector('#email') as HTMLIonInputElement).value as string;
    const password = (root.querySelector('#pass') as HTMLIonInputElement).value as string;
    try {
      const data = await api<{ token: string }>('/api/v1/auth/login', {
        method: 'POST',
        body: JSON.stringify({ email: email.trim(), password }),
      });
      setToken(data.token);
      window.location.hash = '#/me';
    } catch (e) {
      (root.querySelector('#err') as HTMLElement).textContent = e instanceof Error ? e.message : 'Login failed';
    }
  });
}

export function renderRegister(root: HTMLElement) {
  root.innerHTML = `
  ${pageHeader('Join the community', '#/login')}
  <div class="pad auth-page">
    <img class="kp-logo" src="/logo-symbol.png" alt="Katutubong Puno logo" />
    <p class="kp-tagline brand-serif">Discover. Identify. Plant Native.</p>
    <h1>Grow with us.</h1><p class="page-intro">Save your favorite trees and share your discoveries.</p>
    <ion-item><ion-input label-placement="stacked" id="name" label="Display name"></ion-input></ion-item>
    <ion-item><ion-input label-placement="stacked" id="email" label="Email" type="email"></ion-input></ion-item>
    <ion-item><ion-input label-placement="stacked" id="pass" label="Password (8+ chars)" type="password"></ion-input></ion-item>
    <ion-item><ion-input label-placement="stacked" id="prov" label="Province (optional)"></ion-input></ion-item>
    <p id="err" role="alert"></p>
    <button class="kp-btn block" id="go">Create account</button>
    <p>Have an account? <a href="#/login">Log in</a></p>
  </div>`;
  bindAsyncAction(root, '#go', async () => {
    const val = (sel: string) => (root.querySelector(sel) as HTMLIonInputElement).value as string;
    try {
      const data = await api<{ emailVerificationToken?: string }>('/api/v1/auth/register', {
        method: 'POST',
        body: JSON.stringify({
          display_name: val('#name').trim(),
          email: val('#email').trim(),
          password: val('#pass'),
          province: val('#prov').trim() || undefined,
        }),
      });
      if (data.emailVerificationToken) {
        await api('/api/v1/auth/verify-email', {
          method: 'POST',
          body: JSON.stringify({ token: data.emailVerificationToken }),
        });
      }
      const login = await api<{ token: string }>('/api/v1/auth/login', {
        method: 'POST',
        body: JSON.stringify({ email: val('#email').trim(), password: val('#pass') }),
      });
      setToken(login.token);
      toast('Welcome to Katutubong Puno! 🌳');
      window.location.hash = '#/me';
    } catch (e) {
      (root.querySelector('#err') as HTMLElement).textContent = e instanceof Error ? e.message : 'Failed';
    }
  });
}

export async function renderMe(root: HTMLElement) {
  if (!getToken()) {
    window.location.hash = '#/login';
    return;
  }
  try {
    const me = await api<{ user: { display_name: string; email: string; province: string | null; roles: string[] } }>('/api/v1/auth/me');
    const favs = await api<{ favorites: unknown[] }>('/api/v1/favorites');
    const stats = await api<{ stats: { observations: number; identification_requests: number; listings: number; saved_trees: number } }>('/api/v1/users/me/stats').catch(
      () => ({ stats: { observations: 0, identification_requests: 0, listings: 0, saved_trees: favs.favorites.length } }));
    const rep = await api<{ score: number; badges: { slug: string; name: string; icon: string }[] }>('/api/v1/users/me/reputation').catch(() => ({ score: 0, badges: [] }));
    const nursery = await api<{ verification: { status: string; business_name: string } | null }>('/api/v1/nurseries/mine').catch(() => ({ verification: null }));
    const drafts = loadDrafts();
    root.innerHTML = `
    <ion-header><ion-toolbar><ion-title>My Profile</ion-title></ion-toolbar></ion-header>
    <div class="pad">
      <p class="eyebrow">Your growing contribution</p><h1>${esc(me.user.display_name)}</h1>
      <p>${esc(me.user.email)}${me.user.province ? `<br/>${esc(me.user.province)}` : ''}</p>
      <div class="profile-stats"><div><strong>${stats.stats.observations}</strong><span>Observations</span></div><div><strong>${stats.stats.identification_requests}</strong><span>ID requests</span></div><div><strong>${stats.stats.saved_trees}</strong><span>Saved trees</span></div><div><strong>${stats.stats.listings}</strong><span>Listings</span></div></div>
      <p>⭐ Reputation: <b>${rep.score}</b></p>
      <div class="chips">${rep.badges.map((b) => `<ion-chip>${b.icon} ${esc(b.name)}</ion-chip>`).join('') || '<small>No badges yet — contribute to earn them.</small>'}</div>
      ${drafts.length ? `<ion-card color="warning"><ion-card-content>📴 ${drafts.length} offline draft(s) waiting <button id="syncBtn">Sync now</button><br/><small>Photos must be re-added after sync.</small></ion-card-content></ion-card>` : ''}
      <h2>My field guide</h2><div class="action-list">
        <a href="#/favorites">${icon('heart')}<span><strong>Saved trees</strong></span>${icon('arrow')}</a>
        <a href="#/observations">${icon('leaf')}<span><strong>My observations</strong></span>${icon('arrow')}</a>
        <a href="#/identify">${icon('camera')}<span><strong>Identification requests</strong></span>${icon('arrow')}</a>
        <a href="#/plantings">${icon('sprout')}<span><strong>My plantings</strong></span>${icon('arrow')}</a>
        <a href="#/notifications">${icon('info')}<span><strong>Notifications</strong></span>${icon('arrow')}</a>
      </div>
      <h2>Grow together</h2><div class="action-list">
        <a href="#/projects">${icon('tree')}<span><strong>Planting projects</strong></span>${icon('arrow')}</a>
        <a href="#/organization">${icon('user')}<span><strong>Organization</strong></span>${icon('arrow')}</a>
        <a href="#/market">${icon('sprout')}<span><strong>Find native seedlings</strong></span>${icon('arrow')}</a>
        <a href="#/market/mine">${icon('leaf')}<span><strong>My listings</strong></span>${icon('arrow')}</a>
      </div>
      ${(me.user.roles.includes('moderator') || me.user.roles.includes('admin')) ? '<button class="kp-btn block outline" data-href="#/moderation">Moderation</button>' : ''}
      <h3>Nursery verification</h3>
      ${nursery.verification
        ? `<p>Status: <span class="kp-badge ${nursery.verification.status === 'verified' ? 'verified' : 'pending'}">${esc(nursery.verification.status)}</span> · ${esc(nursery.verification.business_name)}</p>`
        : `<ion-item><ion-input label-placement="stacked" id="biz" label="Nursery / business name"></ion-input></ion-item>
           <button class="kp-btn small" id="nursBtn">Request verification</button>`}
      <button class="kp-btn block clear" id="out">Log out</button>
    </div>`;
    root.querySelector('#syncBtn')?.addEventListener('click', async () => {
      await syncDrafts();
      void renderMe(root);
    });
    root.querySelector('#nursBtn')?.addEventListener('click', async () => {
      const name = ((root.querySelector('#biz') as HTMLIonInputElement).value as string) ?? '';
      if (!name.trim()) {
        toast('Enter your nursery name');
        return;
      }
      try {
        await api('/api/v1/nurseries/verify-request', { method: 'POST', body: JSON.stringify({ business_name: name.trim() }) });
        toast('Verification requested — pending review');
        void renderMe(root);
      } catch (e) {
        toast(e instanceof Error ? e.message : 'Failed');
      }
    });
    root.querySelector('#out')?.addEventListener('click', () => {
      setToken(null);
      window.location.hash = '#/home';
    });
  } catch {
    setToken(null);
    window.location.hash = '#/login';
  }
}

