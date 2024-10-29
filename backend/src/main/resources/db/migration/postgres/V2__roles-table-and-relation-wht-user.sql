-- Criação da tabela roles
CREATE TABLE IF NOT EXISTS roles
(
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(255) NOT NULL,
    CONSTRAINT uk_role_name UNIQUE (role_name)
);

-- Criação da tabela user_roles para relacionamento ManyToMany
CREATE TABLE IF NOT EXISTS user_roles
(
    user_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    CONSTRAINT pk_user_roles PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_user_roles_user
        FOREIGN KEY (user_id)
            REFERENCES users (id)
            ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role
        FOREIGN KEY (role_id)
            REFERENCES roles (id)
            ON DELETE CASCADE
);

-- Criar índice para melhorar performance de buscas
CREATE INDEX IF NOT EXISTS idx_user_roles_role_id ON user_roles(role_id);

-- Inserir roles padrão
INSERT INTO roles (role_name)
VALUES
    ('ROLE_ADMIN'),
    ('ROLE_OWNER'),
    ('ROLE_STUDENT')
    ON CONFLICT ON CONSTRAINT uk_role_name DO NOTHING;