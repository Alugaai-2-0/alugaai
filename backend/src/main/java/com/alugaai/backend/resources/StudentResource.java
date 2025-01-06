package com.alugaai.backend.resources;


import com.alugaai.backend.dtos.student.StudentFeedResponseDTO;
import com.alugaai.backend.services.StudentService;
import jakarta.annotation.security.RolesAllowed;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Set;

@Component
@Path("/student")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
@AllArgsConstructor
public class StudentResource {

    private final StudentService studentService;

    @POST
    @RolesAllowed({"STUDENT"})
    public void addPersonalities(Set<String> personalities) {
        studentService.addPersonalities(personalities);
    }

    @GET
    @Path("/get-all")
    public Response getAllStudents(
            @QueryParam("minAge") Integer minAge,
            @QueryParam("maxAge") Integer maxAge,
            @QueryParam("personalities") Set<String> personalities
    ) {
        List<StudentFeedResponseDTO> students = studentService.getAllStudents(minAge, maxAge, personalities);

        if (students.isEmpty()) {
            return Response.status(Response.Status.NOT_FOUND).build();
        }

        return Response.ok(students).build();
    }

}
