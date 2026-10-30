CREATE TABLE IF NOT EXISTS intersection (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    location POINT NOT NULL SRID 4326,

    SPATIAL INDEX idx_intersection_location (location)
) ENGINE = InnoDB;