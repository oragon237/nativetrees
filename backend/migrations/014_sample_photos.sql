-- 014_sample_photos.sql — sample gallery rows matching backend/uploads/.
-- Idempotent (WHERE NOT EXISTS on file_url). Sample data: replace
-- with community photos before public launch.

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '00916ba8-1ff7-56f8-9dd9-8ba73e129fb2', '/uploads/species/00916ba8-1ff7-56f8-9dd9-8ba73e129fb2/supa.jpg', 'whole_tree', 'Sample photo via Wikipedia (Sindora supa). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/00916ba8-1ff7-56f8-9dd9-8ba73e129fb2/supa.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '02197e71-56ae-573d-8b2f-2c37a30d37d0', '/uploads/species/02197e71-56ae-573d-8b2f-2c37a30d37d0/malasantol.jpg', 'whole_tree', 'Sample photo via Wikipedia (Sandoricum vidalii). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/02197e71-56ae-573d-8b2f-2c37a30d37d0/malasantol.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '05e23588-5a24-54da-927e-26aa1f249cb4', '/uploads/species/05e23588-5a24-54da-927e-26aa1f249cb4/libas.jpg', 'whole_tree', 'Sample photo via Wikipedia (Spondias pinnata). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/05e23588-5a24-54da-927e-26aa1f249cb4/libas.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '0a8a9e9b-3807-58fe-803c-5627d8bc8d1a', '/uploads/species/0a8a9e9b-3807-58fe-803c-5627d8bc8d1a/hauili.jpg', 'whole_tree', 'Sample photo via Wikipedia (Ficus septica). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/0a8a9e9b-3807-58fe-803c-5627d8bc8d1a/hauili.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '11111111-1111-1111-1111-111111111111', '/uploads/species/11111111-1111-1111-1111-111111111111/narra.jpg', 'whole_tree', 'Sample photo via Wikipedia (Pterocarpus indicus). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/11111111-1111-1111-1111-111111111111/narra.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '12345678-1234-1234-1234-123456789012', '/uploads/species/12345678-1234-1234-1234-123456789012/malabulak.jpg', 'whole_tree', 'Sample photo via Wikipedia (Bombax ceiba). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/12345678-1234-1234-1234-123456789012/malabulak.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '1aebf139-4b7d-5191-bda9-0ab43e7261fb', '/uploads/species/1aebf139-4b7d-5191-bda9-0ab43e7261fb/betis.jpg', 'whole_tree', 'Sample photo via Wikipedia (Madhuca betis). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/1aebf139-4b7d-5191-bda9-0ab43e7261fb/betis.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '1ea97872-b798-581f-9557-525ddf93660f', '/uploads/species/1ea97872-b798-581f-9557-525ddf93660f/kalantas.jpg', 'whole_tree', 'Sample photo via Wikipedia (Toona calantas). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/1ea97872-b798-581f-9557-525ddf93660f/kalantas.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '22222222-2222-2222-2222-222222222222', '/uploads/species/22222222-2222-2222-2222-222222222222/molave.jpg', 'whole_tree', 'Sample photo via Wikipedia (Vitex parviflora). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/22222222-2222-2222-2222-222222222222/molave.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b', '/uploads/species/26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b/yakal.jpg', 'whole_tree', 'Sample photo via Wikipedia (Shorea astylosa). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/26c7c1fb-65f4-5ac5-bb84-71675a9e3c1b/yakal.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '2bfb7c26-6503-54e4-b945-b9a1e66d4d54', '/uploads/species/2bfb7c26-6503-54e4-b945-b9a1e66d4d54/putat.jpg', 'whole_tree', 'Sample photo via Wikipedia (Barringtonia racemosa). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/2bfb7c26-6503-54e4-b945-b9a1e66d4d54/putat.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '33333333-3333-3333-3333-333333333333', '/uploads/species/33333333-3333-3333-3333-333333333333/banaba.jpg', 'whole_tree', 'Sample photo via Wikipedia (Lagerstroemia speciosa). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/33333333-3333-3333-3333-333333333333/banaba.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '38f95d53-30f3-501b-b9b6-ca2e38109b2d', '/uploads/species/38f95d53-30f3-501b-b9b6-ca2e38109b2d/tibig.jpg', 'whole_tree', 'Sample photo via Wikipedia (Ficus nota). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/38f95d53-30f3-501b-b9b6-ca2e38109b2d/tibig.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '44444444-4444-4444-4444-444444444444', '/uploads/species/44444444-4444-4444-4444-444444444444/kamagong.jpg', 'whole_tree', 'Sample photo via Wikipedia (Diospyros blancoi). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/44444444-4444-4444-4444-444444444444/kamagong.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '49240a8a-04f3-5b45-ac7a-abeb82d7848e', '/uploads/species/49240a8a-04f3-5b45-ac7a-abeb82d7848e/tindalo.jpg', 'whole_tree', 'Sample photo via Wikipedia (Afzelia rhomboidea). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/49240a8a-04f3-5b45-ac7a-abeb82d7848e/tindalo.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '4fc14c84-a6c3-57fc-b6b9-bc12f4755881', '/uploads/species/4fc14c84-a6c3-57fc-b6b9-bc12f4755881/marang.jpg', 'whole_tree', 'Sample photo via Wikipedia (Artocarpus odoratissimus). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/4fc14c84-a6c3-57fc-b6b9-bc12f4755881/marang.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '55555555-5555-5555-5555-555555555555', '/uploads/species/55555555-5555-5555-5555-555555555555/ipil.jpg', 'whole_tree', 'Sample photo via Wikipedia (Intsia bijuga). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/55555555-5555-5555-5555-555555555555/ipil.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '583d2121-61ec-53d6-bac5-86a232b490f6', '/uploads/species/583d2121-61ec-53d6-bac5-86a232b490f6/apitong.jpg', 'whole_tree', 'Sample photo via Wikipedia (Dipterocarpus grandiflorus). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/583d2121-61ec-53d6-bac5-86a232b490f6/apitong.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '5e808aba-8086-5d1f-abdd-c7392d31f536', '/uploads/species/5e808aba-8086-5d1f-abdd-c7392d31f536/tanglin.jpg', 'whole_tree', 'Sample photo via Wikipedia (Adenanthera pavonina). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/5e808aba-8086-5d1f-abdd-c7392d31f536/tanglin.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '60d8e024-1534-569c-947e-d362a4bb0c48', '/uploads/species/60d8e024-1534-569c-947e-d362a4bb0c48/banalo.jpg', 'whole_tree', 'Sample photo via Wikipedia (Thespesia populnea). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/60d8e024-1534-569c-947e-d362a4bb0c48/banalo.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '6289acf8-fa32-58eb-8fdd-d613d1eec08a', '/uploads/species/6289acf8-fa32-58eb-8fdd-d613d1eec08a/mamalis.jpg', 'whole_tree', 'Sample photo via Wikipedia (Pittosporum pentandrum). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/6289acf8-fa32-58eb-8fdd-d613d1eec08a/mamalis.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '66666666-6666-6666-6666-666666666666', '/uploads/species/66666666-6666-6666-6666-666666666666/talisay.jpg', 'whole_tree', 'Sample photo via Wikipedia (Terminalia catappa). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/66666666-6666-6666-6666-666666666666/talisay.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '67ee09fd-a511-54e8-a5f7-00bd2bcc0928', '/uploads/species/67ee09fd-a511-54e8-a5f7-00bd2bcc0928/anonang.jpg', 'whole_tree', 'Sample photo via Wikipedia (Cordia dichotoma). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/67ee09fd-a511-54e8-a5f7-00bd2bcc0928/anonang.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '6a834637-4cc5-58b5-bf1a-44760a504c82', '/uploads/species/6a834637-4cc5-58b5-bf1a-44760a504c82/bignay.jpg', 'whole_tree', 'Sample photo via Wikipedia (Antidesma bunius). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/6a834637-4cc5-58b5-bf1a-44760a504c82/bignay.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '6b377db7-9d74-57e4-a8b8-692f82b5684b', '/uploads/species/6b377db7-9d74-57e4-a8b8-692f82b5684b/uas.jpg', 'whole_tree', 'Sample photo via Wikipedia (Dracontomelon edule). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/6b377db7-9d74-57e4-a8b8-692f82b5684b/uas.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '77777777-7777-7777-7777-777777777777', '/uploads/species/77777777-7777-7777-7777-777777777777/agoho.jpg', 'whole_tree', 'Sample photo via Wikipedia (Casuarina equisetifolia). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/77777777-7777-7777-7777-777777777777/agoho.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '7b5c3803-772f-57b4-948a-364f377903a2', '/uploads/species/7b5c3803-772f-57b4-948a-364f377903a2/malubago.jpg', 'whole_tree', 'Sample photo via Wikipedia (Hibiscus tiliaceus). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/7b5c3803-772f-57b4-948a-364f377903a2/malubago.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '85a82216-df72-5683-9234-e0cb31b5d627', '/uploads/species/85a82216-df72-5683-9234-e0cb31b5d627/isis.jpg', 'whole_tree', 'Sample photo via Wikipedia (Ficus ulmifolia). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/85a82216-df72-5683-9234-e0cb31b5d627/isis.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '872fc8e7-eb84-5acf-84af-8880da705352', '/uploads/species/872fc8e7-eb84-5acf-84af-8880da705352/balete.jpg', 'whole_tree', 'Sample photo via Wikipedia (Ficus benjamina). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/872fc8e7-eb84-5acf-84af-8880da705352/balete.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '88888888-8888-8888-8888-888888888888', '/uploads/species/88888888-8888-8888-8888-888888888888/bitaog.jpg', 'whole_tree', 'Sample photo via Wikipedia (Calophyllum inophyllum). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/88888888-8888-8888-8888-888888888888/bitaog.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2', '/uploads/species/8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2/kamansi.jpg', 'whole_tree', 'Sample photo via Wikipedia (Artocarpus camansi). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/8a748a9d-7a40-57c7-9a0d-dd0644a6f1b2/kamansi.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '9042b73a-fd82-5c28-afc8-b85874d87a2d', '/uploads/species/9042b73a-fd82-5c28-afc8-b85874d87a2d/batino.jpg', 'whole_tree', 'Sample photo via Wikipedia (Alstonia macrophylla). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/9042b73a-fd82-5c28-afc8-b85874d87a2d/batino.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '949939f0-0e09-5ef1-a413-fb320e525a32', '/uploads/species/949939f0-0e09-5ef1-a413-fb320e525a32/alagaw.jpg', 'whole_tree', 'Sample photo via Wikipedia (Premna odorata). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/949939f0-0e09-5ef1-a413-fb320e525a32/alagaw.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '99999999-9999-9999-9999-999999999999', '/uploads/species/99999999-9999-9999-9999-999999999999/bagras.jpg', 'whole_tree', 'Sample photo via Wikipedia (Eucalyptus deglupta). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/99999999-9999-9999-9999-999999999999/bagras.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a', '/uploads/species/a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a/botong.jpg', 'whole_tree', 'Sample photo via Wikipedia (Barringtonia asiatica). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/a1c4148a-df9d-54e8-8c07-fab8fb3e4b9a/botong.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'a2c481fb-4436-5ce0-a0c3-ebc494d9eab8', '/uploads/species/a2c481fb-4436-5ce0-a0c3-ebc494d9eab8/bagtikan.jpg', 'whole_tree', 'Sample photo via Wikipedia (Parashorea malaanonan). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/a2c481fb-4436-5ce0-a0c3-ebc494d9eab8/bagtikan.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'a2f59121-838f-5f02-ba84-315ab1d1043a', '/uploads/species/a2f59121-838f-5f02-ba84-315ab1d1043a/lanete.jpg', 'whole_tree', 'Sample photo via Wikipedia (Wrightia pubescens). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/a2f59121-838f-5f02-ba84-315ab1d1043a/lanete.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'aa531a38-4170-5d1c-9d76-7e395ed9d5e2', '/uploads/species/aa531a38-4170-5d1c-9d76-7e395ed9d5e2/tanguile.jpg', 'whole_tree', 'Sample photo via Wikipedia (Shorea polysperma). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/aa531a38-4170-5d1c-9d76-7e395ed9d5e2/tanguile.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'aa63cd06-6a92-5ae1-8fd4-34fab335d090', '/uploads/species/aa63cd06-6a92-5ae1-8fd4-34fab335d090/tuai.jpg', 'whole_tree', 'Sample photo via Wikipedia (Bischofia javanica). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/aa63cd06-6a92-5ae1-8fd4-34fab335d090/tuai.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '/uploads/species/aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/dao.jpg', 'whole_tree', 'Sample photo via Wikipedia (Dracontomelon dao). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/dao.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'acf88856-009a-5a58-ae48-5508e67df8b9', '/uploads/species/acf88856-009a-5a58-ae48-5508e67df8b9/lumbang.jpg', 'whole_tree', 'Sample photo via Wikipedia (Aleurites moluccana). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/acf88856-009a-5a58-ae48-5508e67df8b9/lumbang.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'ae99e068-db4d-5afd-88b2-a3d5d578aac7', '/uploads/species/ae99e068-db4d-5afd-88b2-a3d5d578aac7/takipasin.jpg', 'whole_tree', 'Sample photo via Wikipedia (Macaranga tanarius). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/ae99e068-db4d-5afd-88b2-a3d5d578aac7/takipasin.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'aeb07d9d-715e-5f87-8910-f038b6cc0e25', '/uploads/species/aeb07d9d-715e-5f87-8910-f038b6cc0e25/kupang.jpg', 'whole_tree', 'Sample photo via Wikipedia (Parkia timoriana). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/aeb07d9d-715e-5f87-8910-f038b6cc0e25/kupang.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'b734fc23-ddb9-5158-8ad5-f9bccf37f16d', '/uploads/species/b734fc23-ddb9-5158-8ad5-f9bccf37f16d/anabiong.jpg', 'whole_tree', 'Sample photo via Wikipedia (Trema orientalis). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/b734fc23-ddb9-5158-8ad5-f9bccf37f16d/anabiong.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'bb7fc5b5-f60a-5061-bd01-9063309d21cd', '/uploads/species/bb7fc5b5-f60a-5061-bd01-9063309d21cd/pagsahingin.jpg', 'whole_tree', 'Sample photo via Wikipedia (Canarium asperum). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/bb7fc5b5-f60a-5061-bd01-9063309d21cd/pagsahingin.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '/uploads/species/bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb/pili.jpg', 'whole_tree', 'Sample photo via Wikipedia (Canarium ovatum). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb/pili.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'bdd66a95-52e5-5b31-9349-a9c48d309c57', '/uploads/species/bdd66a95-52e5-5b31-9349-a9c48d309c57/bani.jpg', 'whole_tree', 'Sample photo via Wikipedia (Pongamia pinnata). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/bdd66a95-52e5-5b31-9349-a9c48d309c57/bani.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'c84df45b-6fb8-5adc-95b7-057f142f8349', '/uploads/species/c84df45b-6fb8-5adc-95b7-057f142f8349/amugis.jpg', 'whole_tree', 'Sample photo via Wikipedia (Koordersiodendron pinnatum). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/c84df45b-6fb8-5adc-95b7-057f142f8349/amugis.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'cccccccc-cccc-cccc-cccc-cccccccccccc', '/uploads/species/cccccccc-cccc-cccc-cccc-cccccccccccc/katmon.jpg', 'whole_tree', 'Sample photo via Wikipedia (Dillenia philippinensis). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/cccccccc-cccc-cccc-cccc-cccccccccccc/katmon.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'da39c447-b13a-52b6-bead-f3b22b271931', '/uploads/species/da39c447-b13a-52b6-bead-f3b22b271931/salingbobog.jpg', 'whole_tree', 'Sample photo via Wikipedia (Cratoxylum sumatranum). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/da39c447-b13a-52b6-bead-f3b22b271931/salingbobog.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'dddddddd-dddd-dddd-dddd-dddddddddddd', '/uploads/species/dddddddd-dddd-dddd-dddd-dddddddddddd/duhat.jpg', 'whole_tree', 'Sample photo via Wikipedia (Syzygium cumini). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/dddddddd-dddd-dddd-dddd-dddddddddddd/duhat.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'e15808d8-caed-5d5e-b641-af6206be1314', '/uploads/species/e15808d8-caed-5d5e-b641-af6206be1314/balayong.jpg', 'whole_tree', 'Sample photo via Wikipedia (Cassia javanica). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/e15808d8-caed-5d5e-b641-af6206be1314/balayong.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'ea6fbff0-7860-583b-9e2f-4364c6e93c52', '/uploads/species/ea6fbff0-7860-583b-9e2f-4364c6e93c52/siar.jpg', 'whole_tree', 'Sample photo via Wikipedia (Peltophorum pterocarpum). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/ea6fbff0-7860-583b-9e2f-4364c6e93c52/siar.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '/uploads/species/eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee/dita.jpg', 'whole_tree', 'Sample photo via Wikipedia (Alstonia scholaris). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee/dita.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'f0931658-a038-55f3-a1de-500a0d9039b7', '/uploads/species/f0931658-a038-55f3-a1de-500a0d9039b7/dapdap.jpg', 'whole_tree', 'Sample photo via Wikipedia (Erythrina variegata). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/f0931658-a038-55f3-a1de-500a0d9039b7/dapdap.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT 'ffffffff-ffff-ffff-ffff-ffffffffffff', '/uploads/species/ffffffff-ffff-ffff-ffff-ffffffffffff/akleng.jpg', 'whole_tree', 'Sample photo via Wikipedia (Albizia procera). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/ffffffff-ffff-ffff-ffff-ffffffffffff/akleng.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '20000000-0000-0000-0000-000000000001', '/uploads/species/20000000-0000-0000-0000-000000000001/ylangylang.jpg', 'whole_tree', 'Sample photo via Wikipedia (Cananga odorata). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/20000000-0000-0000-0000-000000000001/ylangylang.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '20000000-0000-0000-0000-000000000002', '/uploads/species/20000000-0000-0000-0000-000000000002/kalingag.jpg', 'whole_tree', 'Sample photo via Wikipedia (Cinnamomum mercadoi). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/20000000-0000-0000-0000-000000000002/kalingag.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '20000000-0000-0000-0000-000000000003', '/uploads/species/20000000-0000-0000-0000-000000000003/benguetpine.jpg', 'whole_tree', 'Sample photo via Wikipedia (Pinus kesiya). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/20000000-0000-0000-0000-000000000003/benguetpine.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '20000000-0000-0000-0000-000000000004', '/uploads/species/20000000-0000-0000-0000-000000000004/huani.jpg', 'whole_tree', 'Sample photo via Wikipedia (Mangifera odorata). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/20000000-0000-0000-0000-000000000004/huani.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '20000000-0000-0000-0000-000000000005', '/uploads/species/20000000-0000-0000-0000-000000000005/almaciga.jpg', 'whole_tree', 'Sample photo via Wikipedia (Agathis dammara). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/20000000-0000-0000-0000-000000000005/almaciga.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '20000000-0000-0000-0000-000000000008', '/uploads/species/20000000-0000-0000-0000-000000000008/ipil.jpg', 'whole_tree', 'Sample photo via Wikipedia (Intsia acuminata). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/20000000-0000-0000-0000-000000000008/ipil.jpg');

INSERT INTO species_photos (species_id, file_url, photo_type, caption, verification_status)
SELECT '20000000-0000-0000-0000-000000000009', '/uploads/species/20000000-0000-0000-0000-000000000009/kalomala.jpg', 'whole_tree', 'Sample photo via Wikipedia (Elaeocarpus calomala). Replace with community photo.', 'verified'
WHERE NOT EXISTS (SELECT 1 FROM species_photos WHERE file_url = '/uploads/species/20000000-0000-0000-0000-000000000009/kalomala.jpg');
