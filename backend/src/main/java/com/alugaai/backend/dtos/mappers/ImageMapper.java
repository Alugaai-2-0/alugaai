package com.alugaai.backend.dtos.mappers;

import com.alugaai.backend.dtos.image.ImageResponseDTO;
import com.alugaai.backend.models.Image;

import java.util.Base64;

public class ImageMapper {
    public static ImageResponseDTO toImageResponseDTO(Image image) {
        return new ImageResponseDTO(
                image.getId(),
                Base64.getEncoder().encodeToString(image.getImageData()),
                image.getInsertedOn()
        );
    }
}
