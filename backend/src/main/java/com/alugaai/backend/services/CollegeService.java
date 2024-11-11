package com.alugaai.backend.services;

import com.alugaai.backend.dtos.api.LatLongResponse;
import com.alugaai.backend.dtos.api.ViaCepResponseDTO;
import com.alugaai.backend.dtos.college.CollegeRequestDTO;
import com.alugaai.backend.dtos.college.CollegeResponseDTO;
import com.alugaai.backend.dtos.image.ImageRequestDTO;
import com.alugaai.backend.dtos.mappers.CollegeMapper;
import com.alugaai.backend.models.College;
import com.alugaai.backend.models.Image;
import com.alugaai.backend.repositories.BuildingRepository;
import com.alugaai.backend.repositories.ImageRepository;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;

@Service
@AllArgsConstructor
public class CollegeService {

    private final BuildingRepository buildingRepository;
    private final ImageRepository imageRepository;
    private final GeocoderService geocoderService;

    @Transactional
    public CollegeResponseDTO post(CollegeRequestDTO request) {
        ViaCepResponseDTO result = geocoderService.getLatLongFromAddress(request.address());

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

        college = buildingRepository.save(college);

        var images = new ArrayList<Image>();
        for (ImageRequestDTO imageRequest : request.collegesImages()) {
            var newImage = new Image();
            newImage.setImageData(imageRequest.toByteArray());
            newImage.setBuilding(college);
            newImage = imageRepository.save(newImage);
            images.add(newImage);
        }

        college.setImages(images);
        college = buildingRepository.save(college);

        return CollegeMapper.toCollegeResponseDTO(
                college,
                college.getImages().stream().map(Image::getId).toList()
        );
    }

}
