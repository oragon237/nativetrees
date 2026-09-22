-- 008_beta.sql — Phase 7: broader seed database + performance indexes.
-- Sample records for beta testing; replace with curated data before public launch.

-- Composite index for the public species browser (verified + not deleted first).
CREATE INDEX IF NOT EXISTS idx_species_public
  ON species (verification_status, deleted_at, scientific_name);
CREATE INDEX IF NOT EXISTS idx_observations_public
  ON observations (status, deleted_at, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_listings_public
  ON marketplace_listings (status, deleted_at, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_ident_public
  ON identification_requests (status, deleted_at, created_at DESC);

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('44444444-4444-4444-4444-444444444444', 'Diospyros blancoi', 'Diospyros', 'blancoi', 'Ebenaceae', 'endemic',
   'Kamagong (Mabolo) is an endemic tree famed for its dark hardwood and sweet fruit. SAMPLE RECORD.',
   'Glossy oblong leaves, dark green above and paler beneath.',
   'Dark, nearly black bark on mature trunks, rough and furrowed.',
   'Small creamy bell-shaped flowers, male and female on separate trees.',
   'Round velvety fruit with a sweet edible pulp when ripe.',
   'medium', 10, 20, 6, 10, 'slow', TRUE, TRUE, 'verified'),
  ('55555555-5555-5555-5555-555555555555', 'Intsia bijuga', 'Intsia', 'bijuga', 'Fabaceae', 'native',
   'Ipil is a large native hardwood used in reforestation and coastal plantings. SAMPLE RECORD.',
   'Compound leaves with usually four large oval leaflets.',
   'Gray-brown bark, smooth when young and rougher with age.',
   'Small greenish-white flowers in loose clusters.',
   'Large flat woody pods containing hard seeds.',
   'large', 20, 40, 10, 18, 'moderate', FALSE, TRUE, 'verified'),
  ('66666666-6666-6666-6666-666666666666', 'Terminalia catappa', 'Terminalia', 'catappa', 'Combretaceae', 'native',
   'Talisay is a familiar coastal and urban shade tree with pagoda-like branching. SAMPLE RECORD.',
   'Large leaves clustered at branch tips, turning red before falling.',
   'Gray-brown bark with shallow fissures.',
   'Small greenish-white flowers on slender spikes.',
   'Almond-like fruit with a fibrous husk, buoyant in seawater.',
   'large', 15, 30, 10, 20, 'fast', FALSE, TRUE, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('44444444-4444-4444-4444-444444444444', 'Kamagong', 'common', TRUE),
  ('44444444-4444-4444-4444-444444444444', 'Mabolo', 'local', FALSE),
  ('55555555-5555-5555-5555-555555555555', 'Ipil', 'common', TRUE),
  ('66666666-6666-6666-6666-666666666666', 'Talisay', 'common', TRUE),
  ('66666666-6666-6666-6666-666666666666', 'Umbrella Tree', 'alternative', FALSE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT v.s::uuid, p.id, v.suit FROM (VALUES
    ('44444444-4444-4444-4444-444444444444', 'fruit-bearing', 'highly_suitable'),
    ('44444444-4444-4444-4444-444444444444', 'flowering-ornamental', 'suitable'),
    ('44444444-4444-4444-4444-444444444444', 'urban-landscaping', 'suitable'),
    ('44444444-4444-4444-4444-444444444444', 'agroforestry', 'possible'),
    ('55555555-5555-5555-5555-555555555555', 'reforestation', 'highly_suitable'),
    ('55555555-5555-5555-5555-555555555555', 'coastal-rehabilitation', 'suitable'),
    ('55555555-5555-5555-5555-555555555555', 'windbreak', 'suitable'),
    ('55555555-5555-5555-5555-555555555555', 'carbon-storage', 'suitable'),
    ('55555555-5555-5555-5555-555555555555', 'soil-erosion-control', 'possible'),
    ('66666666-6666-6666-6666-666666666666', 'shade', 'highly_suitable'),
    ('66666666-6666-6666-6666-666666666666', 'coastal-rehabilitation', 'highly_suitable'),
    ('66666666-6666-6666-6666-666666666666', 'urban-landscaping', 'highly_suitable'),
    ('66666666-6666-6666-6666-666666666666', 'windbreak', 'suitable'),
    ('66666666-6666-6666-6666-666666666666', 'wildlife-support', 'suitable')
  ) AS v(s, slug, suit)
  JOIN purposes p ON p.slug = v.slug
ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT v.s::uuid, c.id, 'suitable' FROM (VALUES
    ('44444444-4444-4444-4444-444444444444', 'full-sun'),
    ('44444444-4444-4444-4444-444444444444', 'partial-shade'),
    ('44444444-4444-4444-4444-444444444444', 'backyard'),
    ('44444444-4444-4444-4444-444444444444', 'farm'),
    ('44444444-4444-4444-4444-444444444444', 'loamy'),
    ('44444444-4444-4444-4444-444444444444', 'well-drained'),
    ('44444444-4444-4444-4444-444444444444', 'moisture-moderate'),
    ('44444444-4444-4444-4444-444444444444', 'lowland'),
    ('44444444-4444-4444-4444-444444444444', 'space-medium'),
    ('44444444-4444-4444-4444-444444444444', 'space-large'),
    ('55555555-5555-5555-5555-555555555555', 'full-sun'),
    ('55555555-5555-5555-5555-555555555555', 'open-field'),
    ('55555555-5555-5555-5555-555555555555', 'coastal-area'),
    ('55555555-5555-5555-5555-555555555555', 'watershed'),
    ('55555555-5555-5555-5555-555555555555', 'sandy'),
    ('55555555-5555-5555-5555-555555555555', 'loamy'),
    ('55555555-5555-5555-5555-555555555555', 'dry'),
    ('55555555-5555-5555-5555-555555555555', 'moisture-moderate'),
    ('55555555-5555-5555-5555-555555555555', 'lowland'),
    ('55555555-5555-5555-5555-555555555555', 'space-large'),
    ('55555555-5555-5555-5555-555555555555', 'space-very-large'),
    ('66666666-6666-6666-6666-666666666666', 'full-sun'),
    ('66666666-6666-6666-6666-666666666666', 'coastal-area'),
    ('66666666-6666-6666-6666-666666666666', 'urban-area'),
    ('66666666-6666-6666-6666-666666666666', 'backyard'),
    ('66666666-6666-6666-6666-666666666666', 'large-property'),
    ('66666666-6666-6666-6666-666666666666', 'sandy'),
    ('66666666-6666-6666-6666-666666666666', 'loamy'),
    ('66666666-6666-6666-6666-666666666666', 'moisture-moderate'),
    ('66666666-6666-6666-6666-666666666666', 'lowland'),
    ('66666666-6666-6666-6666-666666666666', 'space-large'),
    ('66666666-6666-6666-6666-666666666666', 'space-very-large')
  ) AS v(s, slug)
  JOIN planting_conditions c ON c.slug = v.slug
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('44444444-4444-4444-4444-444444444444', 'Luzon', 'endemic'),
  ('44444444-4444-4444-4444-444444444444', 'Visayas', 'endemic'),
  ('44444444-4444-4444-4444-444444444444', 'Mindanao', 'endemic'),
  ('55555555-5555-5555-5555-555555555555', 'Luzon', 'native'),
  ('55555555-5555-5555-5555-555555555555', 'Visayas', 'native'),
  ('55555555-5555-5555-5555-555555555555', 'Mindanao', 'native'),
  ('66666666-6666-6666-6666-666666666666', 'Luzon', 'native'),
  ('66666666-6666-6666-6666-666666666666', 'Visayas', 'native'),
  ('66666666-6666-6666-6666-666666666666', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('44444444-4444-4444-4444-444444444444', 'Kamagong sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.'),
  ('55555555-5555-5555-5555-555555555555', 'Ipil sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.'),
  ('66666666-6666-6666-6666-666666666666', 'Talisay sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;
