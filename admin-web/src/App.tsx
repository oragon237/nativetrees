import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';
import Login from './pages/Login';import SpeciesList from './pages/SpeciesList';
import SpeciesEditor from './pages/SpeciesEditor';
import Moderation from './pages/Moderation';
import Reports from './pages/Reports';
import Dashboard from './pages/Dashboard';
import Users from './pages/Users';
import AuditLogs from './pages/AuditLogs';
import Projects from './pages/Projects';
import Contributions from './pages/Contributions';
import { isLoggedIn } from './api';

function Guard({ children }: { children: JSX.Element }) {
  return isLoggedIn() ? children : <Navigate to="/login" replace />;
}

export default function App() {
  return (
    <BrowserRouter basename={import.meta.env.VITE_BASE_PATH || undefined}>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/" element={<Guard><SpeciesList /></Guard>} />
        <Route path="/species/:id" element={<Guard><SpeciesEditor /></Guard>} />
        <Route path="/moderation" element={<Guard><Moderation /></Guard>} />
        <Route path="/contributions" element={<Guard><Contributions /></Guard>} />
        <Route path="/reports" element={<Guard><Reports /></Guard>} />
        <Route path="/users" element={<Guard><Users /></Guard>} />
        <Route path="/audit-logs" element={<Guard><AuditLogs /></Guard>} />
        <Route path="/projects" element={<Guard><Projects /></Guard>} />
        <Route path="/dashboard" element={<Guard><Dashboard /></Guard>} />
      </Routes>
    </BrowserRouter>
  );
}
