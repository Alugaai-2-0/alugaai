package com.alugaai.backend.models;

import jakarta.persistence.CascadeType;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.OneToMany;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@DiscriminatorValue("OWNER")
public class Owner extends User {
    @OneToMany(mappedBy = "owner", orphanRemoval = true, cascade = CascadeType.ALL)
    private List<Property> properties = new ArrayList<>();

    public Owner(LocalDateTime birthDate, LocalDateTime createdDate, Character gender, String userName, String email,
                   String passwordHash) {
        super(birthDate, createdDate, gender, userName, email, passwordHash);
    }

}
