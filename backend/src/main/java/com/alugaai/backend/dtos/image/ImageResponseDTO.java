package com.alugaai.backend.dtos.image;

import java.time.LocalDateTime;

public record ImageResponseDTO(
        Integer id,
        String imageData64,
        LocalDateTime insertedOn
) {
}
