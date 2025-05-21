package com.alugaai.backend.models;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Getter
@Setter
@NoArgsConstructor
@DiscriminatorValue("STUDENT")
public class Student extends User {

    private String description;

    @ElementCollection
    @CollectionTable(
            name = "user_personalities",
            joinColumns = @JoinColumn(name = "user_id")
    )
    @Column(name = "personality")
    private Set<String> personalities = new HashSet<>();

    @OneToMany(mappedBy = "requester", cascade = CascadeType.ALL)
    private Set<StudentConnection> sentConnectionRequests = new HashSet<>();

    @OneToMany(mappedBy = "addressee", cascade = CascadeType.ALL)
    private Set<StudentConnection> receivedConnectionRequests = new HashSet<>();


    @ManyToOne
    @JoinColumn(name = "college_principal_id", nullable = true)
    private College principalCollege;

    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY)
    @JoinTable(
            name = "students_seconds_colleges",
            joinColumns = @JoinColumn(name = "student_id"),
            inverseJoinColumns = @JoinColumn(name = "college_id")
    )
    private Set<College> secondsColleges = new HashSet<>();

    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY)
    @JoinTable(
            name = "students_properties_likes",
            joinColumns = @JoinColumn(name = "student_id"),
            inverseJoinColumns = @JoinColumn(name = "property_id")
    )
    private Set<Property> propertiesLikes = new HashSet<>();

    public Student(LocalDateTime birthDate, LocalDateTime createdDate, Character gender, String userName, String email,
                   String passwordHash) {
        super(birthDate, createdDate, gender, userName, email, passwordHash);
    }

    public Student(LocalDateTime birthDate, LocalDateTime createdDate, Character gender, String userName,
                   String email, String passwordHash, String cpf, String phoneNumber) {
        super(birthDate, createdDate, gender, userName, email, passwordHash, cpf, phoneNumber);
    }

}
