package com.alugaai.backend.dtos.user;

import com.alugaai.backend.dtos.image.ImageResponseDTO;

public record OwnerForPropertyResponseDTO(
        Integer id,
        String userName,
        Character gender,
        String phoneNumber,
        ImageResponseDTO image
) {
}
