package com.alugaai.backend.services.errors;

import jakarta.annotation.Nullable;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;

@Getter
public class CustomException extends RuntimeException {

    @NotNull private final Integer statusCode;
    @Nullable private final Object object;

    public CustomException(@NotNull String message, @NotNull Integer statusCode, @Nullable Object object) {
        super(message);
        this.statusCode = statusCode;
        this.object = object;
    }

}
