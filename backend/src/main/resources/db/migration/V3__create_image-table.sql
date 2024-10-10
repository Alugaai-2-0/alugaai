CREATE TABLE IF NOT EXISTS "image"
(
    id     SERIAL PRIMARY KEY,
    imageData64   VARCHAR(255),
    insertedOn TIMESTAMP
);