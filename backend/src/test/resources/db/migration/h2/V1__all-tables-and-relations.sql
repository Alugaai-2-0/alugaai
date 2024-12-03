CREATE TABLE IF NOT EXISTS users
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    refresh_token VARCHAR(255),
    description VARCHAR(255),
    refresh_token_expiry_time TIMESTAMP NULL,
    birth_date TIMESTAMP NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    gender CHAR(1) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    cpf VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    email_confirmed BOOLEAN DEFAULT FALSE,
    phone_number VARCHAR(255) UNIQUE NOT NULL,
    phone_number_confirmed BOOLEAN DEFAULT FALSE,
    two_factor_enabled BOOLEAN DEFAULT FALSE,
    image_id INT,
    discriminator VARCHAR(50),
    college_principal_id INT
);

CREATE TABLE IF NOT EXISTS user_personalities (
    user_id INTEGER NOT NULL,
    personality VARCHAR(255),
    CONSTRAINT fk_user_personalities FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Criação da tabela 'images'
CREATE TABLE IF NOT EXISTS images
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    image_data BLOB NOT NULL,
    inserted_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    building_id INT
);

-- Criação da tabela 'buildings' com discriminador
CREATE TABLE IF NOT EXISTS buildings
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(255) NOT NULL,
    college_name VARCHAR(255),
    home_number VARCHAR(255) NOT NULL,
    home_complement VARCHAR(255),
    neighborhood VARCHAR(255) NOT NULL,
    district VARCHAR(255) NOT NULL,
    latitude VARCHAR(255) NOT NULL,
    longitude VARCHAR(255) NOT NULL,
    discriminator VARCHAR(50),  -- Campo para diferenciar entre College e Property
    owner_id INT,
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

-- Add constraints in 'users' after the dependent tables are created
ALTER TABLE users
    ADD CONSTRAINT fk_image FOREIGN KEY (image_id) REFERENCES images (id),
    ADD CONSTRAINT fk_college FOREIGN KEY (college_principal_id) REFERENCES buildings(id);

-- Criação da tabela 'students_connections'
CREATE TABLE IF NOT EXISTS students_connections
(
    student_id INT NOT NULL,
    connected_student_id INT NOT NULL,
    PRIMARY KEY (student_id, connected_student_id),
    CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES users (id),
    CONSTRAINT fk_connected_student FOREIGN KEY (connected_student_id) REFERENCES users (id)
);

-- Criação da tabela 'students_properties'
CREATE TABLE IF NOT EXISTS students_properties_likes
(
    student_id INT NOT NULL,
    property_id INT NOT NULL,
    PRIMARY KEY (student_id, property_id),
    CONSTRAINT fk_student_property FOREIGN KEY (student_id) REFERENCES users (id),
    CONSTRAINT fk_property FOREIGN KEY (property_id) REFERENCES buildings (id)
);

-- Criação da tabela 'students_colleges'
CREATE TABLE IF NOT EXISTS students_seconds_colleges
(
    student_id INT NOT NULL,
    college_id INT NOT NULL,
    PRIMARY KEY (student_id, college_id),
    CONSTRAINT fk_student_college FOREIGN KEY (student_id) REFERENCES users (id),
    CONSTRAINT fk_college FOREIGN KEY (college_id) REFERENCES buildings (id)
);

-- Criação da tabela 'notifications'
CREATE TABLE IF NOT EXISTS notifications
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    text VARCHAR(255) NOT NULL,
    moment TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE
);

-- Criação da tabela 'users_notifications'
CREATE TABLE IF NOT EXISTS users_notifications
(
    user_id INT NOT NULL,
    notification_id INT NOT NULL,
    PRIMARY KEY (user_id, notification_id),
    CONSTRAINT fk_user_notification FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_notification FOREIGN KEY (notification_id) REFERENCES notifications (id)
);