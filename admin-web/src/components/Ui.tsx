import type { ReactNode } from 'react';

/** Shared admin components in the Astra visual language. */

export function Eyebrow({ children }: { children: ReactNode }) {
  return <p className="eyebrow">{children}</p>;
}

export function PageHeader({ eyebrow, title, intro }: { eyebrow: string; title: string; intro?: string }) {
  return (
    <div className="page-header">
      <Eyebrow>{eyebrow}</Eyebrow>
      <h1>{title}</h1>
      {intro && <p className="page-intro">{intro}</p>}
    </div>
  );
}

export function SecHead({ title, action }: { title: string; action?: ReactNode }) {
  return (
    <div className="sec-head">
      <h2>{title}</h2>
      {action}
    </div>
  );
}

export function StatGrid({ children }: { children: ReactNode }) {
  return <div className="stat-grid">{children}</div>;
}

export function StatCard({ kicker, value, sub }: { kicker: string; value: string; sub?: string }) {
  return (
    <div className="stat-card">
      <p className="kicker">{kicker}</p>
      <p className="bignum">{value}</p>
      {sub && <p className="sub">{sub}</p>}
    </div>
  );
}

export function EmptyState({ symbol, title, description, action }: {
  symbol: string;
  title: string;
  description: string;
  action?: { label: string; href: string };
}) {
  return (
    <div className="kp-empty" role="status">
      <span className="state-icon" aria-hidden="true">{symbol}</span>
      <h3>{title}</h3>
      <p>{description}</p>
      {action && <a className="kp-btn outline" href={action.href} style={{ display: 'inline-block', textDecoration: 'none', padding: '10px 18px' }}>{action.label}</a>}
    </div>
  );
}

export function LoadingState({ label = 'Loading…' }: { label?: string }) {
  return (
    <div role="status" aria-live="polite">
      <div className="loading-state"><span className="spinner" aria-hidden="true" /><span>{label}</span></div>
      <div className="skeleton" aria-hidden="true" />
    </div>
  );
}

export function StatusBadge({ value }: { value: string }) {
  return <span className={`badge ${value}`}>{value.replace(/_/g, ' ')}</span>;
}

export function ErrorState({ message, onRetry }: { message: string; onRetry?: () => void }) {
  return (
    <div className="alert error" role="alert">
      <div><strong>Something needs attention</strong><span>{message}</span></div>
      {onRetry && <button className="secondary" onClick={onRetry}>Try again</button>}
    </div>
  );
}

export function Toolbar({ children }: { children: ReactNode }) {
  return <div className="toolbar">{children}</div>;
}
