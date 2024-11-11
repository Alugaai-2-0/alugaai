package com.alugaai.backend.services;

import com.alugaai.backend.dtos.AddressRequestDTO;
import com.alugaai.backend.dtos.api.GeocodeResponse;
import com.alugaai.backend.dtos.api.LatLongResponse;
import com.alugaai.backend.dtos.api.ViaCepResponseDTO;
import com.alugaai.backend.services.errors.CustomException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;

@Service
public class GeocoderService {

    private final RestTemplate restTemplate;
    private final ViaCepService viaCepService;

    @Value("${geocode.api.key}")
    private String apiKey;

    public GeocoderService(RestTemplate restTemplate, ViaCepService viaCepService) {
        this.restTemplate = restTemplate;
        this.viaCepService = viaCepService;
    }

    public ViaCepResponseDTO getLatLongFromAddress(AddressRequestDTO addressRequest) {
        ViaCepResponseDTO address = viaCepService.findAddressByCep(addressRequest.cep());

        String fullAddress = String.format("%s %s, %s, %s, %s",
                address.logradouro(),
                addressRequest.homeNumber(),
                address.bairro(),
                address.localidade(),
                address.uf()
        );

        URI uri = UriComponentsBuilder.fromHttpUrl("https://maps.googleapis.com/maps/api/geocode/json")
                .queryParam("address", fullAddress)
                .queryParam("key", apiKey)
                .build()
                .toUri();

        GeocodeResponse response = restTemplate.getForObject(uri, GeocodeResponse.class);

        if (response != null && !response.getResults().isEmpty()) {
            GeocodeResponse.Result result = response.getResults().get(0);
            GeocodeResponse.Location location = result.getGeometry().getLocation();
            LatLongResponse latLong = new LatLongResponse(
                    String.valueOf(location.getLat()),
                    String.valueOf(location.getLng())
            );

            return new ViaCepResponseDTO(
                    address.cep(),
                    address.logradouro(),
                    address.complemento(),
                    address.unidade(),
                    address.bairro(),
                    address.localidade(),
                    address.uf(),
                    address.estado(),
                    address.regiao(),
                    address.ibge(),
                    address.gia(),
                    address.ddd(),
                    address.siafi(),
                    latLong
            );
        }

        throw new CustomException(
                "Nenhum resultado encontrado para o endereço: " + fullAddress,
                HttpStatus.BAD_REQUEST.value(),
                null
        );
    }
}
