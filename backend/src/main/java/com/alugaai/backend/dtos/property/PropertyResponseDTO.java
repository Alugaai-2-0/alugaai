package com.alugaai.backend.dtos.property;

import java.util.List;

public record PropertyResponseDTO(
        Integer id,
        String address,
        String homeNumber,
        String homeComplement,
        String neighborhood,
        String district,
        String latitude,
        String longitude,
        Integer ownerId,
        Double price,
        List<Integer> propertyImagesIds

) {
}
