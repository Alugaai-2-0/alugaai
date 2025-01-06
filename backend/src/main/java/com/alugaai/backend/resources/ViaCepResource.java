package com.alugaai.backend.resources;

import com.alugaai.backend.dtos.api.ViaCepResponseDTO;
import com.alugaai.backend.services.ViaCepService;
import com.alugaai.backend.services.errors.CustomException;
import jakarta.validation.constraints.NotNull;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@Component
@Path("/cep")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@AllArgsConstructor
public class ViaCepResource {

    private final ViaCepService viaCepService;

    @GET
    @Path("/{cep}")
    public Response findAddressByCep(@PathParam("cep") @NotNull String cep) {
        try {
            ViaCepResponseDTO response = viaCepService.findAddressByCep(cep);
            return Response.ok(response).build();
        } catch (Exception e) {
            return Response.status(400).entity(e.getMessage()).build();
        }
    }

}
