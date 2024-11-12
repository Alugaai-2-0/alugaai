package com.alugaai.backend.dtos.mappers;

import com.alugaai.backend.dtos.api.LatLongResponse;
import com.alugaai.backend.dtos.api.ViaCepResponseDTO;
import com.fasterxml.jackson.databind.JsonNode;

public class ViaCepMapper {
    public static ViaCepResponseDTO toDTO(JsonNode json, LatLongResponse latLong) {
        return new ViaCepResponseDTO(
                json.path("cep").asText(),
                json.path("logradouro").asText(),
                json.path("complemento").asText(),
                json.path("unidade").asText(),
                json.path("bairro").asText(),
                json.path("localidade").asText(),
                json.path("uf").asText(),
                json.path("estado").asText(),
                json.path("regiao").asText(),
                json.path("ibge").asText(),
                json.path("gia").asText(),
                json.path("ddd").asText(),
                json.path("siafi").asText(),
                latLong
        );
    }
}
