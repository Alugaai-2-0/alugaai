package com.alugaai.backend.controllers;


import com.alugaai.backend.dtos.student.StudentFeedResponseDTO;
import com.alugaai.backend.services.StudentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import jakarta.validation.constraints.Min;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;

@RestController
@Path("/student")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
@AllArgsConstructor
public class StudentController {

    private final StudentService studentService;

    @POST
    @Path("/{id}")
    public void addPersonalities(Set<String> personalities, @PathParam("id") Integer id) {
        studentService.addPersonalities(personalities, id);
    }

    @GET
    @Path("/get-all")
    public ResponseEntity<List<StudentFeedResponseDTO>> getAllStudents(
            @RequestParam(required = false) Integer minAge,
            @RequestParam(required = false) Integer maxAge,
            @RequestParam(required = false) Set<String> personalities
    ) {
        return ResponseEntity.ok(studentService.getAllStudents(minAge, maxAge, personalities));
    }

}
