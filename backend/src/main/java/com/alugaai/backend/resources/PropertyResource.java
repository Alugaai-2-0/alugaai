package com.alugaai.backend.resources;

import com.alugaai.backend.dtos.property.PropertyDetailedResponseDTO;
import com.alugaai.backend.dtos.property.PropertyRequestDTO;
import com.alugaai.backend.dtos.property.PropertyResponseDTO;
import com.alugaai.backend.models.Owner;
import com.alugaai.backend.services.PropertyService;
import com.alugaai.backend.services.UserService;
import jakarta.annotation.security.RolesAllowed;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Component
@Path("/property")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
@AllArgsConstructor
public class PropertyResource {

    private final UserService userService;
    private final PropertyService propertyService;

    @POST
    @RolesAllowed({"OWNER"})
    public Response post(PropertyRequestDTO request) {
        var user = userService.getCurrentUser();
        propertyService.post(request, (Owner) user);
        return Response.status(Response.Status.NO_CONTENT).build();
    }

    @GET
    public Response findAll(@QueryParam("price") Double price) {
        List<PropertyResponseDTO> properties = propertyService.listAll(price);
        return Response.ok(properties).build();
    }

    @GET
    @Path("/{id}")
    public Response findById(@PathParam("id") Integer id) {
        PropertyDetailedResponseDTO property = propertyService.findById(id);
        return Response.ok(property).build();
    }



}
