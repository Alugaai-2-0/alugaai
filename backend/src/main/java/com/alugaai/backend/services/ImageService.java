package com.alugaai.backend.services;

import com.alugaai.backend.dtos.image.ImageRequestDTO;
import com.alugaai.backend.dtos.image.ImageResponseDTO;
import com.alugaai.backend.dtos.mappers.ImageMapper;
import com.alugaai.backend.models.Building;
import com.alugaai.backend.models.Image;
import com.alugaai.backend.repositories.ImageRepository;
import com.alugaai.backend.services.errors.CustomException;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class ImageService {

    private final ImageRepository imageRepository;

    public ImageResponseDTO post(MultipartFile file) {
        try {
            var image = new Image();

            byte[] imageData = file.getBytes();
            image.setImageData(imageData);
            image.setInsertedOn(LocalDateTime.now());

            imageRepository.save(image);

            if (image.getId() != null) {
                return ImageMapper.toImageResponseDTO(image);
            }
        } catch (IOException e) {
            throw new CustomException("Error reading file", HttpStatus.BAD_REQUEST.value(), null);
        }
        return null;
    }

    public ImageResponseDTO getById(@NotNull Integer id) {
        var image = imageRepository.findById(id).orElseThrow( () -> new CustomException("Image not found",
                HttpStatus.NOT_FOUND.value(), null));
        return ImageMapper.toImageResponseDTO(image);
    }

    public List<Image> processImages(List<ImageRequestDTO> imageRequests, Building building) {
        return imageRequests.stream()
                .map(imageRequest -> {
                    Image newImage = new Image();
                    newImage.setImageData(imageRequest.toByteArray());
                    newImage.setBuilding(building);
                    return imageRepository.save(newImage);
                })
                .collect(Collectors.toList());
    }

}
