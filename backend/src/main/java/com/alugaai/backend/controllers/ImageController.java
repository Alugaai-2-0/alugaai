package com.alugaai.backend.controllers;

import com.alugaai.backend.dtos.auth.LoginRequestDTO;
import com.alugaai.backend.dtos.auth.LoginResponseDTO;
import com.alugaai.backend.dtos.image.ImageRequestDTO;
import com.alugaai.backend.dtos.image.ImageResponseDTO;
import com.alugaai.backend.dtos.mappers.LoginMapper;
import com.alugaai.backend.dtos.mappers.UserMapper;
import com.alugaai.backend.dtos.user.UserRegisterRequestDTO;
import com.alugaai.backend.models.Owner;
import com.alugaai.backend.models.Role;
import com.alugaai.backend.models.Student;
import com.alugaai.backend.models.User;
import com.alugaai.backend.security.SecurityService;
import com.alugaai.backend.services.ImageService;
import com.alugaai.backend.services.UserService;
import com.alugaai.backend.services.errors.CustomException;
import jakarta.validation.constraints.NotNull;
import jakarta.websocket.server.PathParam;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.NoSuchElementException;

@RestController
@RequestMapping("/image")
@AllArgsConstructor
public class ImageController {

    private final ImageService imageService;

    @PostMapping
    public ResponseEntity<ImageResponseDTO> post(@RequestParam("file") MultipartFile file) {
        try {
            return ResponseEntity.ok(imageService.post(file));
        } catch (Exception e) {
            throw new CustomException(e.getMessage(), 400, null);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<ImageResponseDTO> getById(@PathVariable @NotNull Integer id) {
        try {
            return ResponseEntity.ok(imageService.getById(id));
        } catch (NoSuchElementException e) {
            throw new CustomException(e.getMessage(), 400, null);
        }
    }

}

