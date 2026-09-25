import { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { assetUrl, logout } from '../api';

const icons: Record<string, JSX.Element> = {
  dashboard: <><rect x="3" y="3" width="7" height="7" /><rect x="14" y="3" width="7" height="7" /><rect x="3" y="14" width="7" height="7" /><rect x="14" y="14" width="7" height="7" /></>,
  species: <><path d="M12 21V9"/><path d="M12 13C5 14 4 9 5 5c5 0 7 3 7 8Zm0-4c0-5 4-7 8-6 0 4-3 7-8 6Z"/></>,
  moderation: <><path d="M12 3 4 6v6c0 5 3.5 8 8 9 4.5-1 8-4 8-9V6Z"/><path d="m8 12 3 3 5-6"/></>,
  reports: <><path d="M5 21V4h11l3 3v14Z"/><path d="M9 9h6m-6 4h6m-6 4h4"/></>,
  users: <><circle cx="9" cy="8" r="4"/><path d="M2 21v-2a7 7 0 0 1 14 0v2m1-12a4 4 0 0 1 0 7"/></>,
  projects: <><path d="M4 20h16M6 20v-8h12v8M9 12V7h6v5M8 7h8l-2-4h-4Z"/></>,
  audit: <><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></>,
  sprout: <><path d="M12 21V10M12 14C3 15 2 10 3 6c6 0 9 3 9 8Zm0-4c0-6 4-8 9-7 0 5-4 8-9 7Z"/></>,
  logout: <><path d="M10 17l5-5-5-5m5 5H3m12-9h5v18h-5"/></>,
};

function Icon({ name }: { name: string }) {
  return <svg className="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">{icons[name]}</svg>;
}

/** Dark-forest admin header with horizontal logo (style.md §43-44). */
/** Collapses to a hamburger menu on mobile. */
export default function AdminBar() {
  const loc = useLocation();
  const [open, setOpen] = useState(false);
  const cls = (to: string) => (to === '/' ? loc.pathname === '/' || loc.pathname.startsWith('/species') : loc.pathname === to) ? 'active' : '';
  return (
    <header className="kp-adminbar">
      <a className="skip-link" href="#main-content">Skip to content</a>
      <Link to="/dashboard" className="admin-brand" aria-label="Katutubong Puno admin dashboard">
        <img src={assetUrl('/logo-symbol-96.png')} width="44" height="44" alt="" />
        <span className="wordmark">Katutubong Puno <small>Administration</small></span>
      </Link>
      <button className="ghost menu-btn" aria-label={open ? 'Close menu' : 'Open menu'} aria-expanded={open} onClick={() => setOpen(!open)}>
        {open ? '✕' : '☰'}
      </button>
      <nav className={open ? 'open' : ''} onClick={() => setOpen(false)}>
        <p className="nav-label">Overview</p>
        <Link to="/dashboard" className={cls('/dashboard')} aria-current={cls('/dashboard') ? 'page' : undefined}><Icon name="dashboard" />Dashboard</Link>
        <p className="nav-label">Content</p>
        <Link to="/" className={cls('/')} aria-current={cls('/') ? 'page' : undefined}><Icon name="species" />Tree species</Link>
        <Link to="/projects" className={cls('/projects')} aria-current={cls('/projects') ? 'page' : undefined}><Icon name="projects" />Planting projects</Link>
        <p className="nav-label">Community</p>
        <Link to="/moderation" className={cls('/moderation')} aria-current={cls('/moderation') ? 'page' : undefined}><Icon name="moderation" />Moderation</Link>
        <Link to="/contributions" className={cls('/contributions')} aria-current={cls('/contributions') ? 'page' : undefined}><Icon name="sprout" />Contributions</Link>
        <Link to="/reports" className={cls('/reports')} aria-current={cls('/reports') ? 'page' : undefined}><Icon name="reports" />Reports</Link>
        <Link to="/users" className={cls('/users')} aria-current={cls('/users') ? 'page' : undefined}><Icon name="users" />Users</Link>
        <Link to="/audit-logs" className={cls('/audit-logs')} aria-current={cls('/audit-logs') ? 'page' : undefined}><Icon name="audit" />Audit log</Link>
        <button className="ghost nav-logout" onClick={logout}><Icon name="logout" />Log out</button>
      </nav>
      <div className="adminbar-footer"><span>Native-tree stewardship</span><button className="ghost logout-btn" onClick={logout}><Icon name="logout" />Log out</button></div>
    </header>
  );
}
