package com.alugaai.backend.dtos.college;

import com.alugaai.backend.dtos.image.ImageRequestDTO;

import java.util.List;

public record CollegeRequestDTO(
        String cep,
        String homeNumber,
        String collegeName,
        List<ImageRequestDTO> collegesImages
) {
}
