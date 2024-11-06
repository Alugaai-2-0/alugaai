package com.alugaai.backend.services;

import com.alugaai.backend.dtos.college.CollegeRequestDTO;
import com.alugaai.backend.dtos.college.CollegeResponseDTO;
import com.alugaai.backend.repositories.BuildingRepository;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class CollegeService {

    private final BuildingRepository buildingRepository;
    private final ViaCepService viaCepService;

    public void post(CollegeRequestDTO request) {

        var address = viaCepService.findAddressByCep(request.cep());



    };

}
