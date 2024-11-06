package com.alugaai.backend.dtos.mappers;

import com.alugaai.backend.dtos.college.CollegeResponseDTO;
import com.alugaai.backend.dtos.image.ImageRequestDTO;
import com.alugaai.backend.dtos.image.ImageResponseDTO;
import com.alugaai.backend.models.College;
import com.alugaai.backend.models.Image;

import java.util.List;

public class ImageMapper {
    public static ImageResponseDTO toImageResponseDTO(Image image) {
        return new ImageResponseDTO(
                image.getId(),
                image.getImageData64(),
                image.getInsertedOn()
        );
    }
}
