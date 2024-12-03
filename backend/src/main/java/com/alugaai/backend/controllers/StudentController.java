package com.alugaai.backend.controllers;


import com.alugaai.backend.services.StudentService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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



}
