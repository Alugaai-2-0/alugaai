package com.alugaai.backend.services;

import com.alugaai.backend.dtos.api.LatLongResponse;
import com.alugaai.backend.dtos.api.ViaCepResponseDTO;
import com.alugaai.backend.dtos.college.CollegeRequestDTO;
import com.alugaai.backend.dtos.college.CollegeResponseDTO;
import com.alugaai.backend.dtos.image.ImageRequestDTO;
import com.alugaai.backend.dtos.mappers.CollegeMapper;
import com.alugaai.backend.models.Building;
import com.alugaai.backend.models.College;
import com.alugaai.backend.models.Image;
import com.alugaai.backend.repositories.BuildingRepository;
import com.alugaai.backend.repositories.CollegeRepository;
import com.alugaai.backend.repositories.ImageRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class CollegeService {

    private final CollegeRepository collegeRepository;
    private final BuildingRepository buildingRepository;
    private final ImageRepository imageRepository;
    private final GeocoderService geocoderService;
    private final ImageService imageService;

    @Transactional
    public CollegeResponseDTO post(CollegeRequestDTO request) {
        ViaCepResponseDTO result = geocoderService.getLatLongFromAddress(request.address());

        College college = createCollege(request, result);
        college = buildingRepository.save(college);

        college = buildingRepository.save(college);

        return CollegeMapper.toCollegeResponseDTO(
                college,
                college.getImages().stream()
                        .map(Image::getId)
                        .collect(Collectors.toList())
        );
    }

    @Transactional(readOnly = true)
    public List<CollegeResponseDTO> listAll() {
        return collegeRepository.findAll().stream()
                .map(college -> CollegeMapper.toCollegeResponseDTO(
                        college,
                        college.getImages().stream()
                                .map(Image::getId)
                                .collect(Collectors.toList())
                ))
                .collect(Collectors.toList());
    }

    private College createCollege(CollegeRequestDTO request, ViaCepResponseDTO result) {
        College college = new College();
        college.setCollegeName(request.collegeName());
        college.setAddress(result.logradouro());
        college.setHomeNumber(request.address().homeNumber());
        college.setHomeComplement(result.complemento());
        college.setNeighborhood(result.bairro());
        college.setDistrict(result.localidade());
        college.setLatitude(result.latLong().getLatitude());
        college.setLongitude(result.latLong().getLongitude());
        college.setImages(new ArrayList<>());
        return college;
    }

}