package com.alugaai.backend.dtos.property;

import com.alugaai.backend.dtos.AddressRequestDTO;
import com.alugaai.backend.dtos.image.ImageRequestDTO;

import java.util.List;

public record PropertyRequestDTO(
        AddressRequestDTO address,
        List<ImageRequestDTO> propertyImages
) {
}
