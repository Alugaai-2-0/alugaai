package com.alugaai.backend.controllers;

import com.alugaai.backend.dtos.api.ViaCepResponseDTO;
import com.alugaai.backend.dtos.college.CollegeRequestDTO;
import com.alugaai.backend.dtos.college.CollegeResponseDTO;
import com.alugaai.backend.services.CollegeService;
import com.alugaai.backend.services.ViaCepService;
import com.alugaai.backend.services.errors.CustomException;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/college")
@AllArgsConstructor
public class CollegeController {

    private final CollegeService collegeService;

    @PostMapping()
    public ResponseEntity<CollegeResponseDTO> post(@RequestBody CollegeRequestDTO request) {
        try {
            return ResponseEntity.ok(collegeService.post(request));
        } catch (Exception e) {
            throw new CustomException(e.getMessage(), HttpStatus.BAD_REQUEST.value(), null);
        }
    };

    @GetMapping()
    public ResponseEntity<List<CollegeResponseDTO>> getAll() {
        try {
            return ResponseEntity.ok(collegeService.listAll());
        } catch (Exception e) {
            throw new CustomException(e.getMessage(), HttpStatus.BAD_REQUEST.value(), null);
        }
    }

}
