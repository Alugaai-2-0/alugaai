CREATE TABLE IF NOT EXISTS notifications
(
    id      SERIAL PRIMARY KEY,
    text    VARCHAR(255),
    moment  TIMESTAMP NOT NULL,
    is_read BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS user_notification
(
    user_id         INT NOT NULL,
    notification_id INT NOT NULL,
    PRIMARY KEY (user_id, notification_id),
    CONSTRAINT fk_user_notification FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_notification FOREIGN KEY (notification_id) REFERENCES notifications (id)
);
