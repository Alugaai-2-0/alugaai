package com.alugaai.backend.models;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@EqualsAndHashCode
@Table(name = "notifications")
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private @NotNull String text;

    private @NotNull LocalDateTime moment = LocalDateTime.now();

    private @NotNull Boolean isRead = false;

    @ManyToMany(mappedBy = "notifications")
    private @NotNull Set<User> users = new HashSet<>();

}
