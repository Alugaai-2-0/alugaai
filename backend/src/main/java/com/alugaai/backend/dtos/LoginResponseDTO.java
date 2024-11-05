package com.alugaai.backend.dtos;

import java.time.LocalDateTime;
import java.util.List;

public record LoginResponseDTO(
        String token,
        List<String> roles,
        String email,
        String userName,
        String phoneNumber,
        LocalDateTime birthDate,
        Character gender,
        String cpf,
        Boolean phoneNumberConfirmed,
        Boolean twoFactorEnabled,
        LocalDateTime createdDate
) {
}
