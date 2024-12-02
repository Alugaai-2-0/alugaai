package com.alugaai.backend.dtos.college;

import com.alugaai.backend.dtos.AddressRequestDTO;
import com.alugaai.backend.dtos.image.ImageRequestDTO;

import java.util.List;

public record CollegeRequestDTO(
        AddressRequestDTO address,
        String collegeName
) {
}
