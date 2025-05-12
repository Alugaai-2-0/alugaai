package com.alugaai.backend.resources;

import com.alugaai.backend.dtos.statistics.AllMonthlyRentResponseDTO;
import com.alugaai.backend.dtos.statistics.AllOwnersResponseDTO;
import com.alugaai.backend.dtos.statistics.AllPropertiesResponseDTO;
import com.alugaai.backend.dtos.statistics.AllStudentsResponseDTO;
import com.alugaai.backend.services.StatisticsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/statistics")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class StatisticsResource {

    private final StatisticsService statisticsService;

    @GetMapping("/getAllStudents")
    public ResponseEntity<?> getAllStudents() {
        try {
            AllStudentsResponseDTO response = statisticsService.getAllStudents();
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/getAllOwners")
    public ResponseEntity<?> getAllOwners() {
        try {
            AllOwnersResponseDTO response = statisticsService.getAllOwners();
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/getAllProperties")
    public ResponseEntity<?> getAllProperties() {
        try {
            AllPropertiesResponseDTO response = statisticsService.getAllProperties();
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/getAllMonthlyRent")
    public ResponseEntity<?> getAllMonthlyRent() {
        try {
            AllMonthlyRentResponseDTO response = statisticsService.getAllMonthlyRent();
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}