package com.alugaai.backend.dtos.api;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class LatLongResponse {
    private String latitude;
    private String longitude;

}