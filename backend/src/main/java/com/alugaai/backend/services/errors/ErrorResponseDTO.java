package com.alugaai.backend.services.errors;

import jakarta.annotation.Nullable;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;

public record ErrorResponseDTO(@NotNull String message, @NotNull Integer statusCode,
                               @Nullable Object object, @Nullable LocalDateTime localDateTime) {

    public ErrorResponseDTO(@NotNull CustomException ex) {
        this(ex.getMessage(), ex.getStatusCode(), ex.getObject(), LocalDateTime.now());
    }
}
