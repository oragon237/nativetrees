import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { assetUrl, login } from '../api';

export default function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [busy, setBusy] = useState(false);
  const nav = useNavigate();

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    setBusy(true);
    try {
      await login(email.trim(), password);
      nav('/');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Login failed');
    } finally {
      setBusy(false);
    }
  }

  return (
    <main className="login-page">
      <section className="login-story" aria-label="Katutubong Puno mission">
        <div className="login-story-content">
          <img src={assetUrl('/logo-symbol-96.png')} alt="" />
          <p className="eyebrow">Katutubong Puno administration</p>
          <h1>Steward the record.<br />Protect what grows.</h1>
          <p>Curate trusted knowledge, support the community, and help native trees find the places where they belong.</p>
          <div className="trust-points"><span>Verified knowledge</span><span>Responsible moderation</span><span>Auditable actions</span></div>
        </div>
      </section>
      <section className="login-panel">
        <div className="login-card">
          <img className="kp-login-logo" src={assetUrl('/logo-symbol.png')} alt="Katutubong Puno logo" />
          <p className="kp-login-sub">ADMINISTRATION PORTAL</p>
          <h2>Welcome back</h2>
          <p className="page-intro">Sign in with your authorized administrator account.</p>
          <form onSubmit={submit}>
            <label><span>Email address</span><input autoComplete="email" inputMode="email" type="email" value={email} onChange={(e) => setEmail(e.target.value)} required /></label>
            <label><span>Password</span><input autoComplete="current-password" type="password" value={password} onChange={(e) => setPassword(e.target.value)} required /></label>
            {error && <p className="alert error" role="alert">{error}</p>}
            <button className="login-button" type="submit" disabled={busy}>{busy ? 'Signing in…' : 'Sign in securely'}</button>
          </form>
          <p className="login-help">Access is limited to authorized curators and moderators.</p>
        </div>
      </section>
    </main>
  );
}
