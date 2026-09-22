-- 009_admin_finish.sql — featured species flag for curated home content.

ALTER TABLE species ADD COLUMN IF NOT EXISTS is_featured BOOLEAN NOT NULL DEFAULT FALSE;
CREATE INDEX IF NOT EXISTS idx_species_featured
  ON species (is_featured) WHERE is_featured AND verification_status = 'verified' AND deleted_at IS NULL;
