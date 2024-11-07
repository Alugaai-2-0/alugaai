package com.alugaai.backend.models;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;


import java.time.LocalDateTime;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@EqualsAndHashCode
@Table(name="images")
public class Image {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private @NotNull byte[] imageData;
    private @NotNull LocalDateTime insertedOn = LocalDateTime.now();

    @ManyToOne
    @JoinColumn(name = "building_id")
    private Building building;

    @OneToOne(mappedBy = "image")
    private User user;

    public Image(byte[] imageData64) {
        this.imageData = imageData64;
    }
}
