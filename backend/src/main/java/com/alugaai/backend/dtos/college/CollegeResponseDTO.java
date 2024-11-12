package com.alugaai.backend.dtos.college;

import java.util.List;

public record CollegeResponseDTO(
        Integer id,
        String address,
        String collegeName,
        String homeNumber,
        String homeComplement,
        String neighborhood,
        String district,
        String latitude,
        String longitude,
        List<Integer> collegeImagesIds

) {
}
