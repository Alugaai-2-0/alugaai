package com.alugaai.backend.resources;

import com.alugaai.backend.dtos.college.CollegeRequestDTO;
import com.alugaai.backend.dtos.college.CollegeResponseDTO;
import com.alugaai.backend.services.CollegeService;
import com.alugaai.backend.services.errors.CustomException;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Path("/college")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
@AllArgsConstructor
public class CollegeResource {

    private final CollegeService collegeService;

    @POST
    public ResponseEntity<CollegeResponseDTO> post(@RequestBody CollegeRequestDTO request) {
        try {
            return ResponseEntity.ok(collegeService.post(request));
        } catch (Exception e) {
            throw new CustomException(e.getMessage(), HttpStatus.BAD_REQUEST.value(), null);
        }
    };

    @GET
    public ResponseEntity<List<CollegeResponseDTO>> getAll() {
        try {
            return ResponseEntity.ok(collegeService.listAll());
        } catch (Exception e) {
            throw new CustomException(e.getMessage(), HttpStatus.BAD_REQUEST.value(), null);
        }
    }

}
