CREATE TABLE IF NOT EXISTS "user"
(
    id                        SERIAL PRIMARY KEY,
    refresh_token             VARCHAR(255),
    refresh_token_expiry_time TIMESTAMP,
    birth_date                TIMESTAMP,
    created_date              TIMESTAMP,
    gender                    CHAR(1),
    discriminator             VARCHAR(255),
    ids_persons_i_connect     INTEGER[],
    user_name                 VARCHAR(255),
    email                     VARCHAR(255) NOT NULL,
    normalized_email          VARCHAR(255),
    email_confirmed           BOOLEAN DEFAULT FALSE,
    phone_number              VARCHAR(20),
    phone_number_confirmed    BOOLEAN DEFAULT FALSE,
    two_factor_enabled        BOOLEAN DEFAULT FALSE
);
