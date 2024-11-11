package com.alugaai.backend.dtos;

public record AddressRequestDTO(
        String cep,
        String homeNumber
) {
}
