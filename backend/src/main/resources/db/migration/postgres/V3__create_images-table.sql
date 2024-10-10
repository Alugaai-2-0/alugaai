CREATE TABLE IF NOT EXISTS "images"
(
    id     SERIAL PRIMARY KEY,
    imageData64   VARCHAR(255),
    insertedOn TIMESTAMP
);