package com.alugaai.backend.models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "student_connections")
@Getter
@Setter
@NoArgsConstructor
public class StudentConnection {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "requester_id", nullable = false)
    private Student requester;

    @ManyToOne
    @JoinColumn(name = "addressee_id", nullable = false)
    private Student addressee;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private ConnectionStatus status;

    private LocalDateTime requestDate;

    private LocalDateTime responseDate;

    public StudentConnection(Student requester, Student addressee) {
        this.requester = requester;
        this.addressee = addressee;
        this.status = ConnectionStatus.PENDING;
        this.requestDate = LocalDateTime.now();
    }
}