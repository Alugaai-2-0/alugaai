package com.alugaai.backend.services;

import com.alugaai.backend.dtos.image.ImageRequestDTO;
import com.alugaai.backend.dtos.image.ImageResponseDTO;
import com.alugaai.backend.dtos.mappers.ImageMapper;
import com.alugaai.backend.models.Image;
import com.alugaai.backend.repositories.ImageRepository;
import com.alugaai.backend.services.errors.CustomException;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@AllArgsConstructor
public class ImageService {

    private final ImageRepository imageRepository;

    public ImageResponseDTO post(ImageRequestDTO request) {
        try {
            var image = new Image();
            image.setImageData64(request.imageData64());
            image.setInsertedOn(LocalDateTime.now());
            imageRepository.save(image);
            if (image.getId() != null) {
                return ImageMapper.toImageResponseDTO(image);
            }
        } catch (Exception e) {
            throw  new CustomException(e.getMessage(), HttpStatus.BAD_REQUEST.value(), request);
        }
        return null;
    }
}
