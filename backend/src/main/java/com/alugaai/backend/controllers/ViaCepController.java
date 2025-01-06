package com.alugaai.backend.controllers;

import com.alugaai.backend.dtos.api.ViaCepResponseDTO;
import com.alugaai.backend.services.ViaCepService;
import com.alugaai.backend.services.errors.CustomException;
import jakarta.validation.constraints.NotNull;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Path("/cep")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@AllArgsConstructor
public class ViaCepController {

    private final ViaCepService viaCepService;

    @GET
    public ResponseEntity<ViaCepResponseDTO> findAddressByCep(@PathVariable @NotNull String cep) {
        try {
            return ResponseEntity.ok(viaCepService.findAddressByCep(cep));
        } catch (Exception e) {
            throw new CustomException(e.getMessage(), 400, null);
        }
    };

}
