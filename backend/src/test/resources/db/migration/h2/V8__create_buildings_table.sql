CREATE TABLE IF NOT EXISTS buildings
(
    id              INT AUTO_INCREMENT PRIMARY KEY,
    address         VARCHAR(255),
    home_complement VARCHAR(255),
    neighborhood    VARCHAR(255),
    district        VARCHAR(255),
    state           VARCHAR(255),
    latitude        VARCHAR(255),
    longitude       VARCHAR(255)
);
