package com.alugaai.backend.handlers;

import com.alugaai.backend.services.errors.CustomException;
import com.alugaai.backend.services.errors.ErrorResponseDTO;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(CustomException.class)
    public ResponseEntity<ErrorResponseDTO> handleCustomException(CustomException ex) {
        return new ResponseEntity<>(new ErrorResponseDTO(ex), HttpStatus.valueOf(ex.getStatusCode()));
    }

}
