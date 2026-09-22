-- 010_v2.sql — V2: nursery verification, reputation/badges, availability alerts, devices.

CREATE TABLE IF NOT EXISTS nursery_verifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  business_name VARCHAR(255) NOT NULL,
  province VARCHAR(120),
  notes TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'verified', 'rejected')),
  reviewed_by UUID REFERENCES users(id) ON DELETE SET NULL,
  reviewed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug VARCHAR(80) UNIQUE NOT NULL,
  name VARCHAR(120) NOT NULL,
  description TEXT NOT NULL DEFAULT '',
  icon VARCHAR(20) NOT NULL DEFAULT '🌳'
);

INSERT INTO badges (slug, name, description, icon) VALUES
  ('first-observation', 'Native Tree Explorer', 'Submitted a first tree observation.', '🌱'),
  ('seasoned-observer', 'Field Documenter', 'Five approved tree observations.', '📷'),
  ('tree-identifier', 'Tree Identifier', 'Suggested three species identifications.', '🔍'),
  ('seed-sharer', 'Propagation Partner', 'First marketplace listing approved.', '🛒'),
  ('knowledge-keeper', 'Knowledge Keeper', 'A suggested correction was approved.', '📚')
ON CONFLICT (slug) DO NOTHING;

CREATE TABLE IF NOT EXISTS user_badges (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  badge_id UUID NOT NULL REFERENCES badges(id) ON DELETE CASCADE,
  awarded_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, badge_id)
);

CREATE TABLE IF NOT EXISTS availability_alerts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  species_id UUID NOT NULL REFERENCES species(id) ON DELETE CASCADE,
  province VARCHAR(120) NOT NULL DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, species_id, province)
);

CREATE TABLE IF NOT EXISTS device_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  platform VARCHAR(20) NOT NULL DEFAULT 'web' CHECK (platform IN ('web', 'android', 'ios')),
  token VARCHAR(512) UNIQUE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_device_user ON device_tokens (user_id);
