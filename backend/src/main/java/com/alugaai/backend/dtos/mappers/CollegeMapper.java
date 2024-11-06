package com.alugaai.backend.dtos.mappers;

import com.alugaai.backend.dtos.api.ViaCepResponseDTO;
import com.alugaai.backend.dtos.college.CollegeResponseDTO;
import com.alugaai.backend.dtos.image.ImageResponseDTO;
import com.alugaai.backend.models.College;
import com.fasterxml.jackson.databind.JsonNode;

import java.util.List;

public class CollegeMapper {
    public static CollegeResponseDTO toCollegeResponseDTO(College college, List<Integer> collegeImagesIds) {
        return new CollegeResponseDTO(
                college.getId(),
                college.getAddress(),
                college.getCollegeName(),
                college.getHomeNumber(),
                college.getHomeComplement(),
                college.getNeighborhood(),
                college.getDistrict(),
                college.getLatitude(),
                college.getLongitude(),
                collegeImagesIds
        );
    }
}
