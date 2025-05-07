package com.alugaai.backend.resources;

import com.alugaai.backend.dtos.student.StudentFeedResponseDTO;
import com.alugaai.backend.services.StudentService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;

@RestController
@RequestMapping(value = "/student")
@AllArgsConstructor
public class StudentResource {

    private final StudentService studentService;

    @PostMapping(consumes = "application/json")
    @PreAuthorize("hasRole('STUDENT')")
    public void addPersonalities(@RequestBody Set<String> personalities) {
        studentService.addPersonalities(personalities);
    }

    @GetMapping("/get-all")
    public ResponseEntity<?> getAllStudents(
            @RequestParam(value = "minAge", required = false) Integer minAge,
            @RequestParam(value = "maxAge", required = false) Integer maxAge,
            @RequestParam(value = "personalities", required = false) Set<String> personalities
    ) {
        List<StudentFeedResponseDTO> students = studentService.getAllStudents(minAge, maxAge, personalities);

        if (students.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(students);
    }
}