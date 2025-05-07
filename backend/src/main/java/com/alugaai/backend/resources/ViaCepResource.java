package com.alugaai.backend.resources;

import com.alugaai.backend.dtos.api.ViaCepResponseDTO;
import com.alugaai.backend.services.ViaCepService;
import com.alugaai.backend.services.errors.CustomException;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(value = "/cep")
@AllArgsConstructor
public class ViaCepResource {

    private final ViaCepService viaCepService;

    @GetMapping("/{cep}")
    public ResponseEntity<?> findAddressByCep(@PathVariable("cep") @NotNull String cep) {
        try {
            ViaCepResponseDTO response = viaCepService.findAddressByCep(cep);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}