-- 006_marketplace.sql — Phase 5: Native Tree Marketplace.
-- Per code-database.md §§23-24. Listings must link to a species_id.

CREATE TABLE IF NOT EXISTS marketplace_listings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  seller_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  species_id UUID NOT NULL REFERENCES species(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  material_type VARCHAR(20) NOT NULL CHECK (material_type IN ('seed', 'seedling', 'sapling')),
  approximate_age VARCHAR(120),
  approximate_height_cm DECIMAL(8,2),
  quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity >= 0),
  price DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (price >= 0),
  description TEXT NOT NULL DEFAULT '',
  region VARCHAR(120) NOT NULL,
  province VARCHAR(120) NOT NULL,
  municipality VARCHAR(120),
  contact_method VARCHAR(20) NOT NULL DEFAULT 'other'
    CHECK (contact_method IN ('phone', 'email', 'other')),
  contact_value VARCHAR(255) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('draft', 'pending', 'active', 'sold_out', 'rejected', 'removed')),
  reviewed_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_listings_status ON marketplace_listings (status);
CREATE INDEX IF NOT EXISTS idx_listings_species ON marketplace_listings (species_id);
CREATE INDEX IF NOT EXISTS idx_listings_seller ON marketplace_listings (seller_id);
CREATE INDEX IF NOT EXISTS idx_listings_province ON marketplace_listings (province);

DROP TRIGGER IF EXISTS trg_listings_touch ON marketplace_listings;
CREATE TRIGGER trg_listings_touch
  BEFORE UPDATE ON marketplace_listings
  FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

CREATE TABLE IF NOT EXISTS listing_photos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  listing_id UUID NOT NULL REFERENCES marketplace_listings(id) ON DELETE CASCADE,
  file_url TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_listing_photos_listing ON listing_photos (listing_id);
