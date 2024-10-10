CREATE TABLE IF NOT EXISTS "notifications"
(
    id     SERIAL PRIMARY KEY,
    text   VARCHAR(255),
    moment TIMESTAMP,
    isRead   BOOLEAN DEFAULT FALSE
);