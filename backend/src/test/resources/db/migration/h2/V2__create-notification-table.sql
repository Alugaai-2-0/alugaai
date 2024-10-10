CREATE TABLE IF NOT EXISTS notifications
(
    id     BIGINT AUTO_INCREMENT PRIMARY KEY,
    text   VARCHAR(255),
    moment TIMESTAMP,
    isRead BOOLEAN DEFAULT FALSE
);
