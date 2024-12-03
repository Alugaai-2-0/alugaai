package com.alugaai.backend.dtos.mappers;

import com.alugaai.backend.dtos.property.PropertyDetailedResponseDTO;
import com.alugaai.backend.dtos.property.PropertyResponseDTO;
import com.alugaai.backend.models.Property;

import java.util.List;
import java.util.stream.Collectors;

public class PropertyMapper {
    public static PropertyResponseDTO topropertyResponseDTO(Property property, List<Integer> propertyImagesIds) {
        return new PropertyResponseDTO(
                property.getId(),
                property.getAddress(),
                property.getHomeNumber(),
                property.getHomeComplement(),
                property.getNeighborhood(),
                property.getDistrict(),
                property.getLatitude(),
                property.getLongitude(),
                property.getOwner().getId(),
                property.getPrice(),
                propertyImagesIds
        );
    }

    public static PropertyDetailedResponseDTO propertyDetailedResponseDTO(Property property) {
        return new PropertyDetailedResponseDTO(
                property.getId(),
                property.getAddress(),
                property.getHomeNumber(),
                property.getHomeComplement(),
                property.getNeighborhood(),
                property.getDistrict(),
                property.getLatitude(),
                property.getLongitude(),
                UserMapper.ownerForPropertyResponseDTO(property.getOwner()),
                !property.getImages().isEmpty() ? property.getImages().stream()
                        .map(ImageMapper::toImageResponseDTO)
                        .collect(Collectors.toList()) : null
        );
    }
}
