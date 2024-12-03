package com.alugaai.backend.dtos.student;

import java.time.LocalDateTime;
import java.util.Set;

public record StudentFeedResponseDTO(
        Integer id,
        String userName,
        LocalDateTime birthDate,
        Set<String> personalities
) {
}
