-- 003_sample_species.sql — Phase 2 sample data for testing search/filter.
-- Clearly marked as sample records; replace with curated data before beta.

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('11111111-1111-1111-1111-111111111111', 'Pterocarpus indicus', 'Pterocarpus', 'indicus', 'Fabaceae', 'native',
   'Narra is the national tree of the Philippines, valued for its hardwood and favored as a shade and landscape tree where space allows. SAMPLE RECORD.',
   'Compound leaves with oval leaflets arranged alternately along the stalk.',
   'Grayish-brown bark that may become fissured with age.',
   'Small fragrant yellow flowers borne in branched clusters during the dry season.',
   'Flat rounded pods with a broad papery wing surrounding the seed.',
   'large', 15, 30, 8, 15, 'moderate', FALSE, TRUE, 'verified'),
  ('22222222-2222-2222-2222-222222222222', 'Vitex parviflora', 'Vitex', 'parviflora', 'Lamiaceae', 'native',
   'Molave is a hardy native tree prized for its durable wood and tolerance of dry, rocky sites. SAMPLE RECORD.',
   'Compound leaves with three to five toothed leaflets.',
   'Gray to brown bark, becoming rough and flaky.',
   'Small bluish-purple flowers in terminal clusters.',
   'Small rounded fleshy fruit that turns dark when ripe.',
   'medium', 8, 15, 5, 10, 'slow', FALSE, TRUE, 'verified'),
  ('33333333-3333-3333-3333-333333333333', 'Lagerstroemia speciosa', 'Lagerstroemia', 'speciosa', 'Lythraceae', 'native',
   'Banaba is a showy native tree with large purple-pink flower clusters, widely planted in urban landscapes. SAMPLE RECORD.',
   'Large smooth oval leaves that may turn reddish before falling.',
   'Smooth pale bark that sheds in thin patches.',
   'Large clusters of showy purple to pinkish flowers in the wet season.',
   'Woody capsules that split to release winged seeds.',
   'medium', 10, 20, 6, 12, 'moderate', FALSE, TRUE, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

-- Names
INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('11111111-1111-1111-1111-111111111111', 'Narra', 'common', TRUE),
  ('11111111-1111-1111-1111-111111111111', 'Naga', 'local', FALSE),
  ('11111111-1111-1111-1111-111111111111', 'Asana', 'local', FALSE),
  ('22222222-2222-2222-2222-222222222222', 'Molave', 'common', TRUE),
  ('22222222-2222-2222-2222-222222222222', 'Tugas', 'local', FALSE),
  ('33333333-3333-3333-3333-333333333333', 'Banaba', 'common', TRUE)
ON CONFLICT DO NOTHING;

-- Purposes
INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT v.s::uuid, p.id, v.suit FROM (VALUES
    ('11111111-1111-1111-1111-111111111111', 'shade', 'highly_suitable'),
    ('11111111-1111-1111-1111-111111111111', 'reforestation', 'suitable'),
    ('11111111-1111-1111-1111-111111111111', 'wildlife-support', 'suitable'),
    ('11111111-1111-1111-1111-111111111111', 'urban-landscaping', 'suitable'),
    ('11111111-1111-1111-1111-111111111111', 'carbon-storage', 'suitable'),
    ('11111111-1111-1111-1111-111111111111', 'agroforestry', 'possible'),
    ('22222222-2222-2222-2222-222222222222', 'reforestation', 'highly_suitable'),
    ('22222222-2222-2222-2222-222222222222', 'soil-erosion-control', 'suitable'),
    ('22222222-2222-2222-2222-222222222222', 'slope-rehabilitation', 'suitable'),
    ('22222222-2222-2222-2222-222222222222', 'windbreak', 'suitable'),
    ('22222222-2222-2222-2222-222222222222', 'agroforestry', 'suitable'),
    ('33333333-3333-3333-3333-333333333333', 'flowering-ornamental', 'highly_suitable'),
    ('33333333-3333-3333-3333-333333333333', 'urban-landscaping', 'highly_suitable'),
    ('33333333-3333-3333-3333-333333333333', 'shade', 'suitable'),
    ('33333333-3333-3333-3333-333333333333', 'riverbank-riparian-rehabilitation', 'suitable'),
    ('33333333-3333-3333-3333-333333333333', 'watershed-rehabilitation', 'possible')
  ) AS v(s, slug, suit)
  JOIN purposes p ON p.slug = v.slug
ON CONFLICT DO NOTHING;

-- Planting conditions
INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT v.s::uuid, c.id, 'suitable' FROM (VALUES
    ('11111111-1111-1111-1111-111111111111', 'full-sun'),
    ('11111111-1111-1111-1111-111111111111', 'partial-shade'),
    ('11111111-1111-1111-1111-111111111111', 'backyard'),
    ('11111111-1111-1111-1111-111111111111', 'farm'),
    ('11111111-1111-1111-1111-111111111111', 'open-field'),
    ('11111111-1111-1111-1111-111111111111', 'large-property'),
    ('11111111-1111-1111-1111-111111111111', 'urban-area'),
    ('11111111-1111-1111-1111-111111111111', 'loamy'),
    ('11111111-1111-1111-1111-111111111111', 'clay'),
    ('11111111-1111-1111-1111-111111111111', 'well-drained'),
    ('11111111-1111-1111-1111-111111111111', 'moisture-moderate'),
    ('11111111-1111-1111-1111-111111111111', 'lowland'),
    ('11111111-1111-1111-1111-111111111111', 'mid-elevation'),
    ('11111111-1111-1111-1111-111111111111', 'space-large'),
    ('11111111-1111-1111-1111-111111111111', 'space-very-large'),
    ('22222222-2222-2222-2222-222222222222', 'full-sun'),
    ('22222222-2222-2222-2222-222222222222', 'open-field'),
    ('22222222-2222-2222-2222-222222222222', 'hillside'),
    ('22222222-2222-2222-2222-222222222222', 'farm'),
    ('22222222-2222-2222-2222-222222222222', 'rocky'),
    ('22222222-2222-2222-2222-222222222222', 'clay'),
    ('22222222-2222-2222-2222-222222222222', 'well-drained'),
    ('22222222-2222-2222-2222-222222222222', 'dry'),
    ('22222222-2222-2222-2222-222222222222', 'moisture-moderate'),
    ('22222222-2222-2222-2222-222222222222', 'lowland'),
    ('22222222-2222-2222-2222-222222222222', 'mid-elevation'),
    ('22222222-2222-2222-2222-222222222222', 'space-medium'),
    ('22222222-2222-2222-2222-222222222222', 'space-large'),
    ('33333333-3333-3333-3333-333333333333', 'full-sun'),
    ('33333333-3333-3333-3333-333333333333', 'partial-shade'),
    ('33333333-3333-3333-3333-333333333333', 'backyard'),
    ('33333333-3333-3333-3333-333333333333', 'riverbank'),
    ('33333333-3333-3333-3333-333333333333', 'watershed'),
    ('33333333-3333-3333-3333-333333333333', 'urban-area'),
    ('33333333-3333-3333-3333-333333333333', 'large-property'),
    ('33333333-3333-3333-3333-333333333333', 'loamy'),
    ('33333333-3333-3333-3333-333333333333', 'moist-soil'),
    ('33333333-3333-3333-3333-333333333333', 'moisture-moist'),
    ('33333333-3333-3333-3333-333333333333', 'moisture-moderate'),
    ('33333333-3333-3333-3333-333333333333', 'lowland'),
    ('33333333-3333-3333-3333-333333333333', 'space-medium'),
    ('33333333-3333-3333-3333-333333333333', 'space-large')
  ) AS v(s, slug)
  JOIN planting_conditions c ON c.slug = v.slug
ON CONFLICT DO NOTHING;

-- Distribution (widespread natives)
INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('11111111-1111-1111-1111-111111111111', 'Luzon', 'native'),
  ('11111111-1111-1111-1111-111111111111', 'Visayas', 'native'),
  ('11111111-1111-1111-1111-111111111111', 'Mindanao', 'native'),
  ('22222222-2222-2222-2222-222222222222', 'Luzon', 'native'),
  ('22222222-2222-2222-2222-222222222222', 'Visayas', 'native'),
  ('22222222-2222-2222-2222-222222222222', 'Mindanao', 'native'),
  ('33333333-3333-3333-3333-333333333333', 'Luzon', 'native'),
  ('33333333-3333-3333-3333-333333333333', 'Visayas', 'native'),
  ('33333333-3333-3333-3333-333333333333', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

-- Sample references (illustrative — replace with curated sources before beta)
INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('11111111-1111-1111-1111-111111111111', 'Narra sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.'),
  ('22222222-2222-2222-2222-222222222222', 'Molave sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.'),
  ('33333333-3333-3333-3333-333333333333', 'Banaba sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;
