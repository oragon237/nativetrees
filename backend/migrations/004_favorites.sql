-- 004_favorites.sql — Phase 3: User Library (favorites).
-- Per code-database.md §20. Unique (user_id + species_id).

CREATE TABLE IF NOT EXISTS favorites (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  species_id UUID NOT NULL REFERENCES species(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, species_id)
);
CREATE INDEX IF NOT EXISTS idx_favorites_user ON favorites (user_id);
