package com.alugaai.backend.dtos.image;

import jakarta.validation.constraints.NotNull;

public record ImageRequestDTO(@NotNull String imageData64) {
}
