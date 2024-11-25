package com.alugaai.backend.services;

import com.alugaai.backend.dtos.api.ViaCepResponseDTO;
import com.alugaai.backend.dtos.college.CollegeRequestDTO;
import com.alugaai.backend.dtos.college.CollegeResponseDTO;
import com.alugaai.backend.dtos.mappers.CollegeMapper;
import com.alugaai.backend.dtos.mappers.PropertyMapper;
import com.alugaai.backend.dtos.property.PropertyRequestDTO;
import com.alugaai.backend.dtos.property.PropertyResponseDTO;
import com.alugaai.backend.models.*;
import com.alugaai.backend.repositories.PropertyRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PropertyService {

    private final ImageService imageService;
    private final PropertyRepository propertyRepository;
    private final GeocoderService geocoderService;


    @Transactional
    public PropertyResponseDTO post(PropertyRequestDTO request, Owner owner) {
        ViaCepResponseDTO result = geocoderService.getLatLongFromAddress(request.address());

        Property property = createProperty(request, result, owner);
        property = propertyRepository.save(property);

        List<Image> images = imageService.processImages(request.propertyImages(), property);
        property.setImages(images);

        property = propertyRepository.save(property);

        return PropertyMapper.topropertyResponseDTO(
                property,
                property.getImages().stream()
                        .map(Image::getId)
                        .collect(Collectors.toList())
        );
    }

    @Transactional(readOnly = true)
    public List<PropertyResponseDTO> listAll() {
        return propertyRepository.findAll().stream()
                .map(property -> PropertyMapper.topropertyResponseDTO(
                        property,
                        property.getImages().stream()
                                .map(Image::getId)
                                .collect(Collectors.toList())
                ))
                .collect(Collectors.toList());
    }

    private Property createProperty(PropertyRequestDTO request, ViaCepResponseDTO result, Owner owner) {
        Property property = new Property();
        property.setAddress(result.logradouro());
        property.setOwner(owner);
        property.setHomeNumber(request.address().homeNumber());
        property.setHomeComplement(result.complemento());
        property.setNeighborhood(result.bairro());
        property.setDistrict(result.localidade());
        property.setLatitude(result.latLong().getLatitude());
        property.setLongitude(result.latLong().getLongitude());
        property.setImages(new ArrayList<>());
        return property;
    }

}
