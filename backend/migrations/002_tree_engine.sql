-- 002_tree_engine.sql — Phase 2: Tree Knowledge Engine
-- Per code-database.md §§6-14. Idempotent (IF NOT EXISTS / ON CONFLICT).

-- ============ SPECIES (master verified tree record) ============
CREATE TABLE IF NOT EXISTS species (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  scientific_name VARCHAR(255) UNIQUE NOT NULL,
  genus VARCHAR(120) NOT NULL,
  species_epithet VARCHAR(120) NOT NULL,
  family VARCHAR(120) NOT NULL,
  native_status VARCHAR(20) NOT NULL CHECK (native_status IN ('native', 'endemic')),
  description TEXT NOT NULL DEFAULT '',
  leaf_description TEXT,
  bark_description TEXT,
  flower_description TEXT,
  fruit_description TEXT,
  seed_description TEXT,
  growth_form VARCHAR(20) CHECK (growth_form IN ('small', 'medium', 'large')),
  min_height_m DECIMAL(6,2),
  max_height_m DECIMAL(6,2),
  min_canopy_m DECIMAL(6,2),
  max_canopy_m DECIMAL(6,2),
  growth_rate VARCHAR(20) CHECK (growth_rate IN ('slow', 'moderate', 'fast')),
  fruit_bearing BOOLEAN NOT NULL DEFAULT FALSE,
  flowering BOOLEAN NOT NULL DEFAULT FALSE,
  conservation_status VARCHAR(120),
  conservation_source VARCHAR(255),
  verification_status VARCHAR(20) NOT NULL DEFAULT 'draft'
    CHECK (verification_status IN ('draft', 'verified', 'archived')),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  verified_by UUID REFERENCES users(id) ON DELETE SET NULL,
  verified_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_species_scientific ON species (scientific_name);
CREATE INDEX IF NOT EXISTS idx_species_status ON species (verification_status);
CREATE INDEX IF NOT EXISTS idx_species_genus ON species (genus);
CREATE INDEX IF NOT EXISTS idx_species_growth_form ON species (growth_form);

DROP TRIGGER IF EXISTS trg_species_touch ON species;
CREATE TRIGGER trg_species_touch
  BEFORE UPDATE ON species
  FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

-- ============ SPECIES NAMES ============
CREATE TABLE IF NOT EXISTS species_names (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  species_id UUID NOT NULL REFERENCES species(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  name_type VARCHAR(20) NOT NULL CHECK (name_type IN ('common', 'local', 'alternative')),
  language VARCHAR(60),
  locality VARCHAR(120),
  is_primary BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_species_names_species ON species_names (species_id);
CREATE INDEX IF NOT EXISTS idx_species_names_name ON species_names (name);
-- One primary common name per species.
CREATE UNIQUE INDEX IF NOT EXISTS uq_species_primary_common
  ON species_names (species_id) WHERE is_primary AND name_type = 'common';

-- ============ SPECIES PHOTOS (metadata; files in object storage) ============
CREATE TABLE IF NOT EXISTS species_photos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  species_id UUID NOT NULL REFERENCES species(id) ON DELETE CASCADE,
  uploaded_by UUID REFERENCES users(id) ON DELETE SET NULL,
  file_url TEXT NOT NULL,
  thumbnail_url TEXT,
  photo_type VARCHAR(20) NOT NULL CHECK (photo_type IN
    ('whole_tree', 'leaf', 'bark', 'flower', 'fruit', 'seed', 'seedling')),
  caption TEXT,
  verification_status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (verification_status IN ('pending', 'verified', 'rejected')),
  verified_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_species_photos_species ON species_photos (species_id);

-- ============ PURPOSES ============
CREATE TABLE IF NOT EXISTS purposes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(120) UNIQUE NOT NULL,
  slug VARCHAR(120) UNIQUE NOT NULL,
  description TEXT NOT NULL DEFAULT '',
  icon VARCHAR(60),
  sort_order INTEGER NOT NULL DEFAULT 0,
  active BOOLEAN NOT NULL DEFAULT TRUE
);

INSERT INTO purposes (name, slug, description, sort_order) VALUES
  ('Shade', 'shade', 'Suitable for providing shade where the mature size and planting environment are appropriate.', 1),
  ('Fruit-Bearing', 'fruit-bearing', 'Produces edible or otherwise traditionally useful fruit where properly documented.', 2),
  ('Flowering / Ornamental', 'flowering-ornamental', 'Notable for flowers, foliage, form, or landscape value.', 3),
  ('Wildlife Support', 'wildlife-support', 'Provides documented food, shelter, nesting habitat, or other ecological value.', 4),
  ('Pollinator Support', 'pollinator-support', 'Provides documented resources for pollinators.', 5),
  ('Reforestation', 'reforestation', 'Potentially useful for appropriate native-forest restoration projects.', 6),
  ('Soil Erosion Control', 'soil-erosion-control', 'Species with characteristics documented as useful in suitable erosion-management applications.', 7),
  ('Slope Rehabilitation', 'slope-rehabilitation', 'Species potentially useful as part of appropriate slope revegetation or rehabilitation programs. Does not imply landslide prevention.', 8),
  ('Watershed Rehabilitation', 'watershed-rehabilitation', 'Species appropriate for documented watershed-restoration contexts.', 9),
  ('Riverbank / Riparian Rehabilitation', 'riverbank-riparian-rehabilitation', 'Species suited to appropriate riparian environments.', 10),
  ('Coastal Rehabilitation', 'coastal-rehabilitation', 'Native species suitable for appropriate coastal conditions.', 11),
  ('Windbreak', 'windbreak', 'Trees potentially useful as part of windbreak planting.', 12),
  ('Agroforestry', 'agroforestry', 'Species with documented agroforestry applications.', 13),
  ('Urban Landscaping', 'urban-landscaping', 'Native trees potentially suitable for managed urban environments.', 14),
  ('Carbon Storage', 'carbon-storage', 'Large or long-lived native trees may have carbon-storage value where supported by appropriate information.', 15)
ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description,
  sort_order = EXCLUDED.sort_order;

-- ============ SPECIES PURPOSES ============
CREATE TABLE IF NOT EXISTS species_purposes (
  species_id UUID NOT NULL REFERENCES species(id) ON DELETE CASCADE,
  purpose_id UUID NOT NULL REFERENCES purposes(id) ON DELETE CASCADE,
  suitability VARCHAR(20) NOT NULL DEFAULT 'suitable'
    CHECK (suitability IN ('possible', 'suitable', 'highly_suitable')),
  notes TEXT,
  reference_id UUID,
  PRIMARY KEY (species_id, purpose_id)
);

-- ============ PLANTING CONDITIONS ============
CREATE TABLE IF NOT EXISTS planting_conditions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category VARCHAR(20) NOT NULL CHECK (category IN
    ('sunlight', 'site', 'soil', 'moisture', 'elevation', 'space')),
  name VARCHAR(120) NOT NULL,
  slug VARCHAR(120) UNIQUE NOT NULL,
  description TEXT,
  active BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE INDEX IF NOT EXISTS idx_conditions_category ON planting_conditions (category);

INSERT INTO planting_conditions (category, name, slug) VALUES
  ('sunlight', 'Full Sun', 'full-sun'),
  ('sunlight', 'Partial Shade', 'partial-shade'),
  ('sunlight', 'Shade', 'shade'),
  ('site', 'Open Field', 'open-field'),
  ('site', 'Backyard', 'backyard'),
  ('site', 'Farm', 'farm'),
  ('site', 'Forest Edge', 'forest-edge'),
  ('site', 'Forest Understory', 'forest-understory'),
  ('site', 'Hillside', 'hillside'),
  ('site', 'Riverbank', 'riverbank'),
  ('site', 'Watershed', 'watershed'),
  ('site', 'Coastal Area', 'coastal-area'),
  ('site', 'Urban Area', 'urban-area'),
  ('site', 'Large Property', 'large-property'),
  ('soil', 'Sandy', 'sandy'),
  ('soil', 'Loamy', 'loamy'),
  ('soil', 'Clay', 'clay'),
  ('soil', 'Rocky', 'rocky'),
  ('soil', 'Well Drained', 'well-drained'),
  ('soil', 'Moist Soil', 'moist-soil'),
  ('moisture', 'Dry', 'dry'),
  ('moisture', 'Moderate', 'moisture-moderate'),
  ('moisture', 'Moist', 'moisture-moist'),
  ('moisture', 'Wet', 'wet'),
  ('elevation', 'Lowland', 'lowland'),
  ('elevation', 'Mid-Elevation', 'mid-elevation'),
  ('elevation', 'Highland', 'highland'),
  ('space', 'Small', 'space-small'),
  ('space', 'Medium', 'space-medium'),
  ('space', 'Large', 'space-large'),
  ('space', 'Very Large', 'space-very-large')
ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, category = EXCLUDED.category;

-- ============ SPECIES PLANTING CONDITIONS ============
CREATE TABLE IF NOT EXISTS species_planting_conditions (
  species_id UUID NOT NULL REFERENCES species(id) ON DELETE CASCADE,
  condition_id UUID NOT NULL REFERENCES planting_conditions(id) ON DELETE CASCADE,
  suitability VARCHAR(20) NOT NULL DEFAULT 'suitable'
    CHECK (suitability IN ('possible', 'suitable', 'highly_suitable')),
  notes TEXT,
  reference_id UUID,
  PRIMARY KEY (species_id, condition_id)
);
CREATE INDEX IF NOT EXISTS idx_spc_condition ON species_planting_conditions (condition_id);

-- ============ SPECIES DISTRIBUTION ============
CREATE TABLE IF NOT EXISTS species_distribution (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  species_id UUID NOT NULL REFERENCES species(id) ON DELETE CASCADE,
  region VARCHAR(120),
  province VARCHAR(120),
  island_group VARCHAR(20) CHECK (island_group IN ('Luzon', 'Visayas', 'Mindanao')),
  distribution_type VARCHAR(20) NOT NULL DEFAULT 'native'
    CHECK (distribution_type IN ('native', 'endemic')),
  notes TEXT,
  reference_id UUID
);
CREATE INDEX IF NOT EXISTS idx_distribution_species ON species_distribution (species_id);
CREATE INDEX IF NOT EXISTS idx_distribution_province ON species_distribution (province);

-- ============ REFERENCES ============
CREATE TABLE IF NOT EXISTS species_references (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  species_id UUID REFERENCES species(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  author VARCHAR(255),
  organization VARCHAR(255),
  publication_year INTEGER,
  source_type VARCHAR(120) NOT NULL DEFAULT 'other',
  source_url TEXT,
  notes TEXT,
  accessed_at DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_references_species ON species_references (species_id);

-- Backfill FK: species_purposes.reference_id -> species_references(id)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_species_purposes_ref') THEN
    ALTER TABLE species_purposes
      ADD CONSTRAINT fk_species_purposes_ref FOREIGN KEY (reference_id)
      REFERENCES species_references(id) ON DELETE SET NULL;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_spc_ref') THEN
    ALTER TABLE species_planting_conditions
      ADD CONSTRAINT fk_spc_ref FOREIGN KEY (reference_id)
      REFERENCES species_references(id) ON DELETE SET NULL;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_distribution_ref') THEN
    ALTER TABLE species_distribution
      ADD CONSTRAINT fk_distribution_ref FOREIGN KEY (reference_id)
      REFERENCES species_references(id) ON DELETE SET NULL;
  END IF;
END $$;
