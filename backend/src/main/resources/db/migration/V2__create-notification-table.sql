-- V2__create-notification-table.sql
CREATE TABLE IF NOT EXISTS "notification"
(
    id     SERIAL PRIMARY KEY,
    text   VARCHAR(255),
    moment TIMESTAMP,
    isRead   BOOLEAN DEFAULT FALSE
);