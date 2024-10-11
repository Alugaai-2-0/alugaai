CREATE TABLE IF NOT EXISTS properties
(
    id              SERIAL PRIMARY KEY,
    address         VARCHAR(255),
    home_complement VARCHAR(255),
    neighborhood    VARCHAR(255),
    district        VARCHAR(255),
    state           VARCHAR(255),
    latitude        VARCHAR(255),
    longitude       VARCHAR(255),
    owner_id        INT NOT NULL,
    CONSTRAINT fk_owner FOREIGN KEY (owner_id) REFERENCES users (id)
);
