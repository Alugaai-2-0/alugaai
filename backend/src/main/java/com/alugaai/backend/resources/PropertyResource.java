package com.alugaai.backend.resources;

import com.alugaai.backend.dtos.property.PropertyDetailedResponseDTO;
import com.alugaai.backend.dtos.property.PropertyRequestDTO;
import com.alugaai.backend.dtos.property.PropertyResponseDTO;
import com.alugaai.backend.models.Owner;
import com.alugaai.backend.services.PropertyService;
import com.alugaai.backend.services.UserService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(value = "/property")
@AllArgsConstructor
public class PropertyResource {

    private final UserService userService;
    private final PropertyService propertyService;

    @PostMapping
    @PreAuthorize("hasRole('OWNER')")
    public ResponseEntity<?> post(@RequestBody PropertyRequestDTO request) {
        var user = userService.getCurrentUser();
        propertyService.post(request, (Owner) user);
        return ResponseEntity.noContent().build();
    }

    @GetMapping
    public ResponseEntity<List<PropertyResponseDTO>> findAll(@RequestParam(value = "price", required = false) Double price) {
        List<PropertyResponseDTO> properties = propertyService.listAll(price);
        return ResponseEntity.ok(properties);
    }

    @GetMapping("/{id}")
    public ResponseEntity<PropertyDetailedResponseDTO> findById(@PathVariable("id") Integer id) {
        PropertyDetailedResponseDTO property = propertyService.findById(id);
        return ResponseEntity.ok(property);
    }
}