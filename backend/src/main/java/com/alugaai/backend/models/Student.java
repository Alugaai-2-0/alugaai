package com.alugaai.backend.models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Getter
@Setter
@DiscriminatorValue("STUDENT")
public class Student extends User {

    @ManyToMany
    @JoinTable(
            name = "students_connections",
            joinColumns = @JoinColumn(name = "student_id"),
            inverseJoinColumns = @JoinColumn(name = "connected_student_id")
    )
    private Set<Student> connections = new HashSet<>();

    @ManyToOne
    @JoinColumn(name = "college_id", nullable = false)
    private College college;

    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinTable(
            name = "students_properties",
            joinColumns = @JoinColumn(name = "student_id"),
            inverseJoinColumns = @JoinColumn(name = "property_id")
    )
    private Set<Property> propertiesLikes;

}
