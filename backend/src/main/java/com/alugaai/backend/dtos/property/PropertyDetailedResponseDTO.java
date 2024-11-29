package com.alugaai.backend.dtos.property;

import com.alugaai.backend.dtos.image.ImageResponseDTO;
import com.alugaai.backend.dtos.user.OwnerForPropertyResponseDTO;

import java.util.List;

public record PropertyDetailedResponseDTO(
        Integer id,
        String address,
        String homeNumber,
        String homeComplement,
        String neighborhood,
        String district,
        String latitude,
        String longitude,
        OwnerForPropertyResponseDTO owner,
        List<ImageResponseDTO> propertyImages

) {
}
