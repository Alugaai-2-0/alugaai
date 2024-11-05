package com.alugaai.backend.dtos.user;


import com.alugaai.backend.dtos.image.ImageRequestDTO;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;

public record UserRegisterRequestDTO(
        @NotNull LocalDateTime birthDate,
        @NotNull char gender,
        @NotNull String userName,
        @NotNull String email,
        @NotNull String password,
        @NotNull String cpf,
        @NotNull String phoneNumber,
        @NotNull ImageRequestDTO imageDTO
) {}
