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

    @ElementCollection
    @CollectionTable(
            name = "user_personalities",
            joinColumns = @JoinColumn(name = "user_id")
    )
    @Column(name = "personality")
    private Set<String> personalities = new HashSet<>();

    @ManyToMany
    @JoinTable(
            name = "students_connections",
            joinColumns = @JoinColumn(name = "student_id"),
            inverseJoinColumns = @JoinColumn(name = "connected_student_id")
    )
    private Set<Student> connections = new HashSet<>();

    @ManyToOne
    @JoinColumn(name = "college_principal_id", nullable = true)
    private College principalCollege;

    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinTable(
            name = "students_seconds_colleges",
            joinColumns = @JoinColumn(name = "student_id"),
            inverseJoinColumns = @JoinColumn(name = "college_id")
    )
    private Set<College> secondsColleges;

    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinTable(
            name = "students_properties_likes",
            joinColumns = @JoinColumn(name = "student_id"),
            inverseJoinColumns = @JoinColumn(name = "property_id")
    )
    private Set<Property> propertiesLikes;

    public Student(LocalDateTime birthDate, LocalDateTime createdDate, Character gender, String userName, String email,
                   String passwordHash) {
        super(birthDate, createdDate, gender, userName, email, passwordHash);
    }
}
