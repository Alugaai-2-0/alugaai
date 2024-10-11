CREATE TABLE IF NOT EXISTS users
(
    id                        INT AUTO_INCREMENT PRIMARY KEY,
    refresh_token             VARCHAR(255),
    refresh_token_expiry_time TIMESTAMP,
    birth_date                TIMESTAMP,
    created_date              TIMESTAMP,
    gender                    CHAR(1),
    user_name                 VARCHAR(255)        NOT NULL,
    password_hash             VARCHAR(255)        NOT NULL,
    email                     VARCHAR(255) UNIQUE NOT NULL,
    normalized_email          VARCHAR(255),
    email_confirmed           BOOLEAN,
    phone_number              VARCHAR(255),
    phone_number_confirmed    BOOLEAN,
    two_factor_enabled        BOOLEAN,
    image_id                  INT,
    discriminator             VARCHAR(50),
    CONSTRAINT fk_image FOREIGN KEY (image_id) REFERENCES images (id)
);
