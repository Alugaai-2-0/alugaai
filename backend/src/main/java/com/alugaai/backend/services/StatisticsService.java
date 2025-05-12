package com.alugaai.backend.services;

import com.alugaai.backend.dtos.statistics.AllMonthlyRentResponseDTO;
import com.alugaai.backend.dtos.statistics.AllOwnersResponseDTO;
import com.alugaai.backend.dtos.statistics.AllPropertiesResponseDTO;
import com.alugaai.backend.dtos.statistics.AllStudentsResponseDTO;
import com.alugaai.backend.repositories.OwnerRepository;
import com.alugaai.backend.repositories.PropertyRepository;
import com.alugaai.backend.repositories.StudentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class StatisticsService {

    private StudentRepository studentRepository;
    private OwnerRepository ownerRepository;
    private PropertyRepository propertyRepository;

    public AllStudentsResponseDTO getAllStudents() {
        return new AllStudentsResponseDTO(studentRepository.countStudents());
    }

    public AllOwnersResponseDTO getAllOwners() {
        return new AllOwnersResponseDTO(ownerRepository.countOwners());
    }

    public AllPropertiesResponseDTO getAllProperties() {
        return new AllPropertiesResponseDTO(propertyRepository.countProperties());
    }

    public AllMonthlyRentResponseDTO getAllMonthlyRent() {
        return new AllMonthlyRentResponseDTO(propertyRepository.countMonthlyRentalProperties());
    }


}
