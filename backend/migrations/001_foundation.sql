-- 001_foundation.sql — Phase 1: Identity & Access + Audit
-- Per code-database.md §3-5 (users, roles, user_roles) and §28 (audit_logs).
-- Principles: UUID PKs, created_at/updated_at, soft delete, no names as FKs.

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Roles (smallint PK per spec)
CREATE TABLE IF NOT EXISTS roles (
  id SMALLSERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL,
  description TEXT NOT NULL DEFAULT ''
);
INSERT INTO roles (name, description) VALUES
  ('user', 'Registered user'),
  ('moderator', 'Community moderator with review permissions'),
  ('admin', 'Full system administrator')
ON CONFLICT (name) DO NOTHING;

-- Users
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(320) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  display_name VARCHAR(120) NOT NULL,
  profile_photo_url TEXT NOT NULL DEFAULT '',
  bio TEXT,
  region VARCHAR(120),
  province VARCHAR(120),
  municipality VARCHAR(120),
  email_verified_at TIMESTAMPTZ,
  account_status VARCHAR(20) NOT NULL DEFAULT 'active'
    CHECK (account_status IN ('active', 'suspended', 'banned')),
  last_login_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_users_email ON users (email);
CREATE INDEX IF NOT EXISTS idx_users_status ON users (account_status);
CREATE INDEX IF NOT EXISTS idx_users_province ON users (province);

-- User <-> roles (allows future roles without redesigning users)
CREATE TABLE IF NOT EXISTS user_roles (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role_id SMALLINT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
  assigned_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, role_id)
);

-- Auth tokens: email verification + password reset (hash stored, never raw)
CREATE TABLE IF NOT EXISTS auth_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type VARCHAR(30) NOT NULL CHECK (type IN ('email_verify', 'password_reset')),
  token_hash VARCHAR(255) UNIQUE NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_auth_tokens_user ON auth_tokens (user_id);

-- Audit logs for important admin/moderator actions
CREATE TABLE IF NOT EXISTS audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  action VARCHAR(100) NOT NULL,
  entity_type VARCHAR(100) NOT NULL,
  entity_id UUID,
  old_values JSONB,
  new_values JSONB,
  ip_address VARCHAR(64),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_audit_entity ON audit_logs (entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_audit_user ON audit_logs (user_id);
CREATE INDEX IF NOT EXISTS idx_audit_created ON audit_logs (created_at DESC);

-- updated_at auto-touch for users
CREATE OR REPLACE FUNCTION touch_updated_at() RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_users_touch ON users;
CREATE TRIGGER trg_users_touch
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
