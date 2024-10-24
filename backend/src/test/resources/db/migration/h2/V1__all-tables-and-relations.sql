-- Criação da tabela 'images'
CREATE TABLE IF NOT EXISTS images
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    image_data64 CLOB NOT NULL,
    inserted_on TIMESTAMP NOT NULL
);

-- Criação da tabela 'buildings' com discriminador
CREATE TABLE IF NOT EXISTS buildings
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(255),
    home_complement VARCHAR(255),
    neighborhood VARCHAR(255),
    district VARCHAR(255),
    state VARCHAR(255),
    latitude VARCHAR(255),
    longitude VARCHAR(255),
    discriminator VARCHAR(50)  -- Campo para diferenciar entre College e Property
);

-- Criação da tabela 'users'
CREATE TABLE IF NOT EXISTS users
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    refresh_token VARCHAR(255),
    refresh_token_expiry_time TIMESTAMP,
    birth_date TIMESTAMP,
    created_date TIMESTAMP,
    gender CHAR(1),
    user_name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    normalized_email VARCHAR(255),
    email_confirmed BOOLEAN,
    phone_number VARCHAR(255),
    phone_number_confirmed BOOLEAN,
    two_factor_enabled BOOLEAN,
    image_id INT,
    discriminator VARCHAR(50),
    college_id INT,
    CONSTRAINT fk_image FOREIGN KEY (image_id) REFERENCES images (id),
    CONSTRAINT fk_college FOREIGN KEY (college_id) REFERENCES buildings(id)
);

-- Criação da tabela 'student_connections'
CREATE TABLE IF NOT EXISTS students_connections
(
    student_id INT NOT NULL,
    connected_student_id INT NOT NULL,
    PRIMARY KEY (student_id, connected_student_id),
    CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES users (id),
    CONSTRAINT fk_connected_student FOREIGN KEY (connected_student_id) REFERENCES users (id)
);

-- Criação da tabela 'student_property'
CREATE TABLE IF NOT EXISTS students_properties
(
    student_id INT NOT NULL,
    property_id INT NOT NULL,
    PRIMARY KEY (student_id, property_id),
    CONSTRAINT fk_student_property FOREIGN KEY (student_id) REFERENCES users (id),
    CONSTRAINT fk_property FOREIGN KEY (property_id) REFERENCES buildings (id)
);

-- Criação da tabela 'notifications'
CREATE TABLE IF NOT EXISTS notifications
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    text VARCHAR(255),
    moment TIMESTAMP NOT NULL,
    is_read BOOLEAN DEFAULT FALSE
);

-- Criação da tabela 'user_notification'
CREATE TABLE IF NOT EXISTS users_notifications
(
    user_id INT NOT NULL,
    notification_id INT NOT NULL,
    PRIMARY KEY (user_id, notification_id),
    CONSTRAINT fk_user_notification FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_notification FOREIGN KEY (notification_id) REFERENCES notifications (id)
);
