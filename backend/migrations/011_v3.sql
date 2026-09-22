-- 011_v3.sql — V3: planting tracker, community projects, organizations.

CREATE TABLE IF NOT EXISTS planted_trees (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  species_id UUID NOT NULL REFERENCES species(id) ON DELETE CASCADE,
  planted_date DATE NOT NULL DEFAULT CURRENT_DATE,
  region VARCHAR(120),
  province VARCHAR(120),
  municipality VARCHAR(120),
  latitude DECIMAL(9,6),
  longitude DECIMAL(9,6),
  location_precision VARCHAR(20) NOT NULL DEFAULT 'municipality'
    CHECK (location_precision IN ('hidden', 'municipality', 'approximate', 'exact_private')),
  notes TEXT,
  public_token VARCHAR(64) UNIQUE NOT NULL DEFAULT substr(md5(gen_random_uuid()::text || now()::text), 1, 16),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_planted_user ON planted_trees (user_id);

DROP TRIGGER IF EXISTS trg_planted_touch ON planted_trees;
CREATE TRIGGER trg_planted_touch
  BEFORE UPDATE ON planted_trees
  FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

CREATE TABLE IF NOT EXISTS growth_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  planted_tree_id UUID NOT NULL REFERENCES planted_trees(id) ON DELETE CASCADE,
  recorded_at DATE NOT NULL DEFAULT CURRENT_DATE,
  height_m DECIMAL(6,2),
  notes TEXT,
  file_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_growth_tree ON growth_records (planted_tree_id);

CREATE TABLE IF NOT EXISTS projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL DEFAULT '',
  goal_trees INTEGER NOT NULL DEFAULT 100 CHECK (goal_trees > 0),
  region VARCHAR(120),
  province VARCHAR(120),
  start_date DATE,
  end_date DATE,
  status VARCHAR(20) NOT NULL DEFAULT 'active'
    CHECK (status IN ('draft', 'active', 'completed', 'cancelled')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_projects_status ON projects (status);

DROP TRIGGER IF EXISTS trg_projects_touch ON projects;
CREATE TRIGGER trg_projects_touch
  BEFORE UPDATE ON projects
  FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

CREATE TABLE IF NOT EXISTS project_participants (
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  pledged_trees INTEGER NOT NULL DEFAULT 1 CHECK (pledged_trees > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (project_id, user_id)
);

CREATE TABLE IF NOT EXISTS organization_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  org_type VARCHAR(20) NOT NULL DEFAULT 'other'
    CHECK (org_type IN ('school', 'ngo', 'lgu', 'society', 'other')),
  province VARCHAR(120),
  description TEXT NOT NULL DEFAULT '',
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'verified', 'rejected')),
  reviewed_by UUID REFERENCES users(id) ON DELETE SET NULL,
  reviewed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
