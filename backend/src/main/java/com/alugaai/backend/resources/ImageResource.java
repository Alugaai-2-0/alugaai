package com.alugaai.backend.resources;

import com.alugaai.backend.dtos.image.ImageResponseDTO;
import com.alugaai.backend.services.ImageService;
import com.alugaai.backend.services.errors.CustomException;
import jakarta.validation.constraints.NotNull;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.NoSuchElementException;

@RestController
@Path("/image")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
@AllArgsConstructor
public class ImageResource {

    private final ImageService imageService;

    @POST
    public ResponseEntity<ImageResponseDTO> post(@RequestParam("file") MultipartFile file) {
        try {
            return ResponseEntity.ok(imageService.post(file));
        } catch (Exception e) {
            throw new CustomException(e.getMessage(), 400, null);
        }
    }

    @GET
    @Path("{id}")
    public ResponseEntity<ImageResponseDTO> getById(@PathParam("id") @NotNull Integer id) {
        try {
            return ResponseEntity.ok(imageService.getById(id));
        } catch (NoSuchElementException e) {
            throw new CustomException(e.getMessage(), 400, null);
        }
    }

}

