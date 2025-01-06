package com.alugaai.backend.models;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.util.Set;

@Entity
@Getter
@Setter
@DiscriminatorValue("PROPERTY")
public class Property extends Building {

    @ManyToOne(optional = true)
    @JoinColumn(name = "owner_id", nullable = false)
    private Owner owner;

    @ManyToMany(mappedBy = "propertiesLikes")
    private Set<Student> studentsLikes;

    private Double price;

}
