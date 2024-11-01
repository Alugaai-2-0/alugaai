package com.alugaai.backend.dtos;

import jakarta.validation.constraints.NotNull;

public record ImageDTO(@NotNull String imageData64) {
}
