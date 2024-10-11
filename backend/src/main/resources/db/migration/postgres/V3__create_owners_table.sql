CREATE TABLE IF NOT EXISTS owners
(
    id INT PRIMARY KEY, -- Inheritance from `users` (same `id`)
    CONSTRAINT fk_owner FOREIGN KEY (id) REFERENCES users (id)
);
