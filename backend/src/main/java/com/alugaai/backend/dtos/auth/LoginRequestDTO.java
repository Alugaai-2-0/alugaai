package com.alugaai.backend.dtos.auth;

import lombok.Getter;

public record LoginRequestDTO(
        String identifier, // cpf or email
        String password
) {
}
