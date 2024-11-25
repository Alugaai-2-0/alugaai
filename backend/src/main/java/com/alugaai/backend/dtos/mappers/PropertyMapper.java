package com.alugaai.backend.dtos.mappers;

import com.alugaai.backend.dtos.college.CollegeResponseDTO;
import com.alugaai.backend.dtos.property.PropertyResponseDTO;
import com.alugaai.backend.models.College;
import com.alugaai.backend.models.Property;

import java.util.List;

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
                propertyImagesIds
        );
    }
}
