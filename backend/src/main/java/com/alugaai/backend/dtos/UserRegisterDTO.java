package com.alugaai.backend.dtos;


import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;

public record UserRegisterDTO(
        @NotNull LocalDateTime birthDate,
        @NotNull char gender,
        @NotNull String userName,
        @NotNull String email,
        @NotNull String password,
        @NotNull String cpf,
        @NotNull String phoneNumber,
        @NotNull ImageDTO imageDTO
) {}
