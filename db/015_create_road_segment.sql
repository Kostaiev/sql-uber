CREATE TABLE IF NOT EXISTS road_segment (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    street_id INT UNSIGNED,
    cross1_id INT UNSIGNED NOT NULL,
    cross2_id INT UNSIGNED NOT NULL,

    path LINESTRING NOT NULL SRID 4326,
    distance_m INT UNSIGNED NOT NULL,

    structure_type ENUM('surface', 'bridge', 'tunnel')
        NOT NULL DEFAULT 'surface',

    drivable BOOLEAN NOT NULL DEFAULT TRUE,

    INDEX idx_segment_street (street_id),
    INDEX idx_segment_cross1 (cross1_id),
    INDEX idx_segment_cross2 (cross2_id),
    SPATIAL INDEX idx_segment_path (path),

    CONSTRAINT fk_segment_street
        FOREIGN KEY (street_id) REFERENCES street(id)
        ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT fk_segment_cross1
        FOREIGN KEY (cross1_id) REFERENCES intersection(id)
        ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT fk_segment_cross2
        FOREIGN KEY (cross2_id) REFERENCES intersection(id)
        ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT chk_segment_distance
        CHECK (distance_m > 0),

    CONSTRAINT chk_segment_endpoints
        CHECK (cross1_id <> cross2_id),

    CONSTRAINT chk_segment_drivable
        CHECK (drivable IN (0, 1))
) ENGINE = InnoDB;