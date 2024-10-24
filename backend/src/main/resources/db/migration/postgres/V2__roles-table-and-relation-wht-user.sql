-- Criação da tabela roles
CREATE TABLE roles
(
    id        SERIAL PRIMARY KEY,
    role_name VARCHAR(255) UNIQUE NOT NULL
);

-- Adição da coluna role_id na tabela users
ALTER TABLE users
    ADD COLUMN role_id INTEGER;

-- Adicionar chave estrangeira da role em users
ALTER TABLE users
    ADD CONSTRAINT fk_user_role
        FOREIGN KEY (role_id)
            REFERENCES roles (id) ON DELETE CASCADE;

-- Criação da tabela user_roles para relacionamento ManyToMany
CREATE TABLE user_roles
(
    user_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE
);

DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM roles WHERE role_name = 'ROLE_ADMIN') THEN
            INSERT INTO roles (role_name) VALUES ('ROLE_ADMIN');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM roles WHERE role_name = 'ROLE_USER') THEN
            INSERT INTO roles (role_name) VALUES ('ROLE_USER');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM roles WHERE role_name = 'ROLE_STUDENT') THEN
            INSERT INTO roles (role_name) VALUES ('ROLE_STUDENT');
        END IF;
    END $$;
