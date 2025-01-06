package com.alugaai.backend.controllers;

import com.alugaai.backend.dtos.property.PropertyDetailedResponseDTO;
import com.alugaai.backend.dtos.property.PropertyRequestDTO;
import com.alugaai.backend.dtos.property.PropertyResponseDTO;
import com.alugaai.backend.models.Owner;
import com.alugaai.backend.services.PropertyService;
import com.alugaai.backend.services.UserService;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Path("/property")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
@AllArgsConstructor
public class PropertyController {

    private final UserService userService;
    private final PropertyService propertyService;

    @POST
    public ResponseEntity post(@RequestBody PropertyRequestDTO request) {
       var user = userService.getCurrentUser();
       propertyService.post(request, (Owner) user);
       return ResponseEntity.noContent().build();
    }

    @GET
    public ResponseEntity<List<PropertyResponseDTO>> findAll(
            @RequestParam(required = false) Double price
            ) {
        return ResponseEntity.ok(propertyService.listAll(price));
    }

    @GET
    @Path("/{id}")
    public ResponseEntity<PropertyDetailedResponseDTO> findById(@PathParam("id") Integer id) {
        return ResponseEntity.ok(propertyService.findById(id));
    }



}
