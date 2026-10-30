START TRANSACTION;

-- Regions
INSERT INTO region (id, name) VALUES
    (1, 'Lviv'),
    (2, 'Kyiv');

-- Cities
INSERT INTO city (id, region_id, name) VALUES
    (1, 1, 'Lviv'),
    (2, 2, 'Kyiv');

-- Streets
INSERT INTO street (id, city_id, name, drivable) VALUES
    (1, 1, 'Shevchenka', TRUE),
    (2, 1, 'Sadova', TRUE),
    (3, 1, 'Pishokhidna', FALSE),
    (4, 2, 'Shevchenka', TRUE);

-- Intersections
INSERT INTO intersection (id, location) VALUES
    (1, ST_GeomFromText('POINT(24.0300 49.8400)', 4326, 'axis-order=long-lat')),
    (2, ST_GeomFromText('POINT(24.0320 49.8400)', 4326, 'axis-order=long-lat')),
    (3, ST_GeomFromText('POINT(24.0320 49.8420)', 4326, 'axis-order=long-lat')),
    (4, ST_GeomFromText('POINT(24.0350 49.8400)', 4326, 'axis-order=long-lat')),
    (5, ST_GeomFromText('POINT(24.0350 49.8420)', 4326, 'axis-order=long-lat')),
    (6, ST_GeomFromText('POINT(24.0370 49.8400)', 4326, 'axis-order=long-lat'));

-- Road segments
INSERT INTO road_segment (
    id, street_id, cross1_id, cross2_id,
    path, distance_m, structure_type
) VALUES
    (1, 1, 1, 2, ST_GeomFromText('LINESTRING(24.0300 49.8400, 24.0320 49.8400)', 4326, 'axis-order=long-lat'), 150, 'surface'),
    (2, 1, 2, 3, ST_GeomFromText('LINESTRING(24.0320 49.8400, 24.0320 49.8420)', 4326, 'axis-order=long-lat'), 220, 'surface'),
    (3, NULL, 2, 4, ST_GeomFromText('LINESTRING(24.0320 49.8400, 24.0350 49.8400)', 4326, 'axis-order=long-lat'), 230, 'bridge'),
    (4, NULL, 3, 5, ST_GeomFromText('LINESTRING(24.0320 49.8420, 24.0350 49.8420)', 4326, 'axis-order=long-lat'), 230, 'bridge'),
    (5, 2, 4, 5, ST_GeomFromText('LINESTRING(24.0350 49.8400, 24.0350 49.8420)', 4326, 'axis-order=long-lat'), 220, 'surface'),
    (6, 2, 4, 6, ST_GeomFromText('LINESTRING(24.0350 49.8400, 24.0370 49.8400)', 4326, 'axis-order=long-lat'), 150, 'surface');

-- Houses
INSERT INTO house (
    id, street_id, house_number,
    location, access_point, road_segment_id
) VALUES
    (
        1, 1, '10',
        ST_GeomFromText('POINT(24.0304 49.8402)', 4326, 'axis-order=long-lat'),
        ST_GeomFromText('POINT(24.0304 49.8400)', 4326, 'axis-order=long-lat'),
        1
    ),
    (
        2, 1, '12А',
        ST_GeomFromText('POINT(24.0323 49.8407)', 4326, 'axis-order=long-lat'),
        ST_GeomFromText('POINT(24.0320 49.8407)', 4326, 'axis-order=long-lat'),
        2
    ),
    (
        3, 2, '5',
        ST_GeomFromText('POINT(24.0360 49.8402)', 4326, 'axis-order=long-lat'),
        ST_GeomFromText('POINT(24.0360 49.8400)', 4326, 'axis-order=long-lat'),
        6
    ),
    (
        4, 3, '1',
        ST_GeomFromText('POINT(24.0310 49.8405)', 4326, 'axis-order=long-lat'),
        ST_GeomFromText('POINT(24.0310 49.8400)', 4326, 'axis-order=long-lat'),
        1
    ),
    (
        5, 4, '10',
        ST_GeomFromText('POINT(30.5234 50.4501)', 4326, 'axis-order=long-lat'),
        NULL,
        NULL
    );

-- Passengers
INSERT INTO passenger (id, first_name, last_name, phone, email) VALUES
    (1, 'Brunhilde', 'Pompidur', '+12025550101', 'brunhilde@example.com'),
    (2, 'Carl', NULL, '+12025550102', 'carl@example.com');

-- Drivers
INSERT INTO driver (id, first_name, last_name, phone, email) VALUES
    (1, 'Anita', 'Job', '+12025550103', 'anita.driver@example.com'),
    (2, 'Robin', 'Banks', '+12025550104', 'robin.driver@example.com');

-- Operators
INSERT INTO `operator` (id, first_name, last_name, email) VALUES
    (1, 'Justin', 'Case', 'justin.operator@example.com');

-- Rides
INSERT INTO ride (
    id, passenger_id, driver_id, operator_id,
    pickup_house_id, dropoff_house_id,
    pickup_location, dropoff_location,
    fare_amount, paid, completed, created_at
) VALUES
    (
        1, 1, 1, 1, 1, 3,
        ST_GeomFromText('POINT(24.0304 49.8400)', 4326, 'axis-order=long-lat'),
        ST_GeomFromText('POINT(24.0360 49.8400)', 4326, 'axis-order=long-lat'),
        120.00, TRUE, TRUE, '2026-10-24 10:00:00'
    ),
    (
        2, 2, 2, NULL, 3, 2,
        ST_GeomFromText('POINT(24.0360 49.8400)', 4326, 'axis-order=long-lat'),
        ST_GeomFromText('POINT(24.0320 49.8407)', 4326, 'axis-order=long-lat'),
        165.00, TRUE, TRUE, '2026-10-24 11:00:00'
    ),
    (
        3, 1, 1, NULL, 4, 1,
        ST_GeomFromText('POINT(24.0310 49.8400)', 4326, 'axis-order=long-lat'),
        ST_GeomFromText('POINT(24.0304 49.8400)', 4326, 'axis-order=long-lat'),
        110.00, TRUE, TRUE, '2026-10-24 12:00:00'
    ),
    (
        4, 2, NULL, 1, 5, 2,
        ST_GeomFromText('POINT(30.5234 50.4501)', 4326, 'axis-order=long-lat'),
        ST_GeomFromText('POINT(24.0320 49.8407)', 4326, 'axis-order=long-lat'),
        NULL, FALSE, FALSE, '2026-10-24 13:00:00'
    ),
    (
        5, 1, NULL, NULL, NULL, NULL,
        ST_GeomFromText('POINT(24.0310 49.8400)', 4326, 'axis-order=long-lat'),
        ST_GeomFromText('POINT(24.0360 49.8400)', 4326, 'axis-order=long-lat'),
        NULL, FALSE, FALSE, '2026-10-24 14:00:00'
    );

-- Driver ratings
INSERT INTO driver_rating (ride_id, rating, review) VALUES
    (1, 5, 'Great ride'),
    (2, 4, NULL),
    (3, 4, 'Good driver');

-- Passenger ratings
INSERT INTO passenger_rating (ride_id, rating, review) VALUES
    (1, 5, 'It was awesome'),
    (2, 3, NULL),
    (3, 4, 'Cool');

-- Driver rating summary
UPDATE driver AS d
JOIN (
    SELECT
        r.driver_id,
        ROUND(AVG(dr.rating), 2) AS avg_rating,
        COUNT(*) AS rating_count
    FROM ride AS r
    JOIN driver_rating AS dr ON dr.ride_id = r.id
    GROUP BY r.driver_id
) AS stats ON stats.driver_id = d.id
SET
    d.rating_avg = stats.avg_rating,
    d.rating_count = stats.rating_count;

-- Passenger rating summary
UPDATE passenger AS p
JOIN (
    SELECT
        r.passenger_id,
        ROUND(AVG(pr.rating), 2) AS avg_rating,
        COUNT(*) AS rating_count
    FROM ride AS r
    JOIN passenger_rating AS pr ON pr.ride_id = r.id
    GROUP BY r.passenger_id
) AS stats ON stats.passenger_id = p.id
SET
    p.rating_avg = stats.avg_rating,
    p.rating_count = stats.rating_count;

COMMIT;