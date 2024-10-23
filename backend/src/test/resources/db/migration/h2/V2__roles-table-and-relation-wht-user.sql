-- Criação da tabela roles
CREATE TABLE roles
(
    id        BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(255) UNIQUE NOT NULL
);

-- Adição da coluna role_id na tabela users
ALTER TABLE users
    ADD COLUMN role_id BIGINT;

-- Adicionar chave estrangeira da role em users
ALTER TABLE users
    ADD CONSTRAINT fk_user_role
        FOREIGN KEY (role_id)
            REFERENCES roles (id) ON DELETE CASCADE;

-- Criação da tabela user_roles para relacionamento ManyToMany
CREATE TABLE user_roles
(
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE
);
