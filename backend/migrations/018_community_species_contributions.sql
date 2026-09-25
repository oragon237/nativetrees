-- 018_community_species_contributions.sql — Community Species & Photo Contributions.
-- New user submissions MUST be reviewed before entering the official database.
-- Nothing here modifies existing species, photos, or moderation records.

-- ============ SPECIES CONTRIBUTIONS (proposed new species) ============
CREATE TABLE IF NOT EXISTS species_contributions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  submitted_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  proposed_scientific_name VARCHAR(255),
  proposed_common_name VARCHAR(255) NOT NULL,
  description TEXT NOT NULL DEFAULT '',
  location_text VARCHAR(255),
  latitude DECIMAL(9,6),
  longitude DECIMAL(9,6),
  location_precision VARCHAR(20) NOT NULL DEFAULT 'municipality'
    CHECK (location_precision IN ('hidden', 'municipality', 'approximate', 'exact_private')),
  observed_at DATE,
  source_reference TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'under_review', 'needs_more_info', 'approved', 'rejected')),
  review_notes TEXT,
  reviewed_by UUID REFERENCES users(id) ON DELETE SET NULL,
  reviewed_at TIMESTAMPTZ,
  published_species_id UUID REFERENCES species(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_sc_status ON species_contributions (status);
CREATE INDEX IF NOT EXISTS idx_sc_submitter ON species_contributions (submitted_by);
CREATE INDEX IF NOT EXISTS idx_sc_created ON species_contributions (created_at DESC);

DROP TRIGGER IF EXISTS trg_sc_touch ON species_contributions;
CREATE TRIGGER trg_sc_touch
  BEFORE UPDATE ON species_contributions
  FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

CREATE TABLE IF NOT EXISTS species_contribution_photos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contribution_id UUID NOT NULL REFERENCES species_contributions(id) ON DELETE CASCADE,
  file_url TEXT NOT NULL,
  photo_type VARCHAR(20) NOT NULL DEFAULT 'whole_tree' CHECK (photo_type IN
    ('whole_tree', 'leaf', 'bark', 'flower', 'fruit', 'seed', 'seedling', 'other')),
  caption TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_scp_contribution ON species_contribution_photos (contribution_id);

-- ============ PHOTO CONTRIBUTIONS (photos for existing species) ============
CREATE TABLE IF NOT EXISTS photo_contributions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  species_id UUID NOT NULL REFERENCES species(id) ON DELETE CASCADE,
  submitted_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  file_url TEXT NOT NULL,
  photo_type VARCHAR(20) NOT NULL DEFAULT 'whole_tree' CHECK (photo_type IN
    ('whole_tree', 'leaf', 'bark', 'flower', 'fruit', 'seed', 'seedling', 'other')),
  location_text VARCHAR(255),
  latitude DECIMAL(9,6),
  longitude DECIMAL(9,6),
  location_precision VARCHAR(20) NOT NULL DEFAULT 'municipality'
    CHECK (location_precision IN ('hidden', 'municipality', 'approximate', 'exact_private')),
  photographed_at DATE,
  caption TEXT,
  credit_name VARCHAR(120),
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'under_review', 'needs_more_info', 'approved', 'rejected')),
  review_notes TEXT,
  reviewed_by UUID REFERENCES users(id) ON DELETE SET NULL,
  reviewed_at TIMESTAMPTZ,
  published_photo_id UUID REFERENCES species_photos(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_pc_status ON photo_contributions (status);
CREATE INDEX IF NOT EXISTS idx_pc_submitter ON photo_contributions (submitted_by);
CREATE INDEX IF NOT EXISTS idx_pc_species ON photo_contributions (species_id);
CREATE INDEX IF NOT EXISTS idx_pc_created ON photo_contributions (created_at DESC);

DROP TRIGGER IF EXISTS trg_pc_touch ON photo_contributions;
CREATE TRIGGER trg_pc_touch
  BEFORE UPDATE ON photo_contributions
  FOR EACH ROW EXECUTE FUNCTION touch_updated_at();
