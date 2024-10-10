package com.alugaai.backend.models;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Hashtable;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Table(name = "users")
public class User implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String refreshToken;

    private LocalDateTime refreshTokenExpiryTime;

    private LocalDateTime birthDate;

    private LocalDateTime createdDate;

    private Character gender;

    private String discriminator;

    @ElementCollection(fetch = FetchType.EAGER)
    private List<Integer> idsPersonsIConnect = new ArrayList<>();

    private String userName;

    private String passwordHash;

    private String email;

    private String normalizedEmail;

    private Boolean emailConfirmed;

    private String phoneNumber;

    private Boolean phoneNumberConfirmed;

    private Boolean twoFactorEnabled;


    public User(LocalDateTime birthDate, LocalDateTime createdDate, Character gender, String userName, String email,
                String passwordHash) {
        this.birthDate = birthDate;
        this.createdDate = createdDate;
        this.gender = gender;
        this.userName = userName;
        this.email = email;
        this.passwordHash = passwordHash;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return null;
    }

    @Override
    public String getPassword() {
        return this.passwordHash;
    }

    @Override
    public String getUsername() {
        return this.userName;
    }

    @Override
    public boolean isAccountNonExpired() {
        return UserDetails.super.isAccountNonExpired();
    }

    @Override
    public boolean isAccountNonLocked() {
        return UserDetails.super.isAccountNonLocked();
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return UserDetails.super.isCredentialsNonExpired();
    }

    @Override
    public boolean isEnabled() {
        return UserDetails.super.isEnabled();
    }
}
