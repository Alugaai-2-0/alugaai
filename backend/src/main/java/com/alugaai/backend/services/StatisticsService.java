package com.alugaai.backend.services;

import com.alugaai.backend.dtos.statistics.AllMonthlyRentResponseDTO;
import com.alugaai.backend.dtos.statistics.AllOwnersResponseDTO;
import com.alugaai.backend.dtos.statistics.AllPropertiesResponseDTO;
import com.alugaai.backend.dtos.statistics.AllStudentsResponseDTO;
import com.alugaai.backend.repositories.PropertyRepository;
import com.alugaai.backend.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class StatisticsService {

    private UserRepository userRepository;
    private PropertyRepository propertyRepository;

    public AllStudentsResponseDTO getAllStudents() {
        return new AllStudentsResponseDTO(userRepository.countStudents());
    }

    public AllOwnersResponseDTO getAllOwners() {
        return new AllOwnersResponseDTO(userRepository.countOwners());
    }

    public AllPropertiesResponseDTO getAllProperties() {
        return new AllPropertiesResponseDTO(propertyRepository.countProperties());
    }

    public AllMonthlyRentResponseDTO getAllMonthlyRent() {
        return new AllMonthlyRentResponseDTO(propertyRepository.countMonthlyRentalProperties());
    }


}
