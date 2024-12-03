package com.alugaai.backend.dtos.student;

import com.alugaai.backend.dtos.image.ImageResponseDTO;

import java.time.LocalDateTime;
import java.util.Set;

public record StudentFeedResponseDTO(
        Integer id,
        String userName,
        LocalDateTime birthDate,
        String description,
        ImageResponseDTO image,
        Set<String> personalities
) {
}
