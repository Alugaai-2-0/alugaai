CREATE TABLE IF NOT EXISTS images
(
    id           SERIAL PRIMARY KEY,
    image_data64 TEXT      NOT NULL,
    inserted_on  TIMESTAMP NOT NULL,
    building_id  INT,
    CONSTRAINT fk_building FOREIGN KEY (building_id) REFERENCES buildings (id)
);
