package com.alugaai.backend.controllers;


import com.alugaai.backend.dtos.student.StudentFeedResponseDTO;
import com.alugaai.backend.services.StudentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import jakarta.validation.constraints.Min;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;

@RestController
@RequestMapping("/student")
@AllArgsConstructor
public class StudentController {

    private final StudentService studentService;

    @PostMapping("/{id}")
    public void addPersonalities(Set<String> personalities, @PathVariable Integer id) {
        studentService.addPersonalities(personalities, id);
    }

    @GetMapping("/get-all")
    public ResponseEntity<List<StudentFeedResponseDTO>> getAllStudents(
            @RequestParam(required = false) Integer minAge,
            @RequestParam(required = false) Integer maxAge,
            @RequestParam(required = false) Set<String> personalities
    ) {
        return ResponseEntity.ok(studentService.getAllStudents(minAge, maxAge, personalities));
    }

}
