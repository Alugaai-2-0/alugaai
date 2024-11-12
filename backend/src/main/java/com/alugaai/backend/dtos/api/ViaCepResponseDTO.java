package com.alugaai.backend.dtos.api;

public record ViaCepResponseDTO(
        String cep,
        String logradouro,
        String complemento,
        String unidade,
        String bairro,
        String localidade,
        String uf,
        String estado,
        String regiao,
        String ibge,
        String gia,
        String ddd,
        String siafi,
        LatLongResponse latLong
) {
    public ViaCepResponseDTO(String cep, String logradouro, String complemento, String unidade,
                             String bairro, String localidade, String uf, String estado, String regiao,
                             String ibge, String gia, String ddd, String siafi) {
        this(cep, logradouro, complemento, unidade, bairro, localidade, uf, estado, regiao, ibge, gia, ddd, siafi, null);
    }
}
