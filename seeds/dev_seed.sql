START TRANSACTION;

-- Regions
INSERT INTO region (name) VALUES
    ('Львівська'),
    ('Київcька')
ON DUPLICATE KEY UPDATE id = id;

SET @lviv_region = (SELECT id FROM region WHERE name = 'Львівська');
SET @kyiv_region = (SELECT id FROM region WHERE name = 'Київcька');

-- Cities
INSERT INTO city (region_id, name) VALUES
    (@lviv_region, 'Львів'),
    (@kyiv_region, 'Київ')
ON DUPLICATE KEY UPDATE id = id;

SET @lviv_city = (SELECT id FROM city WHERE region_id = @lviv_region AND name = 'Львів');
SET @kyiv_city = (SELECT id FROM city WHERE region_id = @kyiv_region AND name = 'Київ');

-- Streets
INSERT INTO street (city_id, name, drivable) VALUES
    (@lviv_city, 'Шевченка', TRUE),
    (@lviv_city, 'Садова', TRUE),
    (@lviv_city, 'Пішохідна', FALSE),
    (@kyiv_city, 'Шевченка', TRUE)
ON DUPLICATE KEY UPDATE id = id;

SET @lviv_shevchenka = (SELECT id FROM street WHERE city_id = @lviv_city AND name = 'Шевченка');
SET @lviv_sadova = (SELECT id FROM street WHERE city_id = @lviv_city AND name = 'Садова');
SET @lviv_pishohidna = (SELECT id FROM street WHERE city_id = @lviv_city AND name = 'Пішохідна');
SET @kyiv_shevchenka = (SELECT id FROM street WHERE city_id = @kyiv_city AND name = 'Шевченка');

-- Houses
INSERT INTO house (street_id, house_number) VALUES
    (@lviv_shevchenka, '10'),
    (@lviv_shevchenka, '12А'),
    (@lviv_sadova, '5'),
    (@lviv_pishohidna, '1'),
    (@kyiv_shevchenka, '10')
ON DUPLICATE KEY UPDATE id = id;

-- Passengers
INSERT INTO passenger (first_name, last_name, phone, email) VALUES
    ('Brunhilde', 'Pompidur', '+12025550101', 'brunhilde@example.com'),
    ('Carl', NULL, '+12025550102', 'carl@example.com');

COMMIT;