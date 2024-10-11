CREATE TABLE IF NOT EXISTS owners
(
    id INT PRIMARY KEY, -- Herança de `users` (mesmo `id`)
    CONSTRAINT fk_owner FOREIGN KEY (id) REFERENCES users (id)
);
