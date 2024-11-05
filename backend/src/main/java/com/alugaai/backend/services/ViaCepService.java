package com.alugaai.backend.services;

import com.alugaai.backend.dtos.api.ViaCepResponseDTO;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
@AllArgsConstructor
public class ViaCepService {

    private final RestTemplate restTemplate;
    private static final String VIA_CEP_URL = "https://viacep.com.br/ws/";

    public ViaCepResponseDTO findAddressByCep(String cep) {
        String url = VIA_CEP_URL + cep + "/json";
        return restTemplate.getForObject(url, ViaCepResponseDTO.class);
    }
}
