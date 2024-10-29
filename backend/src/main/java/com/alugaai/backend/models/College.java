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
@DiscriminatorValue("COLLEGE")
public class College extends Building {

    @OneToMany(mappedBy = "principalCollege", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Student> principalStudents = new ArrayList<>();

    @ManyToMany(mappedBy = "secondsColleges")
    private Set<Student> secondStudents = new HashSet<>();
}
