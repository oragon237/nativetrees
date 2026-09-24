-- 013_mass_species.sql — 50 additional native trees (generated).
-- Sample records for beta; replace with curated data before public launch.

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', 'Shorea astylosa', 'Shorea', 'astylosa', 'Dipterocarpaceae', 'endemic',
   'Yakal is a dense endemic hardwood of lowland rainforests. SAMPLE RECORD.', 'Oval leathery leaves with pointed tips.', 'Dark brown bark, deeply fissured on old trunks.', 'Small yellowish flowers in branched clusters.', 'Small winged fruit typical of dipterocarps.',
   'large', 20, 30, 10, 16,
   'slow', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', 'Yakal', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', id, 'highly_suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', id, 'suitable' FROM purposes WHERE slug = 'carbon-storage'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', id, 'possible' FROM purposes WHERE slug = 'wildlife-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', id, 'suitable' FROM planting_conditions WHERE slug = 'partial-shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', id, 'suitable' FROM planting_conditions WHERE slug = 'watershed'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', id, 'suitable' FROM planting_conditions WHERE slug = 'space-very-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', 'Luzon', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', 'Visayas', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', 'Mindanao', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', 'Yakal sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('583d2121-61ec-53d6-bac5-86a232b490f6', 'Dipterocarpus grandiflorus', 'Dipterocarpus', 'grandiflorus', 'Dipterocarpaceae', 'native',
   'Apitong is a towering dipterocarp named for its large flowers. SAMPLE RECORD.', 'Very large oval leaves, hairy beneath when young.', 'Gray-brown bark exuding pale resin when cut.', 'Large white-pink fragrant flowers.', 'Large nut with two long wings.',
   'large', 30, 50, 12, 20,
   'slow', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('583d2121-61ec-53d6-bac5-86a232b490f6', 'Apitong', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '583d2121-61ec-53d6-bac5-86a232b490f6', id, 'highly_suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '583d2121-61ec-53d6-bac5-86a232b490f6', id, 'suitable' FROM purposes WHERE slug = 'carbon-storage'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '583d2121-61ec-53d6-bac5-86a232b490f6', id, 'possible' FROM purposes WHERE slug = 'watershed-rehabilitation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '583d2121-61ec-53d6-bac5-86a232b490f6', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '583d2121-61ec-53d6-bac5-86a232b490f6', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '583d2121-61ec-53d6-bac5-86a232b490f6', id, 'suitable' FROM planting_conditions WHERE slug = 'watershed'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '583d2121-61ec-53d6-bac5-86a232b490f6', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '583d2121-61ec-53d6-bac5-86a232b490f6', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '583d2121-61ec-53d6-bac5-86a232b490f6', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '583d2121-61ec-53d6-bac5-86a232b490f6', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '583d2121-61ec-53d6-bac5-86a232b490f6', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '583d2121-61ec-53d6-bac5-86a232b490f6', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '583d2121-61ec-53d6-bac5-86a232b490f6', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '583d2121-61ec-53d6-bac5-86a232b490f6', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '583d2121-61ec-53d6-bac5-86a232b490f6', id, 'suitable' FROM planting_conditions WHERE slug = 'space-very-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('583d2121-61ec-53d6-bac5-86a232b490f6', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('583d2121-61ec-53d6-bac5-86a232b490f6', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('583d2121-61ec-53d6-bac5-86a232b490f6', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('583d2121-61ec-53d6-bac5-86a232b490f6', 'Apitong sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('3f3a98a1-6846-5517-93ac-dc784e76d813', 'Shorea guiso', 'Shorea', 'guiso', 'Dipterocarpaceae', 'native',
   'Guijo is a straight-boled native dipterocarp of lowland forests. SAMPLE RECORD.', 'Oblong leaves with a rounded base.', 'Brown bark peeling in small flakes.', 'Small creamy flowers in panicles.', 'Small winged nut.',
   'large', 25, 40, 10, 16,
   'slow', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('3f3a98a1-6846-5517-93ac-dc784e76d813', 'Guijo', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '3f3a98a1-6846-5517-93ac-dc784e76d813', id, 'highly_suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '3f3a98a1-6846-5517-93ac-dc784e76d813', id, 'suitable' FROM purposes WHERE slug = 'carbon-storage'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '3f3a98a1-6846-5517-93ac-dc784e76d813', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '3f3a98a1-6846-5517-93ac-dc784e76d813', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '3f3a98a1-6846-5517-93ac-dc784e76d813', id, 'suitable' FROM planting_conditions WHERE slug = 'watershed'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '3f3a98a1-6846-5517-93ac-dc784e76d813', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '3f3a98a1-6846-5517-93ac-dc784e76d813', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '3f3a98a1-6846-5517-93ac-dc784e76d813', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '3f3a98a1-6846-5517-93ac-dc784e76d813', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '3f3a98a1-6846-5517-93ac-dc784e76d813', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '3f3a98a1-6846-5517-93ac-dc784e76d813', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '3f3a98a1-6846-5517-93ac-dc784e76d813', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '3f3a98a1-6846-5517-93ac-dc784e76d813', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '3f3a98a1-6846-5517-93ac-dc784e76d813', id, 'suitable' FROM planting_conditions WHERE slug = 'space-very-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('3f3a98a1-6846-5517-93ac-dc784e76d813', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('3f3a98a1-6846-5517-93ac-dc784e76d813', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('3f3a98a1-6846-5517-93ac-dc784e76d813', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('3f3a98a1-6846-5517-93ac-dc784e76d813', 'Guijo sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('516fb15c-1092-5535-839f-4651e475ff25', 'Shorea contorta', 'Shorea', 'contorta', 'Dipterocarpaceae', 'endemic',
   'White lauan is a fast endemic dipterocarp with pale timber. SAMPLE RECORD.', 'Twisted-asymmetric leaf bases, hence the name.', 'Pale gray bark, smooth to lightly fissured.', 'Small yellow-white flowers.', 'Small winged fruit.',
   'large', 30, 50, 12, 20,
   'moderate', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('516fb15c-1092-5535-839f-4651e475ff25', 'White Lauan', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('516fb15c-1092-5535-839f-4651e475ff25', 'White lauan', 'alternative', FALSE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '516fb15c-1092-5535-839f-4651e475ff25', id, 'highly_suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '516fb15c-1092-5535-839f-4651e475ff25', id, 'suitable' FROM purposes WHERE slug = 'carbon-storage'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '516fb15c-1092-5535-839f-4651e475ff25', id, 'possible' FROM purposes WHERE slug = 'agroforestry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '516fb15c-1092-5535-839f-4651e475ff25', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '516fb15c-1092-5535-839f-4651e475ff25', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '516fb15c-1092-5535-839f-4651e475ff25', id, 'suitable' FROM planting_conditions WHERE slug = 'watershed'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '516fb15c-1092-5535-839f-4651e475ff25', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '516fb15c-1092-5535-839f-4651e475ff25', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '516fb15c-1092-5535-839f-4651e475ff25', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '516fb15c-1092-5535-839f-4651e475ff25', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '516fb15c-1092-5535-839f-4651e475ff25', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '516fb15c-1092-5535-839f-4651e475ff25', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '516fb15c-1092-5535-839f-4651e475ff25', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '516fb15c-1092-5535-839f-4651e475ff25', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '516fb15c-1092-5535-839f-4651e475ff25', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '516fb15c-1092-5535-839f-4651e475ff25', id, 'suitable' FROM planting_conditions WHERE slug = 'space-very-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('516fb15c-1092-5535-839f-4651e475ff25', 'Luzon', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('516fb15c-1092-5535-839f-4651e475ff25', 'Visayas', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('516fb15c-1092-5535-839f-4651e475ff25', 'Mindanao', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('516fb15c-1092-5535-839f-4651e475ff25', 'White Lauan sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('660de18d-dcb8-5c82-b652-479e435ae130', 'Shorea negrosensis', 'Shorea', 'negrosensis', 'Dipterocarpaceae', 'endemic',
   'Red lauan is a tall endemic dipterocarp with reddish timber. SAMPLE RECORD.', 'Elliptical leaves with prominent veins.', 'Reddish-brown bark, vertically fissured.', 'Small pale flowers in large clusters.', 'Winged nut with three long wings.',
   'large', 25, 45, 10, 18,
   'slow', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('660de18d-dcb8-5c82-b652-479e435ae130', 'Red Lauan', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('660de18d-dcb8-5c82-b652-479e435ae130', 'Red lauan', 'alternative', FALSE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '660de18d-dcb8-5c82-b652-479e435ae130', id, 'highly_suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '660de18d-dcb8-5c82-b652-479e435ae130', id, 'suitable' FROM purposes WHERE slug = 'carbon-storage'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '660de18d-dcb8-5c82-b652-479e435ae130', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '660de18d-dcb8-5c82-b652-479e435ae130', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '660de18d-dcb8-5c82-b652-479e435ae130', id, 'suitable' FROM planting_conditions WHERE slug = 'watershed'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '660de18d-dcb8-5c82-b652-479e435ae130', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '660de18d-dcb8-5c82-b652-479e435ae130', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '660de18d-dcb8-5c82-b652-479e435ae130', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '660de18d-dcb8-5c82-b652-479e435ae130', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '660de18d-dcb8-5c82-b652-479e435ae130', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '660de18d-dcb8-5c82-b652-479e435ae130', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '660de18d-dcb8-5c82-b652-479e435ae130', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '660de18d-dcb8-5c82-b652-479e435ae130', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '660de18d-dcb8-5c82-b652-479e435ae130', id, 'suitable' FROM planting_conditions WHERE slug = 'space-very-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('660de18d-dcb8-5c82-b652-479e435ae130', 'Luzon', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('660de18d-dcb8-5c82-b652-479e435ae130', 'Visayas', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('660de18d-dcb8-5c82-b652-479e435ae130', 'Mindanao', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('660de18d-dcb8-5c82-b652-479e435ae130', 'Red Lauan sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('aa531a38-4170-5d1c-9d76-7e395ed9d5e2', 'Shorea polysperma', 'Shorea', 'polysperma', 'Dipterocarpaceae', 'endemic',
   'Tanguile is one of the tallest endemic dipterocarps. SAMPLE RECORD.', 'Large thin papery leaves.', 'Pale bark with horizontal markings.', 'Small cream flowers.', 'Many-seeded winged fruit.',
   'large', 30, 50, 12, 20,
   'slow', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('aa531a38-4170-5d1c-9d76-7e395ed9d5e2', 'Tanguile', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'aa531a38-4170-5d1c-9d76-7e395ed9d5e2', id, 'highly_suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'aa531a38-4170-5d1c-9d76-7e395ed9d5e2', id, 'suitable' FROM purposes WHERE slug = 'carbon-storage'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'aa531a38-4170-5d1c-9d76-7e395ed9d5e2', id, 'possible' FROM purposes WHERE slug = 'watershed-rehabilitation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa531a38-4170-5d1c-9d76-7e395ed9d5e2', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa531a38-4170-5d1c-9d76-7e395ed9d5e2', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa531a38-4170-5d1c-9d76-7e395ed9d5e2', id, 'suitable' FROM planting_conditions WHERE slug = 'watershed'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa531a38-4170-5d1c-9d76-7e395ed9d5e2', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa531a38-4170-5d1c-9d76-7e395ed9d5e2', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa531a38-4170-5d1c-9d76-7e395ed9d5e2', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa531a38-4170-5d1c-9d76-7e395ed9d5e2', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa531a38-4170-5d1c-9d76-7e395ed9d5e2', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa531a38-4170-5d1c-9d76-7e395ed9d5e2', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa531a38-4170-5d1c-9d76-7e395ed9d5e2', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa531a38-4170-5d1c-9d76-7e395ed9d5e2', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa531a38-4170-5d1c-9d76-7e395ed9d5e2', id, 'suitable' FROM planting_conditions WHERE slug = 'space-very-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('aa531a38-4170-5d1c-9d76-7e395ed9d5e2', 'Luzon', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('aa531a38-4170-5d1c-9d76-7e395ed9d5e2', 'Visayas', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('aa531a38-4170-5d1c-9d76-7e395ed9d5e2', 'Mindanao', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('aa531a38-4170-5d1c-9d76-7e395ed9d5e2', 'Tanguile sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('ac3da653-a045-571b-9b3e-76983ccff95b', 'Shorea palosapis', 'Shorea', 'palosapis', 'Dipterocarpaceae', 'endemic',
   'Mayapis is an endemic lowland dipterocarp with light timber. SAMPLE RECORD.', 'Broad oval leaves, pale beneath.', 'Light gray bark, fairly smooth.', 'Small white fragrant flowers.', 'Winged nut.',
   'large', 25, 40, 10, 18,
   'slow', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('ac3da653-a045-571b-9b3e-76983ccff95b', 'Mayapis', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'ac3da653-a045-571b-9b3e-76983ccff95b', id, 'highly_suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'ac3da653-a045-571b-9b3e-76983ccff95b', id, 'suitable' FROM purposes WHERE slug = 'carbon-storage'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ac3da653-a045-571b-9b3e-76983ccff95b', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ac3da653-a045-571b-9b3e-76983ccff95b', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ac3da653-a045-571b-9b3e-76983ccff95b', id, 'suitable' FROM planting_conditions WHERE slug = 'watershed'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ac3da653-a045-571b-9b3e-76983ccff95b', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ac3da653-a045-571b-9b3e-76983ccff95b', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ac3da653-a045-571b-9b3e-76983ccff95b', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ac3da653-a045-571b-9b3e-76983ccff95b', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ac3da653-a045-571b-9b3e-76983ccff95b', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ac3da653-a045-571b-9b3e-76983ccff95b', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ac3da653-a045-571b-9b3e-76983ccff95b', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ac3da653-a045-571b-9b3e-76983ccff95b', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ac3da653-a045-571b-9b3e-76983ccff95b', id, 'suitable' FROM planting_conditions WHERE slug = 'space-very-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('ac3da653-a045-571b-9b3e-76983ccff95b', 'Luzon', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('ac3da653-a045-571b-9b3e-76983ccff95b', 'Visayas', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('ac3da653-a045-571b-9b3e-76983ccff95b', 'Mindanao', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('ac3da653-a045-571b-9b3e-76983ccff95b', 'Mayapis sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('75beee58-f41a-5ee1-ba5c-3574d8005bbf', 'Shorea almon', 'Shorea', 'almon', 'Dipterocarpaceae', 'endemic',
   'Almon is a light-demanding endemic dipterocarp of disturbed lowlands. SAMPLE RECORD.', 'Oval pointed leaves on slender twigs.', 'Gray-brown flaky bark.', 'Small yellowish flowers.', 'Winged fruit.',
   'large', 30, 50, 12, 20,
   'moderate', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('75beee58-f41a-5ee1-ba5c-3574d8005bbf', 'Almon', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '75beee58-f41a-5ee1-ba5c-3574d8005bbf', id, 'highly_suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '75beee58-f41a-5ee1-ba5c-3574d8005bbf', id, 'suitable' FROM purposes WHERE slug = 'carbon-storage'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '75beee58-f41a-5ee1-ba5c-3574d8005bbf', id, 'possible' FROM purposes WHERE slug = 'agroforestry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '75beee58-f41a-5ee1-ba5c-3574d8005bbf', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '75beee58-f41a-5ee1-ba5c-3574d8005bbf', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '75beee58-f41a-5ee1-ba5c-3574d8005bbf', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '75beee58-f41a-5ee1-ba5c-3574d8005bbf', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '75beee58-f41a-5ee1-ba5c-3574d8005bbf', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '75beee58-f41a-5ee1-ba5c-3574d8005bbf', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '75beee58-f41a-5ee1-ba5c-3574d8005bbf', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '75beee58-f41a-5ee1-ba5c-3574d8005bbf', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '75beee58-f41a-5ee1-ba5c-3574d8005bbf', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '75beee58-f41a-5ee1-ba5c-3574d8005bbf', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '75beee58-f41a-5ee1-ba5c-3574d8005bbf', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '75beee58-f41a-5ee1-ba5c-3574d8005bbf', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '75beee58-f41a-5ee1-ba5c-3574d8005bbf', id, 'suitable' FROM planting_conditions WHERE slug = 'space-very-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('75beee58-f41a-5ee1-ba5c-3574d8005bbf', 'Luzon', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('75beee58-f41a-5ee1-ba5c-3574d8005bbf', 'Visayas', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('75beee58-f41a-5ee1-ba5c-3574d8005bbf', 'Mindanao', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('75beee58-f41a-5ee1-ba5c-3574d8005bbf', 'Almon sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', 'Parashorea malaanonan', 'Parashorea', 'malaanonan', 'Dipterocarpaceae', 'native',
   'Bagtikan is a massive emergent dipterocarp of primary rainforest. SAMPLE RECORD.', 'Very large leathery oval leaves.', 'Thick gray bark with resin.', 'Small white flowers.', 'Large winged fruit.',
   'large', 30, 50, 14, 22,
   'slow', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', 'Bagtikan', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', id, 'highly_suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', id, 'highly_suitable' FROM purposes WHERE slug = 'carbon-storage'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', id, 'possible' FROM purposes WHERE slug = 'watershed-rehabilitation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', id, 'suitable' FROM planting_conditions WHERE slug = 'watershed'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', id, 'suitable' FROM planting_conditions WHERE slug = 'space-very-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', 'Bagtikan sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', 'Sindora supa', 'Sindora', 'supa', 'Fabaceae', 'endemic',
   'Supa is a rare endemic hardwood with fragrant oily wood. SAMPLE RECORD.', 'Compound leaves with few large leaflets.', 'Dark rough bark.', 'Yellowish pea-like flowers.', 'Flat woody pods.',
   'medium', 12, 20, 6, 10,
   'slow', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', 'Supa', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', id, 'suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', id, 'possible' FROM purposes WHERE slug = 'carbon-storage'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', 'Luzon', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', 'Visayas', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', 'Mindanao', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', 'Supa sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('49240a8a-04f3-5b45-ac7a-abeb82d7848e', 'Afzelia rhomboidea', 'Afzelia', 'rhomboidea', 'Fabaceae', 'native',
   'Tindalo is a prized native hardwood with beautiful reddish grain. SAMPLE RECORD.', 'Compound leaves with diamond-shaped leaflets.', 'Gray-brown scaly bark.', 'Fragrant white to pinkish flowers.', 'Thick woody pods with hard black-red seeds.',
   'medium', 15, 25, 8, 12,
   'slow', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('49240a8a-04f3-5b45-ac7a-abeb82d7848e', 'Tindalo', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('49240a8a-04f3-5b45-ac7a-abeb82d7848e', 'Tindalo', 'common', FALSE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', id, 'suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', id, 'possible' FROM purposes WHERE slug = 'agroforestry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', id, 'possible' FROM purposes WHERE slug = 'urban-landscaping'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', id, 'suitable' FROM planting_conditions WHERE slug = 'dry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', id, 'suitable' FROM planting_conditions WHERE slug = 'space-very-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('49240a8a-04f3-5b45-ac7a-abeb82d7848e', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('49240a8a-04f3-5b45-ac7a-abeb82d7848e', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('49240a8a-04f3-5b45-ac7a-abeb82d7848e', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('49240a8a-04f3-5b45-ac7a-abeb82d7848e', 'Tindalo sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('1ea97872-b798-581f-9557-525ddf93660f', 'Toona calantas', 'Toona', 'calantas', 'Meliaceae', 'native',
   'Kalantas is a tall native tree valued for its light reddish timber. SAMPLE RECORD.', 'Long compound leaves with many toothed leaflets.', 'Gray-brown bark with long fissures.', 'Small white fragrant flowers in large sprays.', 'Small capsules releasing winged seeds.',
   'large', 20, 35, 10, 16,
   'moderate', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('1ea97872-b798-581f-9557-525ddf93660f', 'Kalantas', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '1ea97872-b798-581f-9557-525ddf93660f', id, 'suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '1ea97872-b798-581f-9557-525ddf93660f', id, 'suitable' FROM purposes WHERE slug = 'agroforestry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '1ea97872-b798-581f-9557-525ddf93660f', id, 'possible' FROM purposes WHERE slug = 'carbon-storage'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1ea97872-b798-581f-9557-525ddf93660f', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1ea97872-b798-581f-9557-525ddf93660f', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1ea97872-b798-581f-9557-525ddf93660f', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1ea97872-b798-581f-9557-525ddf93660f', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1ea97872-b798-581f-9557-525ddf93660f', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1ea97872-b798-581f-9557-525ddf93660f', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1ea97872-b798-581f-9557-525ddf93660f', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1ea97872-b798-581f-9557-525ddf93660f', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1ea97872-b798-581f-9557-525ddf93660f', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1ea97872-b798-581f-9557-525ddf93660f', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1ea97872-b798-581f-9557-525ddf93660f', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1ea97872-b798-581f-9557-525ddf93660f', id, 'suitable' FROM planting_conditions WHERE slug = 'space-very-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('1ea97872-b798-581f-9557-525ddf93660f', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('1ea97872-b798-581f-9557-525ddf93660f', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('1ea97872-b798-581f-9557-525ddf93660f', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('1ea97872-b798-581f-9557-525ddf93660f', 'Kalantas sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('a2f59121-838f-5f02-ba84-315ab1d1043a', 'Wrightia pubescens', 'Wrightia', 'pubescens', 'Apocynaceae', 'native',
   'Lanete is a graceful native tree with fine wood used for carving. SAMPLE RECORD.', 'Small opposite oval leaves, softly hairy.', 'Pale gray smooth bark.', 'Fragrant white star-shaped flowers.', 'Long paired slender pods.',
   'small', 8, 15, 4, 8,
   'moderate', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('a2f59121-838f-5f02-ba84-315ab1d1043a', 'Lanete', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'a2f59121-838f-5f02-ba84-315ab1d1043a', id, 'suitable' FROM purposes WHERE slug = 'urban-landscaping'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'a2f59121-838f-5f02-ba84-315ab1d1043a', id, 'possible' FROM purposes WHERE slug = 'flowering-ornamental'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'a2f59121-838f-5f02-ba84-315ab1d1043a', id, 'possible' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2f59121-838f-5f02-ba84-315ab1d1043a', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2f59121-838f-5f02-ba84-315ab1d1043a', id, 'suitable' FROM planting_conditions WHERE slug = 'partial-shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2f59121-838f-5f02-ba84-315ab1d1043a', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2f59121-838f-5f02-ba84-315ab1d1043a', id, 'suitable' FROM planting_conditions WHERE slug = 'urban-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2f59121-838f-5f02-ba84-315ab1d1043a', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2f59121-838f-5f02-ba84-315ab1d1043a', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2f59121-838f-5f02-ba84-315ab1d1043a', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2f59121-838f-5f02-ba84-315ab1d1043a', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2f59121-838f-5f02-ba84-315ab1d1043a', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2f59121-838f-5f02-ba84-315ab1d1043a', id, 'suitable' FROM planting_conditions WHERE slug = 'space-small'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a2f59121-838f-5f02-ba84-315ab1d1043a', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('a2f59121-838f-5f02-ba84-315ab1d1043a', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('a2f59121-838f-5f02-ba84-315ab1d1043a', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('a2f59121-838f-5f02-ba84-315ab1d1043a', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('a2f59121-838f-5f02-ba84-315ab1d1043a', 'Lanete sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('9042b73a-fd82-5c28-afc8-b85874d87a2d', 'Alstonia macrophylla', 'Alstonia', 'macrophylla', 'Apocynaceae', 'native',
   'Batino is a quick-growing native tree with large whorled leaves. SAMPLE RECORD.', 'Very large leaves in whorls.', 'Gray bark with milky sap.', 'Small white fragrant flower clusters.', 'Long paired pods with silky seeds.',
   'medium', 12, 25, 6, 12,
   'fast', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('9042b73a-fd82-5c28-afc8-b85874d87a2d', 'Batino', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'possible' FROM purposes WHERE slug = 'urban-landscaping'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'possible' FROM purposes WHERE slug = 'watershed-rehabilitation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'suitable' FROM planting_conditions WHERE slug = 'watershed'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moist'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('9042b73a-fd82-5c28-afc8-b85874d87a2d', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('9042b73a-fd82-5c28-afc8-b85874d87a2d', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('9042b73a-fd82-5c28-afc8-b85874d87a2d', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('9042b73a-fd82-5c28-afc8-b85874d87a2d', 'Batino sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('a37c524a-7fba-5234-841f-b4ac8f21d7dc', 'Artocarpus ovatus', 'Artocarpus', 'ovatus', 'Moraceae', 'endemic',
   'Anubing is an endemic forest tree with edible fruit favored by wildlife. SAMPLE RECORD.', 'Large rough oval leaves.', 'Gray-brown bark.', 'Tiny flowers packed in heads.', 'Round yellow fruit with edible pulp.',
   'medium', 12, 20, 6, 10,
   'moderate', True, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('a37c524a-7fba-5234-841f-b4ac8f21d7dc', 'Anubing', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'a37c524a-7fba-5234-841f-b4ac8f21d7dc', id, 'possible' FROM purposes WHERE slug = 'fruit-bearing'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'a37c524a-7fba-5234-841f-b4ac8f21d7dc', id, 'suitable' FROM purposes WHERE slug = 'wildlife-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'a37c524a-7fba-5234-841f-b4ac8f21d7dc', id, 'suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a37c524a-7fba-5234-841f-b4ac8f21d7dc', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a37c524a-7fba-5234-841f-b4ac8f21d7dc', id, 'suitable' FROM planting_conditions WHERE slug = 'partial-shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a37c524a-7fba-5234-841f-b4ac8f21d7dc', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a37c524a-7fba-5234-841f-b4ac8f21d7dc', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a37c524a-7fba-5234-841f-b4ac8f21d7dc', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a37c524a-7fba-5234-841f-b4ac8f21d7dc', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a37c524a-7fba-5234-841f-b4ac8f21d7dc', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a37c524a-7fba-5234-841f-b4ac8f21d7dc', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a37c524a-7fba-5234-841f-b4ac8f21d7dc', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a37c524a-7fba-5234-841f-b4ac8f21d7dc', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a37c524a-7fba-5234-841f-b4ac8f21d7dc', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a37c524a-7fba-5234-841f-b4ac8f21d7dc', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('a37c524a-7fba-5234-841f-b4ac8f21d7dc', 'Luzon', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('a37c524a-7fba-5234-841f-b4ac8f21d7dc', 'Visayas', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('a37c524a-7fba-5234-841f-b4ac8f21d7dc', 'Mindanao', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('a37c524a-7fba-5234-841f-b4ac8f21d7dc', 'Anubing sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('4fc14c84-a6c3-57fc-b6b9-bc12f4755881', 'Artocarpus odoratissimus', 'Artocarpus', 'odoratissimus', 'Moraceae', 'native',
   'Marang bears large sweet-smelling fruit and grows well in Mindanao farms. SAMPLE RECORD.', 'Very large lobed rough leaves.', 'Gray bark.', 'Small clustered flowers.', 'Large spiny sweet fruit.',
   'medium', 12, 20, 8, 12,
   'moderate', True, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('4fc14c84-a6c3-57fc-b6b9-bc12f4755881', 'Marang', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '4fc14c84-a6c3-57fc-b6b9-bc12f4755881', id, 'highly_suitable' FROM purposes WHERE slug = 'fruit-bearing'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '4fc14c84-a6c3-57fc-b6b9-bc12f4755881', id, 'suitable' FROM purposes WHERE slug = 'agroforestry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '4fc14c84-a6c3-57fc-b6b9-bc12f4755881', id, 'possible' FROM purposes WHERE slug = 'shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '4fc14c84-a6c3-57fc-b6b9-bc12f4755881', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '4fc14c84-a6c3-57fc-b6b9-bc12f4755881', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '4fc14c84-a6c3-57fc-b6b9-bc12f4755881', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '4fc14c84-a6c3-57fc-b6b9-bc12f4755881', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '4fc14c84-a6c3-57fc-b6b9-bc12f4755881', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '4fc14c84-a6c3-57fc-b6b9-bc12f4755881', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '4fc14c84-a6c3-57fc-b6b9-bc12f4755881', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '4fc14c84-a6c3-57fc-b6b9-bc12f4755881', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moist'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '4fc14c84-a6c3-57fc-b6b9-bc12f4755881', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '4fc14c84-a6c3-57fc-b6b9-bc12f4755881', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '4fc14c84-a6c3-57fc-b6b9-bc12f4755881', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('4fc14c84-a6c3-57fc-b6b9-bc12f4755881', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('4fc14c84-a6c3-57fc-b6b9-bc12f4755881', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('4fc14c84-a6c3-57fc-b6b9-bc12f4755881', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('4fc14c84-a6c3-57fc-b6b9-bc12f4755881', 'Marang sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('6fc17dd8-03f1-51d0-887f-75dd26187be3', 'Artocarpus blancoi', 'Artocarpus', 'blancoi', 'Moraceae', 'endemic',
   'Antipolo is an endemic tree named after the city, with large fruit. SAMPLE RECORD.', 'Huge rough leaves.', 'Dark gray bark.', 'Clustered small flowers.', 'Large round greenish fruit.',
   'medium', 10, 20, 6, 12,
   'moderate', True, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('6fc17dd8-03f1-51d0-887f-75dd26187be3', 'Antipolo', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '6fc17dd8-03f1-51d0-887f-75dd26187be3', id, 'possible' FROM purposes WHERE slug = 'fruit-bearing'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '6fc17dd8-03f1-51d0-887f-75dd26187be3', id, 'suitable' FROM purposes WHERE slug = 'wildlife-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '6fc17dd8-03f1-51d0-887f-75dd26187be3', id, 'suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '6fc17dd8-03f1-51d0-887f-75dd26187be3', id, 'possible' FROM purposes WHERE slug = 'shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6fc17dd8-03f1-51d0-887f-75dd26187be3', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6fc17dd8-03f1-51d0-887f-75dd26187be3', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6fc17dd8-03f1-51d0-887f-75dd26187be3', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6fc17dd8-03f1-51d0-887f-75dd26187be3', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6fc17dd8-03f1-51d0-887f-75dd26187be3', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6fc17dd8-03f1-51d0-887f-75dd26187be3', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6fc17dd8-03f1-51d0-887f-75dd26187be3', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6fc17dd8-03f1-51d0-887f-75dd26187be3', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6fc17dd8-03f1-51d0-887f-75dd26187be3', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6fc17dd8-03f1-51d0-887f-75dd26187be3', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6fc17dd8-03f1-51d0-887f-75dd26187be3', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6fc17dd8-03f1-51d0-887f-75dd26187be3', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('6fc17dd8-03f1-51d0-887f-75dd26187be3', 'Luzon', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('6fc17dd8-03f1-51d0-887f-75dd26187be3', 'Visayas', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('6fc17dd8-03f1-51d0-887f-75dd26187be3', 'Mindanao', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('6fc17dd8-03f1-51d0-887f-75dd26187be3', 'Antipolo sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('38f95d53-30f3-501b-b9b6-ca2e38109b2d', 'Ficus nota', 'Ficus', 'nota', 'Moraceae', 'native',
   'Tibig is a common native fig whose fruit feeds many birds and bats. SAMPLE RECORD.', 'Oval sandpapery leaves.', 'Gray-brown bark.', 'Tiny flowers hidden inside figs.', 'Clusters of small round figs on the trunk.',
   'small', 6, 12, 4, 8,
   'fast', True, False, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('38f95d53-30f3-501b-b9b6-ca2e38109b2d', 'Tibig', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'highly_suitable' FROM purposes WHERE slug = 'wildlife-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'possible' FROM purposes WHERE slug = 'riverbank-riparian-rehabilitation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'suitable' FROM planting_conditions WHERE slug = 'partial-shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'suitable' FROM planting_conditions WHERE slug = 'riverbank'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'suitable' FROM planting_conditions WHERE slug = 'watershed'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'suitable' FROM planting_conditions WHERE slug = 'moist-soil'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moist'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'suitable' FROM planting_conditions WHERE slug = 'space-small'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('38f95d53-30f3-501b-b9b6-ca2e38109b2d', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('38f95d53-30f3-501b-b9b6-ca2e38109b2d', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('38f95d53-30f3-501b-b9b6-ca2e38109b2d', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('38f95d53-30f3-501b-b9b6-ca2e38109b2d', 'Tibig sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', 'Ficus septica', 'Ficus', 'septica', 'Moraceae', 'native',
   'Hauili is a fast native fig of open and riverside areas. SAMPLE RECORD.', 'Oval leaves with a pointed drip tip.', 'Smooth gray bark.', 'Hidden fig flowers.', 'Small figs ripening yellow to red.',
   'small', 5, 12, 4, 8,
   'fast', True, False, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', 'Hauili', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', 'Hauili', 'common', FALSE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', id, 'highly_suitable' FROM purposes WHERE slug = 'wildlife-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', id, 'suitable' FROM purposes WHERE slug = 'riverbank-riparian-rehabilitation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', id, 'possible' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', id, 'suitable' FROM planting_conditions WHERE slug = 'riverbank'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', id, 'suitable' FROM planting_conditions WHERE slug = 'watershed'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', id, 'suitable' FROM planting_conditions WHERE slug = 'moist-soil'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moist'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', id, 'suitable' FROM planting_conditions WHERE slug = 'space-small'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', 'Hauili sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('872fc8e7-eb84-5acf-84af-8880da705352', 'Ficus benjamina', 'Ficus', 'benjamina', 'Moraceae', 'native',
   'Balete is the familiar strangling fig of parks and old plazas. SAMPLE RECORD.', 'Small glossy drooping leaves.', 'Smooth gray bark, often with aerial roots.', 'Hidden fig flowers.', 'Small round figs.',
   'large', 15, 30, 10, 20,
   'moderate', False, False, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('872fc8e7-eb84-5acf-84af-8880da705352', 'Balete', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('872fc8e7-eb84-5acf-84af-8880da705352', 'Weeping fig', 'alternative', FALSE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '872fc8e7-eb84-5acf-84af-8880da705352', id, 'highly_suitable' FROM purposes WHERE slug = 'shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '872fc8e7-eb84-5acf-84af-8880da705352', id, 'highly_suitable' FROM purposes WHERE slug = 'urban-landscaping'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '872fc8e7-eb84-5acf-84af-8880da705352', id, 'suitable' FROM purposes WHERE slug = 'wildlife-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '872fc8e7-eb84-5acf-84af-8880da705352', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '872fc8e7-eb84-5acf-84af-8880da705352', id, 'suitable' FROM planting_conditions WHERE slug = 'partial-shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '872fc8e7-eb84-5acf-84af-8880da705352', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '872fc8e7-eb84-5acf-84af-8880da705352', id, 'suitable' FROM planting_conditions WHERE slug = 'urban-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '872fc8e7-eb84-5acf-84af-8880da705352', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '872fc8e7-eb84-5acf-84af-8880da705352', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '872fc8e7-eb84-5acf-84af-8880da705352', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '872fc8e7-eb84-5acf-84af-8880da705352', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '872fc8e7-eb84-5acf-84af-8880da705352', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '872fc8e7-eb84-5acf-84af-8880da705352', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '872fc8e7-eb84-5acf-84af-8880da705352', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '872fc8e7-eb84-5acf-84af-8880da705352', id, 'suitable' FROM planting_conditions WHERE slug = 'space-very-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('872fc8e7-eb84-5acf-84af-8880da705352', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('872fc8e7-eb84-5acf-84af-8880da705352', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('872fc8e7-eb84-5acf-84af-8880da705352', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('872fc8e7-eb84-5acf-84af-8880da705352', 'Balete sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('85a82216-df72-5683-9234-e0cb31b5d627', 'Ficus ulmifolia', 'Ficus', 'ulmifolia', 'Moraceae', 'endemic',
   'Is-is is an endemic fig with sandpapery leaves once used for polishing wood. SAMPLE RECORD.', 'Rough elm-like leaves.', 'Gray bark.', 'Hidden fig flowers.', 'Small hairy figs.',
   'small', 5, 10, 3, 6,
   'moderate', True, False, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('85a82216-df72-5683-9234-e0cb31b5d627', 'Is-is', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '85a82216-df72-5683-9234-e0cb31b5d627', id, 'suitable' FROM purposes WHERE slug = 'wildlife-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '85a82216-df72-5683-9234-e0cb31b5d627', id, 'possible' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '85a82216-df72-5683-9234-e0cb31b5d627', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '85a82216-df72-5683-9234-e0cb31b5d627', id, 'suitable' FROM planting_conditions WHERE slug = 'partial-shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '85a82216-df72-5683-9234-e0cb31b5d627', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '85a82216-df72-5683-9234-e0cb31b5d627', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '85a82216-df72-5683-9234-e0cb31b5d627', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '85a82216-df72-5683-9234-e0cb31b5d627', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '85a82216-df72-5683-9234-e0cb31b5d627', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '85a82216-df72-5683-9234-e0cb31b5d627', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '85a82216-df72-5683-9234-e0cb31b5d627', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '85a82216-df72-5683-9234-e0cb31b5d627', id, 'suitable' FROM planting_conditions WHERE slug = 'space-small'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '85a82216-df72-5683-9234-e0cb31b5d627', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('85a82216-df72-5683-9234-e0cb31b5d627', 'Luzon', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('85a82216-df72-5683-9234-e0cb31b5d627', 'Visayas', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('85a82216-df72-5683-9234-e0cb31b5d627', 'Mindanao', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('85a82216-df72-5683-9234-e0cb31b5d627', 'Is-is sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('bdd66a95-52e5-5b31-9349-a9c48d309c57', 'Pongamia pinnata', 'Pongamia', 'pinnata', 'Fabaceae', 'native',
   'Bani is a coastal legume tree whose seeds yield oil. SAMPLE RECORD.', 'Glossy compound leaves.', 'Gray-brown cracked bark.', 'Fragrant white-pink pea flowers.', 'Flat woody pods with oily seeds.',
   'medium', 10, 18, 6, 10,
   'fast', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('bdd66a95-52e5-5b31-9349-a9c48d309c57', 'Bani', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'bdd66a95-52e5-5b31-9349-a9c48d309c57', id, 'highly_suitable' FROM purposes WHERE slug = 'coastal-rehabilitation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'bdd66a95-52e5-5b31-9349-a9c48d309c57', id, 'suitable' FROM purposes WHERE slug = 'windbreak'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'bdd66a95-52e5-5b31-9349-a9c48d309c57', id, 'possible' FROM purposes WHERE slug = 'agroforestry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bdd66a95-52e5-5b31-9349-a9c48d309c57', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bdd66a95-52e5-5b31-9349-a9c48d309c57', id, 'suitable' FROM planting_conditions WHERE slug = 'coastal-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bdd66a95-52e5-5b31-9349-a9c48d309c57', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bdd66a95-52e5-5b31-9349-a9c48d309c57', id, 'suitable' FROM planting_conditions WHERE slug = 'sandy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bdd66a95-52e5-5b31-9349-a9c48d309c57', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bdd66a95-52e5-5b31-9349-a9c48d309c57', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bdd66a95-52e5-5b31-9349-a9c48d309c57', id, 'suitable' FROM planting_conditions WHERE slug = 'dry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bdd66a95-52e5-5b31-9349-a9c48d309c57', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bdd66a95-52e5-5b31-9349-a9c48d309c57', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bdd66a95-52e5-5b31-9349-a9c48d309c57', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bdd66a95-52e5-5b31-9349-a9c48d309c57', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('bdd66a95-52e5-5b31-9349-a9c48d309c57', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('bdd66a95-52e5-5b31-9349-a9c48d309c57', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('bdd66a95-52e5-5b31-9349-a9c48d309c57', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('bdd66a95-52e5-5b31-9349-a9c48d309c57', 'Bani sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', 'Barringtonia asiatica', 'Barringtonia', 'asiatica', 'Lecythidaceae', 'native',
   'Botong lines tropical beaches with big showy night flowers and floating fruit. SAMPLE RECORD.', 'Very large glossy leaves in rosettes.', 'Gray-brown fissured bark.', 'Large white-pink powder-puff night flowers.', 'Large square buoyant fruit dispersed by sea.',
   'medium', 10, 20, 8, 14,
   'moderate', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', 'Botong', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', id, 'highly_suitable' FROM purposes WHERE slug = 'coastal-rehabilitation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', id, 'suitable' FROM purposes WHERE slug = 'urban-landscaping'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', id, 'suitable' FROM purposes WHERE slug = 'shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', id, 'suitable' FROM planting_conditions WHERE slug = 'coastal-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', id, 'suitable' FROM planting_conditions WHERE slug = 'urban-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', id, 'suitable' FROM planting_conditions WHERE slug = 'sandy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', 'Botong sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('2bfb7c26-6503-54e4-b945-b9a1e66d4d54', 'Barringtonia racemosa', 'Barringtonia', 'racemosa', 'Lecythidaceae', 'native',
   'Putat favors riverbanks and back-mangroves with hanging flower spikes. SAMPLE RECORD.', 'Large oval leaves clustered at twig ends.', 'Dark gray bark.', 'Long hanging spikes of pink-white flowers.', 'Oval ribbed fruit.',
   'small', 8, 15, 5, 9,
   'moderate', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('2bfb7c26-6503-54e4-b945-b9a1e66d4d54', 'Putat', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '2bfb7c26-6503-54e4-b945-b9a1e66d4d54', id, 'highly_suitable' FROM purposes WHERE slug = 'riverbank-riparian-rehabilitation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '2bfb7c26-6503-54e4-b945-b9a1e66d4d54', id, 'possible' FROM purposes WHERE slug = 'coastal-rehabilitation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '2bfb7c26-6503-54e4-b945-b9a1e66d4d54', id, 'possible' FROM purposes WHERE slug = 'wildlife-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2bfb7c26-6503-54e4-b945-b9a1e66d4d54', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2bfb7c26-6503-54e4-b945-b9a1e66d4d54', id, 'suitable' FROM planting_conditions WHERE slug = 'partial-shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2bfb7c26-6503-54e4-b945-b9a1e66d4d54', id, 'suitable' FROM planting_conditions WHERE slug = 'riverbank'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2bfb7c26-6503-54e4-b945-b9a1e66d4d54', id, 'suitable' FROM planting_conditions WHERE slug = 'watershed'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2bfb7c26-6503-54e4-b945-b9a1e66d4d54', id, 'suitable' FROM planting_conditions WHERE slug = 'coastal-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2bfb7c26-6503-54e4-b945-b9a1e66d4d54', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2bfb7c26-6503-54e4-b945-b9a1e66d4d54', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2bfb7c26-6503-54e4-b945-b9a1e66d4d54', id, 'suitable' FROM planting_conditions WHERE slug = 'moist-soil'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2bfb7c26-6503-54e4-b945-b9a1e66d4d54', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moist'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2bfb7c26-6503-54e4-b945-b9a1e66d4d54', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2bfb7c26-6503-54e4-b945-b9a1e66d4d54', id, 'suitable' FROM planting_conditions WHERE slug = 'space-small'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2bfb7c26-6503-54e4-b945-b9a1e66d4d54', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('2bfb7c26-6503-54e4-b945-b9a1e66d4d54', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('2bfb7c26-6503-54e4-b945-b9a1e66d4d54', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('2bfb7c26-6503-54e4-b945-b9a1e66d4d54', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('2bfb7c26-6503-54e4-b945-b9a1e66d4d54', 'Putat sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('7b5c3803-772f-57b4-948a-364f377903a2', 'Hibiscus tiliaceus', 'Hibiscus', 'tiliaceus', 'Malvaceae', 'native',
   'Malubago is a spreading coastal tree with color-changing hibiscus flowers. SAMPLE RECORD.', 'Heart-shaped leaves, silvery beneath.', 'Gray-brown bark.', 'Yellow flowers turning orange-red through the day.', 'Round dry capsules.',
   'small', 6, 12, 5, 9,
   'fast', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('7b5c3803-772f-57b4-948a-364f377903a2', 'Malubago', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('7b5c3803-772f-57b4-948a-364f377903a2', 'Sea hibiscus', 'alternative', FALSE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '7b5c3803-772f-57b4-948a-364f377903a2', id, 'highly_suitable' FROM purposes WHERE slug = 'coastal-rehabilitation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '7b5c3803-772f-57b4-948a-364f377903a2', id, 'suitable' FROM purposes WHERE slug = 'urban-landscaping'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '7b5c3803-772f-57b4-948a-364f377903a2', id, 'possible' FROM purposes WHERE slug = 'windbreak'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '7b5c3803-772f-57b4-948a-364f377903a2', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '7b5c3803-772f-57b4-948a-364f377903a2', id, 'suitable' FROM planting_conditions WHERE slug = 'coastal-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '7b5c3803-772f-57b4-948a-364f377903a2', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '7b5c3803-772f-57b4-948a-364f377903a2', id, 'suitable' FROM planting_conditions WHERE slug = 'urban-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '7b5c3803-772f-57b4-948a-364f377903a2', id, 'suitable' FROM planting_conditions WHERE slug = 'riverbank'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '7b5c3803-772f-57b4-948a-364f377903a2', id, 'suitable' FROM planting_conditions WHERE slug = 'sandy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '7b5c3803-772f-57b4-948a-364f377903a2', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '7b5c3803-772f-57b4-948a-364f377903a2', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '7b5c3803-772f-57b4-948a-364f377903a2', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '7b5c3803-772f-57b4-948a-364f377903a2', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '7b5c3803-772f-57b4-948a-364f377903a2', id, 'suitable' FROM planting_conditions WHERE slug = 'space-small'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '7b5c3803-772f-57b4-948a-364f377903a2', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('7b5c3803-772f-57b4-948a-364f377903a2', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('7b5c3803-772f-57b4-948a-364f377903a2', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('7b5c3803-772f-57b4-948a-364f377903a2', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('7b5c3803-772f-57b4-948a-364f377903a2', 'Malubago sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('f0931658-a038-55f3-a1de-500a0d9039b7', 'Erythrina variegata', 'Erythrina', 'variegata', 'Fabaceae', 'native',
   'Dapdap bursts into red-orange bloom and fixes nitrogen in poor soils. SAMPLE RECORD.', 'Broad three-part leaves.', 'Gray bark with small prickles.', 'Dense clusters of red-orange flowers.', 'Dark pods with red seeds.',
   'medium', 10, 18, 6, 12,
   'fast', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('f0931658-a038-55f3-a1de-500a0d9039b7', 'Dapdap', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('f0931658-a038-55f3-a1de-500a0d9039b7', 'Indian coral tree', 'alternative', FALSE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM purposes WHERE slug = 'flowering-ornamental'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM purposes WHERE slug = 'agroforestry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'possible' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'possible' FROM purposes WHERE slug = 'urban-landscaping'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM planting_conditions WHERE slug = 'urban-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM planting_conditions WHERE slug = 'coastal-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM planting_conditions WHERE slug = 'sandy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM planting_conditions WHERE slug = 'dry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('f0931658-a038-55f3-a1de-500a0d9039b7', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('f0931658-a038-55f3-a1de-500a0d9039b7', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('f0931658-a038-55f3-a1de-500a0d9039b7', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('f0931658-a038-55f3-a1de-500a0d9039b7', 'Dapdap sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('27879c2c-6b93-5929-9565-974041a81573', 'Polyscias nodosa', 'Polyscias', 'nodosa', 'Araliaceae', 'native',
   'Malapapaya is a quick pioneer tree with large ferny foliage. SAMPLE RECORD.', 'Very large divided leaves.', 'Pale smooth bark.', 'Small greenish flower clusters.', 'Small dark berries.',
   'small', 6, 12, 3, 6,
   'fast', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('27879c2c-6b93-5929-9565-974041a81573', 'Malapapaya', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '27879c2c-6b93-5929-9565-974041a81573', id, 'suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '27879c2c-6b93-5929-9565-974041a81573', id, 'possible' FROM purposes WHERE slug = 'urban-landscaping'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '27879c2c-6b93-5929-9565-974041a81573', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '27879c2c-6b93-5929-9565-974041a81573', id, 'suitable' FROM planting_conditions WHERE slug = 'partial-shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '27879c2c-6b93-5929-9565-974041a81573', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '27879c2c-6b93-5929-9565-974041a81573', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '27879c2c-6b93-5929-9565-974041a81573', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '27879c2c-6b93-5929-9565-974041a81573', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '27879c2c-6b93-5929-9565-974041a81573', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '27879c2c-6b93-5929-9565-974041a81573', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '27879c2c-6b93-5929-9565-974041a81573', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '27879c2c-6b93-5929-9565-974041a81573', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '27879c2c-6b93-5929-9565-974041a81573', id, 'suitable' FROM planting_conditions WHERE slug = 'space-small'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '27879c2c-6b93-5929-9565-974041a81573', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('27879c2c-6b93-5929-9565-974041a81573', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('27879c2c-6b93-5929-9565-974041a81573', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('27879c2c-6b93-5929-9565-974041a81573', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('27879c2c-6b93-5929-9565-974041a81573', 'Malapapaya sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('ae99e068-db4d-5afd-88b2-a3d5d578aac7', 'Macaranga tanarius', 'Macaranga', 'tanarius', 'Euphorbiaceae', 'native',
   'Takip-asin is a classic pioneer with round peltate leaves. SAMPLE RECORD.', 'Round shield-like leaves on long stalks.', 'Smooth gray bark.', 'Small yellowish flower spikes.', 'Small spiny capsules.',
   'small', 5, 10, 3, 6,
   'fast', False, False, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('ae99e068-db4d-5afd-88b2-a3d5d578aac7', 'Takip-asin', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'ae99e068-db4d-5afd-88b2-a3d5d578aac7', id, 'suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'ae99e068-db4d-5afd-88b2-a3d5d578aac7', id, 'possible' FROM purposes WHERE slug = 'soil-erosion-control'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ae99e068-db4d-5afd-88b2-a3d5d578aac7', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ae99e068-db4d-5afd-88b2-a3d5d578aac7', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ae99e068-db4d-5afd-88b2-a3d5d578aac7', id, 'suitable' FROM planting_conditions WHERE slug = 'hillside'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ae99e068-db4d-5afd-88b2-a3d5d578aac7', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ae99e068-db4d-5afd-88b2-a3d5d578aac7', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ae99e068-db4d-5afd-88b2-a3d5d578aac7', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ae99e068-db4d-5afd-88b2-a3d5d578aac7', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ae99e068-db4d-5afd-88b2-a3d5d578aac7', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ae99e068-db4d-5afd-88b2-a3d5d578aac7', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ae99e068-db4d-5afd-88b2-a3d5d578aac7', id, 'suitable' FROM planting_conditions WHERE slug = 'space-small'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ae99e068-db4d-5afd-88b2-a3d5d578aac7', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('ae99e068-db4d-5afd-88b2-a3d5d578aac7', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('ae99e068-db4d-5afd-88b2-a3d5d578aac7', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('ae99e068-db4d-5afd-88b2-a3d5d578aac7', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('ae99e068-db4d-5afd-88b2-a3d5d578aac7', 'Takip-asin sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', 'Broussonetia luzonica', 'Broussonetia', 'luzonica', 'Moraceae', 'endemic',
   'Himbabao is an endemic tree whose young leaves are cooked as a vegetable. SAMPLE RECORD.', 'Rough variable-shaped leaves.', 'Gray-brown bark.', 'Small separate male and female flower balls.', 'Orange-red bumpy aggregate fruit.',
   'small', 6, 12, 4, 8,
   'fast', True, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', 'Himbabao', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', id, 'possible' FROM purposes WHERE slug = 'fruit-bearing'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', id, 'possible' FROM purposes WHERE slug = 'agroforestry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', id, 'possible' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', id, 'suitable' FROM planting_conditions WHERE slug = 'partial-shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', id, 'suitable' FROM planting_conditions WHERE slug = 'space-small'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', 'Luzon', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', 'Visayas', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', 'Mindanao', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('ace3a2f6-5a72-52a2-baaa-2b5b95d8caec', 'Himbabao sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('949939f0-0e09-5ef1-a413-fb320e525a32', 'Premna odorata', 'Premna', 'odorata', 'Lamiaceae', 'native',
   'Alagaw is a fragrant native shrub-tree used in traditional teas. SAMPLE RECORD.', 'Oval aromatic leaves.', 'Pale flaky bark.', 'Small fragrant white flower clusters.', 'Small dark berries.',
   'small', 4, 8, 3, 5,
   'moderate', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('949939f0-0e09-5ef1-a413-fb320e525a32', 'Alagaw', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '949939f0-0e09-5ef1-a413-fb320e525a32', id, 'suitable' FROM purposes WHERE slug = 'pollinator-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '949939f0-0e09-5ef1-a413-fb320e525a32', id, 'possible' FROM purposes WHERE slug = 'wildlife-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '949939f0-0e09-5ef1-a413-fb320e525a32', id, 'possible' FROM purposes WHERE slug = 'urban-landscaping'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '949939f0-0e09-5ef1-a413-fb320e525a32', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '949939f0-0e09-5ef1-a413-fb320e525a32', id, 'suitable' FROM planting_conditions WHERE slug = 'partial-shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '949939f0-0e09-5ef1-a413-fb320e525a32', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '949939f0-0e09-5ef1-a413-fb320e525a32', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '949939f0-0e09-5ef1-a413-fb320e525a32', id, 'suitable' FROM planting_conditions WHERE slug = 'urban-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '949939f0-0e09-5ef1-a413-fb320e525a32', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '949939f0-0e09-5ef1-a413-fb320e525a32', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '949939f0-0e09-5ef1-a413-fb320e525a32', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '949939f0-0e09-5ef1-a413-fb320e525a32', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '949939f0-0e09-5ef1-a413-fb320e525a32', id, 'suitable' FROM planting_conditions WHERE slug = 'space-small'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('949939f0-0e09-5ef1-a413-fb320e525a32', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('949939f0-0e09-5ef1-a413-fb320e525a32', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('949939f0-0e09-5ef1-a413-fb320e525a32', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('949939f0-0e09-5ef1-a413-fb320e525a32', 'Alagaw sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('6b377db7-9d74-57e4-a8b8-692f82b5684b', 'Dracontomelon edule', 'Dracontomelon', 'edule', 'Anacardiaceae', 'endemic',
   'Uas is a rare endemic relative of Dao with edible fruit. SAMPLE RECORD.', 'Compound leaves with pointed leaflets.', 'Gray bark.', 'Small greenish flowers.', 'Small round edible fruit.',
   'medium', 12, 20, 6, 10,
   'moderate', True, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('6b377db7-9d74-57e4-a8b8-692f82b5684b', 'Uas', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '6b377db7-9d74-57e4-a8b8-692f82b5684b', id, 'possible' FROM purposes WHERE slug = 'fruit-bearing'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '6b377db7-9d74-57e4-a8b8-692f82b5684b', id, 'suitable' FROM purposes WHERE slug = 'wildlife-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '6b377db7-9d74-57e4-a8b8-692f82b5684b', id, 'possible' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6b377db7-9d74-57e4-a8b8-692f82b5684b', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6b377db7-9d74-57e4-a8b8-692f82b5684b', id, 'suitable' FROM planting_conditions WHERE slug = 'partial-shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6b377db7-9d74-57e4-a8b8-692f82b5684b', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6b377db7-9d74-57e4-a8b8-692f82b5684b', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6b377db7-9d74-57e4-a8b8-692f82b5684b', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6b377db7-9d74-57e4-a8b8-692f82b5684b', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6b377db7-9d74-57e4-a8b8-692f82b5684b', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6b377db7-9d74-57e4-a8b8-692f82b5684b', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6b377db7-9d74-57e4-a8b8-692f82b5684b', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6b377db7-9d74-57e4-a8b8-692f82b5684b', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6b377db7-9d74-57e4-a8b8-692f82b5684b', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('6b377db7-9d74-57e4-a8b8-692f82b5684b', 'Luzon', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('6b377db7-9d74-57e4-a8b8-692f82b5684b', 'Visayas', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('6b377db7-9d74-57e4-a8b8-692f82b5684b', 'Mindanao', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('6b377db7-9d74-57e4-a8b8-692f82b5684b', 'Uas sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('c84df45b-6fb8-5adc-95b7-057f142f8349', 'Koordersiodendron pinnatum', 'Koordersiodendron', 'pinnatum', 'Anacardiaceae', 'native',
   'Amugis is a sturdy native timber tree of lowland forests. SAMPLE RECORD.', 'Long compound leaves.', 'Dark fissured bark.', 'Small reddish flower clusters.', 'Small dry nutlets.',
   'large', 20, 35, 10, 16,
   'slow', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('c84df45b-6fb8-5adc-95b7-057f142f8349', 'Amugis', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'c84df45b-6fb8-5adc-95b7-057f142f8349', id, 'suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'c84df45b-6fb8-5adc-95b7-057f142f8349', id, 'possible' FROM purposes WHERE slug = 'carbon-storage'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'c84df45b-6fb8-5adc-95b7-057f142f8349', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'c84df45b-6fb8-5adc-95b7-057f142f8349', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'c84df45b-6fb8-5adc-95b7-057f142f8349', id, 'suitable' FROM planting_conditions WHERE slug = 'watershed'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'c84df45b-6fb8-5adc-95b7-057f142f8349', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'c84df45b-6fb8-5adc-95b7-057f142f8349', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'c84df45b-6fb8-5adc-95b7-057f142f8349', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'c84df45b-6fb8-5adc-95b7-057f142f8349', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'c84df45b-6fb8-5adc-95b7-057f142f8349', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'c84df45b-6fb8-5adc-95b7-057f142f8349', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'c84df45b-6fb8-5adc-95b7-057f142f8349', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'c84df45b-6fb8-5adc-95b7-057f142f8349', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'c84df45b-6fb8-5adc-95b7-057f142f8349', id, 'suitable' FROM planting_conditions WHERE slug = 'space-very-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('c84df45b-6fb8-5adc-95b7-057f142f8349', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('c84df45b-6fb8-5adc-95b7-057f142f8349', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('c84df45b-6fb8-5adc-95b7-057f142f8349', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('c84df45b-6fb8-5adc-95b7-057f142f8349', 'Amugis sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('2645fce7-559c-546f-b165-1dbdacaf9b03', 'Garcinia binucao', 'Garcinia', 'binucao', 'Clusiaceae', 'endemic',
   'Batuan bears very sour round fruit used in Visayan cooking. SAMPLE RECORD.', 'Thick glossy opposite leaves.', 'Dark brown bark.', 'Small yellowish flowers.', 'Round yellow sour fruit.',
   'small', 6, 12, 4, 8,
   'slow', True, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('2645fce7-559c-546f-b165-1dbdacaf9b03', 'Batuan', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '2645fce7-559c-546f-b165-1dbdacaf9b03', id, 'suitable' FROM purposes WHERE slug = 'fruit-bearing'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '2645fce7-559c-546f-b165-1dbdacaf9b03', id, 'possible' FROM purposes WHERE slug = 'agroforestry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2645fce7-559c-546f-b165-1dbdacaf9b03', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2645fce7-559c-546f-b165-1dbdacaf9b03', id, 'suitable' FROM planting_conditions WHERE slug = 'partial-shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2645fce7-559c-546f-b165-1dbdacaf9b03', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2645fce7-559c-546f-b165-1dbdacaf9b03', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2645fce7-559c-546f-b165-1dbdacaf9b03', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2645fce7-559c-546f-b165-1dbdacaf9b03', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2645fce7-559c-546f-b165-1dbdacaf9b03', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2645fce7-559c-546f-b165-1dbdacaf9b03', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moist'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2645fce7-559c-546f-b165-1dbdacaf9b03', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2645fce7-559c-546f-b165-1dbdacaf9b03', id, 'suitable' FROM planting_conditions WHERE slug = 'space-small'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '2645fce7-559c-546f-b165-1dbdacaf9b03', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('2645fce7-559c-546f-b165-1dbdacaf9b03', 'Luzon', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('2645fce7-559c-546f-b165-1dbdacaf9b03', 'Visayas', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('2645fce7-559c-546f-b165-1dbdacaf9b03', 'Mindanao', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('2645fce7-559c-546f-b165-1dbdacaf9b03', 'Batuan sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('6a834637-4cc5-58b5-bf1a-44760a504c82', 'Antidesma bunius', 'Antidesma', 'bunius', 'Phyllanthaceae', 'native',
   'Bignay produces hanging clusters of dark juicy berries for wine and juice. SAMPLE RECORD.', 'Oval glossy leaves.', 'Gray-brown bark.', 'Tiny flowers in long spikes.', 'Long strands of red-to-black berries.',
   'small', 5, 12, 3, 7,
   'moderate', True, False, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('6a834637-4cc5-58b5-bf1a-44760a504c82', 'Bignay', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '6a834637-4cc5-58b5-bf1a-44760a504c82', id, 'highly_suitable' FROM purposes WHERE slug = 'fruit-bearing'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '6a834637-4cc5-58b5-bf1a-44760a504c82', id, 'suitable' FROM purposes WHERE slug = 'wildlife-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '6a834637-4cc5-58b5-bf1a-44760a504c82', id, 'possible' FROM purposes WHERE slug = 'agroforestry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6a834637-4cc5-58b5-bf1a-44760a504c82', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6a834637-4cc5-58b5-bf1a-44760a504c82', id, 'suitable' FROM planting_conditions WHERE slug = 'partial-shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6a834637-4cc5-58b5-bf1a-44760a504c82', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6a834637-4cc5-58b5-bf1a-44760a504c82', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6a834637-4cc5-58b5-bf1a-44760a504c82', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6a834637-4cc5-58b5-bf1a-44760a504c82', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6a834637-4cc5-58b5-bf1a-44760a504c82', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6a834637-4cc5-58b5-bf1a-44760a504c82', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6a834637-4cc5-58b5-bf1a-44760a504c82', id, 'suitable' FROM planting_conditions WHERE slug = 'space-small'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6a834637-4cc5-58b5-bf1a-44760a504c82', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('6a834637-4cc5-58b5-bf1a-44760a504c82', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('6a834637-4cc5-58b5-bf1a-44760a504c82', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('6a834637-4cc5-58b5-bf1a-44760a504c82', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('6a834637-4cc5-58b5-bf1a-44760a504c82', 'Bignay sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', 'Artocarpus camansi', 'Artocarpus', 'camansi', 'Moraceae', 'native',
   'Kamansi bears seeded breadfruit-like heads, a traditional famine food. SAMPLE RECORD.', 'Deeply lobed rough leaves.', 'Gray bark.', 'Small clustered flowers.', 'Large green heads full of edible seeds.',
   'medium', 12, 20, 8, 12,
   'moderate', True, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', 'Kamansi', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', 'Breadnut', 'alternative', FALSE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', id, 'highly_suitable' FROM purposes WHERE slug = 'fruit-bearing'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', id, 'suitable' FROM purposes WHERE slug = 'agroforestry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', id, 'possible' FROM purposes WHERE slug = 'shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moist'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', 'Kamansi sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('acf88856-009a-5a58-ae48-5508e67df8b9', 'Aleurites moluccana', 'Aleurites', 'moluccana', 'Euphorbiaceae', 'native',
   'Lumbang is a spreading tree whose oily nuts once lit homes. SAMPLE RECORD.', 'Large three-lobed pale leaves.', 'Gray smooth bark.', 'Small white flower clusters.', 'Hard-shelled oily nuts.',
   'medium', 12, 20, 8, 14,
   'fast', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('acf88856-009a-5a58-ae48-5508e67df8b9', 'Lumbang', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('acf88856-009a-5a58-ae48-5508e67df8b9', 'Candlenut', 'alternative', FALSE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'suitable' FROM purposes WHERE slug = 'shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'possible' FROM purposes WHERE slug = 'agroforestry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'possible' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'suitable' FROM planting_conditions WHERE slug = 'dry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', id, 'suitable' FROM planting_conditions WHERE slug = 'space-very-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('acf88856-009a-5a58-ae48-5508e67df8b9', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('acf88856-009a-5a58-ae48-5508e67df8b9', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('acf88856-009a-5a58-ae48-5508e67df8b9', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('acf88856-009a-5a58-ae48-5508e67df8b9', 'Lumbang sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('aa63cd06-6a92-5ae1-8fd4-34fab335d090', 'Bischofia javanica', 'Bischofia', 'javanica', 'Phyllanthaceae', 'native',
   'Tuai is a tough native tree with red young leaves, good for watersheds. SAMPLE RECORD.', 'Three-part leaves flushing bright red.', 'Dark gray fissured bark.', 'Small greenish flowers.', 'Small dark berries.',
   'large', 15, 30, 8, 14,
   'moderate', False, False, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('aa63cd06-6a92-5ae1-8fd4-34fab335d090', 'Tuai', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'suitable' FROM purposes WHERE slug = 'watershed-rehabilitation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'possible' FROM purposes WHERE slug = 'shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'suitable' FROM planting_conditions WHERE slug = 'watershed'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'suitable' FROM planting_conditions WHERE slug = 'riverbank'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'suitable' FROM planting_conditions WHERE slug = 'moist-soil'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moist'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', id, 'suitable' FROM planting_conditions WHERE slug = 'space-very-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('aa63cd06-6a92-5ae1-8fd4-34fab335d090', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('aa63cd06-6a92-5ae1-8fd4-34fab335d090', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('aa63cd06-6a92-5ae1-8fd4-34fab335d090', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('aa63cd06-6a92-5ae1-8fd4-34fab335d090', 'Tuai sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('67ee09fd-a511-54e8-a5f7-00bd2bcc0928', 'Cordia dichotoma', 'Cordia', 'dichotoma', 'Boraginaceae', 'native',
   'Anonang yields sticky edible fruit and fine shade. SAMPLE RECORD.', 'Broad oval alternate leaves.', 'Gray-brown bark.', 'Small white fragrant flowers.', 'Sticky yellowish edible drupes.',
   'medium', 10, 18, 6, 10,
   'moderate', True, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('67ee09fd-a511-54e8-a5f7-00bd2bcc0928', 'Anonang', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', id, 'possible' FROM purposes WHERE slug = 'fruit-bearing'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', id, 'suitable' FROM purposes WHERE slug = 'shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', id, 'possible' FROM purposes WHERE slug = 'wildlife-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', id, 'suitable' FROM planting_conditions WHERE slug = 'urban-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', id, 'suitable' FROM planting_conditions WHERE slug = 'dry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('67ee09fd-a511-54e8-a5f7-00bd2bcc0928', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('67ee09fd-a511-54e8-a5f7-00bd2bcc0928', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('67ee09fd-a511-54e8-a5f7-00bd2bcc0928', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('67ee09fd-a511-54e8-a5f7-00bd2bcc0928', 'Anonang sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('da39c447-b13a-52b6-bead-f3b22b271931', 'Cratoxylum sumatranum', 'Cratoxylum', 'sumatranum', 'Hypericaceae', 'native',
   'Salingbobog colors open slopes with pink new leaves and yellow flowers. SAMPLE RECORD.', 'Small opposite leaves flushing pink.', 'Pale flaky bark.', 'Small yellow fragrant flowers.', 'Small capsules.',
   'small', 8, 15, 4, 8,
   'moderate', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('da39c447-b13a-52b6-bead-f3b22b271931', 'Salingbobog', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', id, 'suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', id, 'possible' FROM purposes WHERE slug = 'flowering-ornamental'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', id, 'possible' FROM purposes WHERE slug = 'slope-rehabilitation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', id, 'suitable' FROM planting_conditions WHERE slug = 'hillside'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', id, 'suitable' FROM planting_conditions WHERE slug = 'rocky'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', id, 'suitable' FROM planting_conditions WHERE slug = 'dry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', id, 'suitable' FROM planting_conditions WHERE slug = 'space-small'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('da39c447-b13a-52b6-bead-f3b22b271931', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('da39c447-b13a-52b6-bead-f3b22b271931', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('da39c447-b13a-52b6-bead-f3b22b271931', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('da39c447-b13a-52b6-bead-f3b22b271931', 'Salingbobog sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('6289acf8-fa32-58eb-8fdd-d613d1eec08a', 'Pittosporum pentandrum', 'Pittosporum', 'pentandrum', 'Pittosporaceae', 'native',
   'Mamalis is a fragrant-flowered native tree of forest edges. SAMPLE RECORD.', 'Narrow glossy leaves in whorls.', 'Dark gray bark.', 'Sweet-scented white bell flowers.', 'Small orange capsules.',
   'small', 5, 10, 3, 6,
   'moderate', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('6289acf8-fa32-58eb-8fdd-d613d1eec08a', 'Mamalis', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '6289acf8-fa32-58eb-8fdd-d613d1eec08a', id, 'suitable' FROM purposes WHERE slug = 'pollinator-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '6289acf8-fa32-58eb-8fdd-d613d1eec08a', id, 'possible' FROM purposes WHERE slug = 'urban-landscaping'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '6289acf8-fa32-58eb-8fdd-d613d1eec08a', id, 'possible' FROM purposes WHERE slug = 'flowering-ornamental'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6289acf8-fa32-58eb-8fdd-d613d1eec08a', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6289acf8-fa32-58eb-8fdd-d613d1eec08a', id, 'suitable' FROM planting_conditions WHERE slug = 'partial-shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6289acf8-fa32-58eb-8fdd-d613d1eec08a', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6289acf8-fa32-58eb-8fdd-d613d1eec08a', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6289acf8-fa32-58eb-8fdd-d613d1eec08a', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6289acf8-fa32-58eb-8fdd-d613d1eec08a', id, 'suitable' FROM planting_conditions WHERE slug = 'urban-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6289acf8-fa32-58eb-8fdd-d613d1eec08a', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6289acf8-fa32-58eb-8fdd-d613d1eec08a', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6289acf8-fa32-58eb-8fdd-d613d1eec08a', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6289acf8-fa32-58eb-8fdd-d613d1eec08a', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6289acf8-fa32-58eb-8fdd-d613d1eec08a', id, 'suitable' FROM planting_conditions WHERE slug = 'space-small'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '6289acf8-fa32-58eb-8fdd-d613d1eec08a', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('6289acf8-fa32-58eb-8fdd-d613d1eec08a', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('6289acf8-fa32-58eb-8fdd-d613d1eec08a', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('6289acf8-fa32-58eb-8fdd-d613d1eec08a', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('6289acf8-fa32-58eb-8fdd-d613d1eec08a', 'Mamalis sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('60d8e024-1534-569c-947e-d362a4bb0c48', 'Thespesia populnea', 'Thespesia', 'populnea', 'Malvaceae', 'native',
   'Banalo is a classic beach tree with hibiscus-like yellow flowers. SAMPLE RECORD.', 'Heart-shaped glossy leaves.', 'Gray-brown fissured bark.', 'Yellow hibiscus flowers aging to maroon.', 'Round flattened capsules.',
   'medium', 8, 15, 6, 10,
   'moderate', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('60d8e024-1534-569c-947e-d362a4bb0c48', 'Banalo', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('60d8e024-1534-569c-947e-d362a4bb0c48', 'Portia tree', 'alternative', FALSE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '60d8e024-1534-569c-947e-d362a4bb0c48', id, 'highly_suitable' FROM purposes WHERE slug = 'coastal-rehabilitation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '60d8e024-1534-569c-947e-d362a4bb0c48', id, 'suitable' FROM purposes WHERE slug = 'shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '60d8e024-1534-569c-947e-d362a4bb0c48', id, 'suitable' FROM purposes WHERE slug = 'urban-landscaping'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '60d8e024-1534-569c-947e-d362a4bb0c48', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '60d8e024-1534-569c-947e-d362a4bb0c48', id, 'suitable' FROM planting_conditions WHERE slug = 'coastal-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '60d8e024-1534-569c-947e-d362a4bb0c48', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '60d8e024-1534-569c-947e-d362a4bb0c48', id, 'suitable' FROM planting_conditions WHERE slug = 'urban-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '60d8e024-1534-569c-947e-d362a4bb0c48', id, 'suitable' FROM planting_conditions WHERE slug = 'sandy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '60d8e024-1534-569c-947e-d362a4bb0c48', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '60d8e024-1534-569c-947e-d362a4bb0c48', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '60d8e024-1534-569c-947e-d362a4bb0c48', id, 'suitable' FROM planting_conditions WHERE slug = 'dry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '60d8e024-1534-569c-947e-d362a4bb0c48', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '60d8e024-1534-569c-947e-d362a4bb0c48', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '60d8e024-1534-569c-947e-d362a4bb0c48', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '60d8e024-1534-569c-947e-d362a4bb0c48', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('60d8e024-1534-569c-947e-d362a4bb0c48', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('60d8e024-1534-569c-947e-d362a4bb0c48', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('60d8e024-1534-569c-947e-d362a4bb0c48', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('60d8e024-1534-569c-947e-d362a4bb0c48', 'Banalo sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('e15808d8-caed-5d5e-b641-af6206be1314', 'Cassia javanica', 'Cassia', 'javanica', 'Fabaceae', 'native',
   'Balayong paints streets pink and is famed as the Palawan cherry. SAMPLE RECORD.', 'Feathery compound leaves.', 'Gray smooth bark.', 'Showy pink-white flower clusters.', 'Long cylindrical pods.',
   'medium', 10, 18, 8, 12,
   'moderate', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('e15808d8-caed-5d5e-b641-af6206be1314', 'Balayong', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('e15808d8-caed-5d5e-b641-af6206be1314', 'Java cassia', 'alternative', FALSE)
ON CONFLICT DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('e15808d8-caed-5d5e-b641-af6206be1314', 'Palawan cherry', 'alternative', FALSE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', id, 'highly_suitable' FROM purposes WHERE slug = 'flowering-ornamental'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', id, 'highly_suitable' FROM purposes WHERE slug = 'urban-landscaping'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', id, 'possible' FROM purposes WHERE slug = 'shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', id, 'suitable' FROM planting_conditions WHERE slug = 'urban-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', id, 'suitable' FROM planting_conditions WHERE slug = 'dry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('e15808d8-caed-5d5e-b641-af6206be1314', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('e15808d8-caed-5d5e-b641-af6206be1314', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('e15808d8-caed-5d5e-b641-af6206be1314', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('e15808d8-caed-5d5e-b641-af6206be1314', 'Balayong sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('ea6fbff0-7860-583b-9e2f-4364c6e93c52', 'Peltophorum pterocarpum', 'Peltophorum', 'pterocarpum', 'Fabaceae', 'native',
   'Siar is a fast deciduous tree with golden bloom, common in avenues. SAMPLE RECORD.', 'Feathery twice-compound leaves.', 'Gray-brown bark.', 'Bright yellow flower sprays.', 'Flat coppery pods.',
   'medium', 12, 20, 8, 14,
   'fast', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('ea6fbff0-7860-583b-9e2f-4364c6e93c52', 'Siar', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('ea6fbff0-7860-583b-9e2f-4364c6e93c52', 'Copperpod', 'alternative', FALSE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'suitable' FROM purposes WHERE slug = 'urban-landscaping'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'possible' FROM purposes WHERE slug = 'flowering-ornamental'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'possible' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'possible' FROM purposes WHERE slug = 'shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'suitable' FROM planting_conditions WHERE slug = 'urban-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'suitable' FROM planting_conditions WHERE slug = 'dry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('ea6fbff0-7860-583b-9e2f-4364c6e93c52', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('ea6fbff0-7860-583b-9e2f-4364c6e93c52', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('ea6fbff0-7860-583b-9e2f-4364c6e93c52', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('ea6fbff0-7860-583b-9e2f-4364c6e93c52', 'Siar sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('1aebf139-4b7d-5191-bda9-0ab43e7261fb', 'Madhuca betis', 'Madhuca', 'betis', 'Sapotaceae', 'endemic',
   'Betis is a slow endemic hardwood with sweet edible flowers. SAMPLE RECORD.', 'Clustered oblong glossy leaves.', 'Dark fissured bark.', 'Creamy fragrant drooping flowers.', 'Oval fleshy fruit.',
   'medium', 12, 20, 6, 10,
   'slow', True, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('1aebf139-4b7d-5191-bda9-0ab43e7261fb', 'Betis', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', id, 'possible' FROM purposes WHERE slug = 'fruit-bearing'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', id, 'suitable' FROM purposes WHERE slug = 'wildlife-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', id, 'possible' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', id, 'suitable' FROM planting_conditions WHERE slug = 'partial-shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('1aebf139-4b7d-5191-bda9-0ab43e7261fb', 'Luzon', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('1aebf139-4b7d-5191-bda9-0ab43e7261fb', 'Visayas', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('1aebf139-4b7d-5191-bda9-0ab43e7261fb', 'Mindanao', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('1aebf139-4b7d-5191-bda9-0ab43e7261fb', 'Betis sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('bb7fc5b5-f60a-5061-bd01-9063309d21cd', 'Canarium asperum', 'Canarium', 'asperum', 'Burseraceae', 'native',
   'Pagsahingin is a resinous native tree related to Pili. SAMPLE RECORD.', 'Compound rough-textured leaves.', 'Gray bark with resin.', 'Small greenish flowers.', 'Small dark oval fruit.',
   'medium', 12, 22, 6, 12,
   'moderate', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('bb7fc5b5-f60a-5061-bd01-9063309d21cd', 'Pagsahingin', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'bb7fc5b5-f60a-5061-bd01-9063309d21cd', id, 'suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'bb7fc5b5-f60a-5061-bd01-9063309d21cd', id, 'possible' FROM purposes WHERE slug = 'wildlife-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bb7fc5b5-f60a-5061-bd01-9063309d21cd', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bb7fc5b5-f60a-5061-bd01-9063309d21cd', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bb7fc5b5-f60a-5061-bd01-9063309d21cd', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bb7fc5b5-f60a-5061-bd01-9063309d21cd', id, 'suitable' FROM planting_conditions WHERE slug = 'watershed'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bb7fc5b5-f60a-5061-bd01-9063309d21cd', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bb7fc5b5-f60a-5061-bd01-9063309d21cd', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bb7fc5b5-f60a-5061-bd01-9063309d21cd', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bb7fc5b5-f60a-5061-bd01-9063309d21cd', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bb7fc5b5-f60a-5061-bd01-9063309d21cd', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bb7fc5b5-f60a-5061-bd01-9063309d21cd', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bb7fc5b5-f60a-5061-bd01-9063309d21cd', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bb7fc5b5-f60a-5061-bd01-9063309d21cd', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'bb7fc5b5-f60a-5061-bd01-9063309d21cd', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('bb7fc5b5-f60a-5061-bd01-9063309d21cd', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('bb7fc5b5-f60a-5061-bd01-9063309d21cd', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('bb7fc5b5-f60a-5061-bd01-9063309d21cd', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('bb7fc5b5-f60a-5061-bd01-9063309d21cd', 'Pagsahingin sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('02197e71-56ae-573d-8b2f-2c37a30d37d0', 'Sandoricum vidalii', 'Sandoricum', 'vidalii', 'Meliaceae', 'endemic',
   'Malasantol is an endemic wild relative of santol with tart fruit. SAMPLE RECORD.', 'Large three-part leaves.', 'Gray-brown bark.', 'Small yellow-green flowers.', 'Round yellowish sour fruit.',
   'medium', 10, 18, 6, 10,
   'moderate', True, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('02197e71-56ae-573d-8b2f-2c37a30d37d0', 'Malasantol', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '02197e71-56ae-573d-8b2f-2c37a30d37d0', id, 'suitable' FROM purposes WHERE slug = 'fruit-bearing'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '02197e71-56ae-573d-8b2f-2c37a30d37d0', id, 'possible' FROM purposes WHERE slug = 'wildlife-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '02197e71-56ae-573d-8b2f-2c37a30d37d0', id, 'possible' FROM purposes WHERE slug = 'agroforestry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '02197e71-56ae-573d-8b2f-2c37a30d37d0', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '02197e71-56ae-573d-8b2f-2c37a30d37d0', id, 'suitable' FROM planting_conditions WHERE slug = 'partial-shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '02197e71-56ae-573d-8b2f-2c37a30d37d0', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '02197e71-56ae-573d-8b2f-2c37a30d37d0', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '02197e71-56ae-573d-8b2f-2c37a30d37d0', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '02197e71-56ae-573d-8b2f-2c37a30d37d0', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '02197e71-56ae-573d-8b2f-2c37a30d37d0', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '02197e71-56ae-573d-8b2f-2c37a30d37d0', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '02197e71-56ae-573d-8b2f-2c37a30d37d0', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '02197e71-56ae-573d-8b2f-2c37a30d37d0', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '02197e71-56ae-573d-8b2f-2c37a30d37d0', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '02197e71-56ae-573d-8b2f-2c37a30d37d0', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('02197e71-56ae-573d-8b2f-2c37a30d37d0', 'Luzon', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('02197e71-56ae-573d-8b2f-2c37a30d37d0', 'Visayas', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('02197e71-56ae-573d-8b2f-2c37a30d37d0', 'Mindanao', 'endemic')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('02197e71-56ae-573d-8b2f-2c37a30d37d0', 'Malasantol sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('05e23588-5a24-54da-927e-26aa1f249cb4', 'Spondias pinnata', 'Spondias', 'pinnata', 'Anacardiaceae', 'native',
   'Libas gives sour leaves and fruit prized in Filipino cooking. SAMPLE RECORD.', 'Compound leaves with toothed leaflets.', 'Gray-brown bark.', 'Small white-green flowers.', 'Oval yellow-green sour fruit.',
   'medium', 10, 18, 6, 10,
   'fast', True, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('05e23588-5a24-54da-927e-26aa1f249cb4', 'Libas', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '05e23588-5a24-54da-927e-26aa1f249cb4', id, 'suitable' FROM purposes WHERE slug = 'fruit-bearing'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '05e23588-5a24-54da-927e-26aa1f249cb4', id, 'possible' FROM purposes WHERE slug = 'agroforestry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '05e23588-5a24-54da-927e-26aa1f249cb4', id, 'possible' FROM purposes WHERE slug = 'shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '05e23588-5a24-54da-927e-26aa1f249cb4', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '05e23588-5a24-54da-927e-26aa1f249cb4', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '05e23588-5a24-54da-927e-26aa1f249cb4', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '05e23588-5a24-54da-927e-26aa1f249cb4', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '05e23588-5a24-54da-927e-26aa1f249cb4', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '05e23588-5a24-54da-927e-26aa1f249cb4', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '05e23588-5a24-54da-927e-26aa1f249cb4', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '05e23588-5a24-54da-927e-26aa1f249cb4', id, 'suitable' FROM planting_conditions WHERE slug = 'dry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '05e23588-5a24-54da-927e-26aa1f249cb4', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '05e23588-5a24-54da-927e-26aa1f249cb4', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '05e23588-5a24-54da-927e-26aa1f249cb4', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '05e23588-5a24-54da-927e-26aa1f249cb4', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('05e23588-5a24-54da-927e-26aa1f249cb4', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('05e23588-5a24-54da-927e-26aa1f249cb4', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('05e23588-5a24-54da-927e-26aa1f249cb4', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('05e23588-5a24-54da-927e-26aa1f249cb4', 'Libas sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('5e808aba-8086-5d1f-abdd-c7392d31f536', 'Adenanthera pavonina', 'Adenanthera', 'pavonina', 'Fabaceae', 'native',
   'Tanglin bears shiny red seeds long used for beads and shade planting. SAMPLE RECORD.', 'Feathery twice-compound leaves.', 'Gray-brown bark.', 'Creamy bottlebrush flower spikes.', 'Curled pods with scarlet seeds.',
   'medium', 12, 20, 8, 12,
   'fast', False, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('5e808aba-8086-5d1f-abdd-c7392d31f536', 'Tanglin', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('5e808aba-8086-5d1f-abdd-c7392d31f536', 'Red bead tree', 'alternative', FALSE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'suitable' FROM purposes WHERE slug = 'shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'possible' FROM purposes WHERE slug = 'urban-landscaping'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'possible' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'suitable' FROM planting_conditions WHERE slug = 'backyard'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'suitable' FROM planting_conditions WHERE slug = 'urban-area'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'suitable' FROM planting_conditions WHERE slug = 'dry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('5e808aba-8086-5d1f-abdd-c7392d31f536', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('5e808aba-8086-5d1f-abdd-c7392d31f536', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('5e808aba-8086-5d1f-abdd-c7392d31f536', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('5e808aba-8086-5d1f-abdd-c7392d31f536', 'Tanglin sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('aeb07d9d-715e-5f87-8910-f038b6cc0e25', 'Parkia timoriana', 'Parkia', 'timoriana', 'Fabaceae', 'native',
   'Kupang is a tall native legume with edible flower buds and pods. SAMPLE RECORD.', 'Very fine feathery leaves.', 'Gray-brown bark.', 'Creamy ball-shaped flower heads.', 'Long flat pods with edible seeds.',
   'large', 15, 30, 10, 16,
   'fast', True, True, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('aeb07d9d-715e-5f87-8910-f038b6cc0e25', 'Kupang', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'possible' FROM purposes WHERE slug = 'fruit-bearing'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'suitable' FROM purposes WHERE slug = 'agroforestry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'possible' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'possible' FROM purposes WHERE slug = 'shade'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'suitable' FROM planting_conditions WHERE slug = 'large-property'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moist'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'suitable' FROM planting_conditions WHERE slug = 'mid-elevation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'suitable' FROM planting_conditions WHERE slug = 'space-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', id, 'suitable' FROM planting_conditions WHERE slug = 'space-very-large'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('aeb07d9d-715e-5f87-8910-f038b6cc0e25', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('aeb07d9d-715e-5f87-8910-f038b6cc0e25', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('aeb07d9d-715e-5f87-8910-f038b6cc0e25', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('aeb07d9d-715e-5f87-8910-f038b6cc0e25', 'Kupang sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;

INSERT INTO species (id, scientific_name, genus, species_epithet, family, native_status,
  description, leaf_description, bark_description, flower_description, fruit_description,
  growth_form, min_height_m, max_height_m, min_canopy_m, max_canopy_m,
  growth_rate, fruit_bearing, flowering, verification_status) VALUES
  ('b734fc23-ddb9-5158-8ad5-f9bccf37f16d', 'Trema orientalis', 'Trema', 'orientalis', 'Cannabaceae', 'native',
   'Anabiong is a fast pioneer tree whose small fruit feeds many birds. SAMPLE RECORD.', 'Rough sandpapery oval leaves.', 'Gray-brown bark.', 'Small greenish flower clusters.', 'Tiny dark berries in clusters.',
   'small', 5, 12, 3, 7,
   'fast', True, False, 'verified')
ON CONFLICT (scientific_name) DO NOTHING;

INSERT INTO species_names (species_id, name, name_type, is_primary) VALUES
  ('b734fc23-ddb9-5158-8ad5-f9bccf37f16d', 'Anabiong', 'common', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', id, 'highly_suitable' FROM purposes WHERE slug = 'wildlife-support'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', id, 'suitable' FROM purposes WHERE slug = 'reforestation'
  ON CONFLICT DO NOTHING;

INSERT INTO species_purposes (species_id, purpose_id, suitability)
  SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', id, 'possible' FROM purposes WHERE slug = 'soil-erosion-control'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', id, 'suitable' FROM planting_conditions WHERE slug = 'full-sun'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', id, 'suitable' FROM planting_conditions WHERE slug = 'open-field'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', id, 'suitable' FROM planting_conditions WHERE slug = 'hillside'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', id, 'suitable' FROM planting_conditions WHERE slug = 'farm'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', id, 'suitable' FROM planting_conditions WHERE slug = 'forest-edge'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', id, 'suitable' FROM planting_conditions WHERE slug = 'loamy'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', id, 'suitable' FROM planting_conditions WHERE slug = 'clay'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', id, 'suitable' FROM planting_conditions WHERE slug = 'well-drained'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', id, 'suitable' FROM planting_conditions WHERE slug = 'dry'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', id, 'suitable' FROM planting_conditions WHERE slug = 'moisture-moderate'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', id, 'suitable' FROM planting_conditions WHERE slug = 'lowland'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', id, 'suitable' FROM planting_conditions WHERE slug = 'space-small'
  ON CONFLICT DO NOTHING;

INSERT INTO species_planting_conditions (species_id, condition_id, suitability)
  SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', id, 'suitable' FROM planting_conditions WHERE slug = 'space-medium'
  ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('b734fc23-ddb9-5158-8ad5-f9bccf37f16d', 'Luzon', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('b734fc23-ddb9-5158-8ad5-f9bccf37f16d', 'Visayas', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_distribution (species_id, island_group, distribution_type) VALUES
  ('b734fc23-ddb9-5158-8ad5-f9bccf37f16d', 'Mindanao', 'native')
ON CONFLICT DO NOTHING;

INSERT INTO species_references (species_id, title, source_type, notes) VALUES
  ('b734fc23-ddb9-5158-8ad5-f9bccf37f16d', 'Anabiong sample record', 'field_guide', 'Sample seed record for MVP testing — replace with curated reference before beta.')
ON CONFLICT DO NOTHING;
