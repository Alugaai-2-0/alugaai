package com.alugaai.backend.controllers;

import com.alugaai.backend.dtos.api.ViaCepResponseDTO;
import com.alugaai.backend.services.ViaCepService;
import com.alugaai.backend.services.errors.CustomException;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/cep")
@AllArgsConstructor
public class ViaCepController {

    private final ViaCepService viaCepService;

    @GetMapping("/{cep}")
    public ResponseEntity<ViaCepResponseDTO> findAddressByCep(@PathVariable @NotNull String cep) {
        try {
            return ResponseEntity.ok(viaCepService.findAddressByCep(cep));
        } catch (Exception e) {
            throw new CustomException(e.getMessage(), 400, null);
        }
    };

}
