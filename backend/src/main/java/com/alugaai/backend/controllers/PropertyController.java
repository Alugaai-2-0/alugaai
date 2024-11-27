package com.alugaai.backend.controllers;

import com.alugaai.backend.dtos.property.PropertyRequestDTO;
import com.alugaai.backend.dtos.property.PropertyResponseDTO;
import com.alugaai.backend.models.Owner;
import com.alugaai.backend.services.PropertyService;
import com.alugaai.backend.services.UserService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/property")
@AllArgsConstructor
public class PropertyController {

    private final UserService userService;
    private final PropertyService propertyService;

    @PostMapping()
    public ResponseEntity post(@RequestBody PropertyRequestDTO request) {
       var user = userService.getCurrentUser();
       propertyService.post(request, (Owner) user);
       return ResponseEntity.noContent().build();
    }

    @GetMapping()
    public ResponseEntity<List<PropertyResponseDTO>> findAll() {
        return ResponseEntity.ok(propertyService.listAll());
    }

}
