    ALTER TABLE ride
        MODIFY COLUMN pickup_location POINT NOT NULL SRID 4326,
        MODIFY COLUMN dropoff_location POINT NOT NULL SRID 4326;