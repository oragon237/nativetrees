-- 005_community.sql — Phase 4: Community + Phase 6 foundations.
-- Covers code-database.md §§15-19 (observations, identifications),
-- §§21-22 (comments, corrections), §26 (notifications), §27 (moderation_actions).

-- ============ OBSERVATIONS ============
CREATE TABLE IF NOT EXISTS observations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  species_id UUID REFERENCES species(id) ON DELETE SET NULL,
  observation_date DATE NOT NULL DEFAULT CURRENT_DATE,
  region VARCHAR(120),
  province VARCHAR(120),
  municipality VARCHAR(120),
  latitude DECIMAL(9,6),
  longitude DECIMAL(9,6),
  location_precision VARCHAR(20) NOT NULL DEFAULT 'municipality'
    CHECK (location_precision IN ('hidden', 'municipality', 'approximate', 'exact_private')),
  habitat VARCHAR(255),
  estimated_height_m DECIMAL(6,2),
  flowering BOOLEAN,
  fruiting BOOLEAN,
  notes TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('draft', 'pending', 'approved', 'needs_information', 'rejected')),
  reviewed_by UUID REFERENCES users(id) ON DELETE SET NULL,
  reviewed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_observations_status ON observations (status);
CREATE INDEX IF NOT EXISTS idx_observations_user ON observations (user_id);
CREATE INDEX IF NOT EXISTS idx_observations_species ON observations (species_id);

DROP TRIGGER IF EXISTS trg_observations_touch ON observations;
CREATE TRIGGER trg_observations_touch
  BEFORE UPDATE ON observations
  FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

CREATE TABLE IF NOT EXISTS observation_photos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  observation_id UUID NOT NULL REFERENCES observations(id) ON DELETE CASCADE,
  file_url TEXT NOT NULL,
  photo_type VARCHAR(20) NOT NULL DEFAULT 'whole_tree' CHECK (photo_type IN
    ('whole_tree', 'leaf', 'bark', 'flower', 'fruit', 'seed', 'seedling')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_obs_photos_obs ON observation_photos (observation_id);

-- ============ IDENTIFICATION REQUESTS ============
CREATE TABLE IF NOT EXISTS identification_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  description TEXT,
  habitat VARCHAR(255),
  region VARCHAR(120),
  province VARCHAR(120),
  municipality VARCHAR(120),
  latitude DECIMAL(9,6),
  longitude DECIMAL(9,6),
  location_precision VARCHAR(20) NOT NULL DEFAULT 'municipality'
    CHECK (location_precision IN ('hidden', 'municipality', 'approximate', 'exact_private')),
  estimated_height_m DECIMAL(6,2),
  flowering BOOLEAN,
  fruiting BOOLEAN,
  status VARCHAR(30) NOT NULL DEFAULT 'open'
    CHECK (status IN ('open', 'possible_identification', 'moderator_review', 'verified', 'unresolved')),
  verified_species_id UUID REFERENCES species(id) ON DELETE SET NULL,
  verified_by UUID REFERENCES users(id) ON DELETE SET NULL,
  verified_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_ident_status ON identification_requests (status);
CREATE INDEX IF NOT EXISTS idx_ident_user ON identification_requests (user_id);

DROP TRIGGER IF EXISTS trg_ident_touch ON identification_requests;
CREATE TRIGGER trg_ident_touch
  BEFORE UPDATE ON identification_requests
  FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

CREATE TABLE IF NOT EXISTS identification_photos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id UUID NOT NULL REFERENCES identification_requests(id) ON DELETE CASCADE,
  file_url TEXT NOT NULL,
  photo_type VARCHAR(20) NOT NULL DEFAULT 'whole_tree' CHECK (photo_type IN
    ('whole_tree', 'leaf', 'bark', 'flower', 'fruit', 'seed', 'seedling')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_ident_photos_req ON identification_photos (request_id);

CREATE TABLE IF NOT EXISTS identification_suggestions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id UUID NOT NULL REFERENCES identification_requests(id) ON DELETE CASCADE,
  suggested_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  species_id UUID NOT NULL REFERENCES species(id) ON DELETE CASCADE,
  reasoning TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_ident_sugg_req ON identification_suggestions (request_id);

-- ============ COMMENTS ============
CREATE TABLE IF NOT EXISTS comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  entity_type VARCHAR(40) NOT NULL CHECK (entity_type IN ('identification_request', 'observation')),
  entity_id UUID NOT NULL,
  parent_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'visible'
    CHECK (status IN ('visible', 'hidden', 'removed')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_comments_entity ON comments (entity_type, entity_id);

DROP TRIGGER IF EXISTS trg_comments_touch ON comments;
CREATE TRIGGER trg_comments_touch
  BEFORE UPDATE ON comments
  FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

-- ============ CORRECTION REQUESTS ============
CREATE TABLE IF NOT EXISTS correction_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  species_id UUID NOT NULL REFERENCES species(id) ON DELETE CASCADE,
  submitted_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  field_name VARCHAR(100) NOT NULL,
  current_value TEXT,
  proposed_value TEXT NOT NULL,
  explanation TEXT NOT NULL,
  source_url TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'approved', 'rejected')),
  reviewed_by UUID REFERENCES users(id) ON DELETE SET NULL,
  reviewed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_corrections_status ON correction_requests (status);
CREATE INDEX IF NOT EXISTS idx_corrections_species ON correction_requests (species_id);

-- ============ MODERATION ACTIONS (auditable moderator history) ============
CREATE TABLE IF NOT EXISTS moderation_actions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  moderator_id UUID REFERENCES users(id) ON DELETE SET NULL,
  entity_type VARCHAR(60) NOT NULL,
  entity_id UUID,
  action VARCHAR(60) NOT NULL,
  reason TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_mod_entity ON moderation_actions (entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_mod_moderator ON moderation_actions (moderator_id);

-- ============ NOTIFICATIONS (in-app; push is a future integration) ============
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type VARCHAR(60) NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  entity_type VARCHAR(60),
  entity_id UUID,
  read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_notif_user ON notifications (user_id, created_at DESC);
