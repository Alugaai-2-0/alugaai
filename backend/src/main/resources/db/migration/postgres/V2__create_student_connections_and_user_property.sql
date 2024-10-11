CREATE TABLE IF NOT EXISTS student_connections
(
    student_id           INT NOT NULL,
    connected_student_id INT NOT NULL,
    PRIMARY KEY (student_id, connected_student_id),
    CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES users (id),
    CONSTRAINT fk_connected_student FOREIGN KEY (connected_student_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS user_property
(
    student_id  INT NOT NULL,
    property_id INT NOT NULL,
    PRIMARY KEY (student_id, property_id),
    CONSTRAINT fk_student_property FOREIGN KEY (student_id) REFERENCES users (id),
    CONSTRAINT fk_property FOREIGN KEY (property_id) REFERENCES buildings (id)
);
