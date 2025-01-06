package com.alugaai.backend.resources;

import com.alugaai.backend.dtos.image.ImageResponseDTO;
import com.alugaai.backend.services.ImageService;
import com.alugaai.backend.services.errors.CustomException;
import jakarta.validation.constraints.NotNull;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import lombok.AllArgsConstructor;
import org.glassfish.jersey.media.multipart.FormDataParam;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.NoSuchElementException;

@Component
@Path("/image")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
@AllArgsConstructor
public class ImageResource {

    private final ImageService imageService;

    @POST
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    public Response post(@FormDataParam("file") MultipartFile file) {
        try {
            ImageResponseDTO response = imageService.post(file);
            return Response.ok(response).build();
        } catch (Exception e) {
            return Response.status(400).entity(e.getMessage()).build();
        }
    }

    @GET
    @Path("{id}")
    public Response getById(@PathParam("id") @NotNull Integer id) {
        try {
            ImageResponseDTO response = imageService.getById(id);
            return Response.ok(response).build();
        } catch (NoSuchElementException e) {
            return Response.status(404).entity(e.getMessage()).build();
        }
    }

}

