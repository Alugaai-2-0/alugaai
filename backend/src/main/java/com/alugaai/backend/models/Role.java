package com.alugaai.backend.models;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.validator.constraints.UniqueElements;
import org.springframework.security.core.GrantedAuthority;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "roles")
public class Role implements GrantedAuthority {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    private @NotNull @UniqueElements RoleName roleName;

    @Override
    public String getAuthority() {
        return roleName.name();
    }

    public Role(String roleName) {
        this.roleName = RoleName.valueOf(roleName);
    }

    public enum RoleName {
        ROLE_ADMIN,
        ROLE_OWNER,
        ROLE_STUDENT
    }
}
