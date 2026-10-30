ALTER TABLE house
    ADD COLUMN location POINT NULL SRID 4326,
    ADD COLUMN access_point POINT NULL SRID 4326,
    ADD COLUMN road_segment_id INT UNSIGNED NULL,

    ADD INDEX idx_house_road_segment (road_segment_id),

    ADD CONSTRAINT fk_house_road_segment
        FOREIGN KEY (road_segment_id)
        REFERENCES road_segment(id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT;