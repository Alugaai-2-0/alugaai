CREATE TABLE IF NOT EXISTS images
(
    id          INT AUTO_INCREMENT PRIMARY KEY,
    image_data64 CLOB NOT NULL,
    inserted_on TIMESTAMP NOT NULL,
    building_id INT,
    CONSTRAINT fk_building FOREIGN KEY (building_id) REFERENCES buildings (id)
);
