package com.alugaai.backend.models;

import jakarta.persistence.*;
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
    private String imageData64;
    private LocalDateTime insertedOn;
}
