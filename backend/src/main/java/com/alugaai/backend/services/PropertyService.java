package com.alugaai.backend.services;

import com.alugaai.backend.dtos.api.ViaCepResponseDTO;
import com.alugaai.backend.dtos.college.CollegeRequestDTO;
import com.alugaai.backend.dtos.college.CollegeResponseDTO;
import com.alugaai.backend.dtos.mappers.CollegeMapper;
import com.alugaai.backend.dtos.mappers.PropertyMapper;
import com.alugaai.backend.dtos.property.PropertyDetailedResponseDTO;
import com.alugaai.backend.dtos.property.PropertyRequestDTO;
import com.alugaai.backend.dtos.property.PropertyResponseDTO;
import com.alugaai.backend.models.*;
import com.alugaai.backend.repositories.PropertyRepository;
import com.alugaai.backend.repositories.specification.PropertySpecifications;
import com.alugaai.backend.services.errors.CustomException;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import static com.alugaai.backend.repositories.specification.StudentSpecifications.hasRole;

@Service
@RequiredArgsConstructor
public class PropertyService {

    private final ImageService imageService;
    private final PropertyRepository propertyRepository;
    private final GeocoderService geocoderService;


    @Transactional
    public void post(PropertyRequestDTO request, Owner owner) {
        ViaCepResponseDTO result = geocoderService.getLatLongFromAddress(request.address());

        Property property = createProperty(request, result, owner);
        property = propertyRepository.save(property);

        property = propertyRepository.save(property);
    }

    @Transactional(readOnly = true)
    public List<PropertyResponseDTO> listAll(Double maxPrice) {

        Specification<Property> spec = Specification.where(PropertySpecifications.maxPrice(maxPrice));

        return propertyRepository.findAll(spec).stream()
                .map(property -> PropertyMapper.topropertyResponseDTO(
                        property,
                        property.getImages().stream()
                                .map(Image::getId)
                                .collect(Collectors.toList())
                ))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public PropertyDetailedResponseDTO findById(@NotNull Integer id) {
        var property = propertyRepository.findById(id).orElseThrow(() -> new CustomException("Property with this id " +
                "not " +
                "found",
         null, HttpStatus.NOT_FOUND.value()));
        return PropertyMapper.propertyDetailedResponseDTO(property);
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
        property.setPrice(request.address().price());
        property.setImages(new ArrayList<>());
        return property;
    }

}
