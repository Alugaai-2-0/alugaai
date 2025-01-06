package com.alugaai.backend.resources;

import com.alugaai.backend.dtos.auth.LoginRequestDTO;
import com.alugaai.backend.dtos.auth.LoginResponseDTO;
import com.alugaai.backend.dtos.user.UserRegisterRequestDTO;
import com.alugaai.backend.dtos.mappers.LoginMapper;
import com.alugaai.backend.dtos.mappers.UserMapper;
import com.alugaai.backend.models.Owner;
import com.alugaai.backend.models.Role;
import com.alugaai.backend.models.Student;
import com.alugaai.backend.models.User;
import com.alugaai.backend.security.SecurityService;
import com.alugaai.backend.services.UserService;
import com.alugaai.backend.services.errors.CustomException;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;

@Component
@Path("/auth")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
@AllArgsConstructor
public class AuthResource {

    private final UserService userService;
    private final SecurityService jwtSecurity;

    // we need to pass the role to PathVariable equals ROLE_STUDENT | ROLE_OWNER
    @POST
    @Path("/register/{role}")
    public Response registerUser(
            @PathParam("role") String role,
            UserRegisterRequestDTO dto) {
        try {
            User savedUser;
            if (role.equals(Role.RoleName.ROLE_OWNER.toString())) {
                Owner owner = UserMapper.toOwnerEntity(dto);
                savedUser = userService.registerNewOwner(owner);
            } else if (role.equals(Role.RoleName.ROLE_STUDENT.toString())) {
                Student student = UserMapper.toStudentEntity(dto);
                savedUser = userService.registerNewStudent(student);
            } else {
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity("Invalid role: " + role)
                        .build();
            }
            return Response.ok(UserMapper.toDTO(savedUser)).build();
        } catch (CustomException e) {
            return Response.status(e.getStatusCode())
                    .entity(e.getMessage())
                    .build();
        }
    }

    @POST
    @Path("/login")
    public Response login(LoginRequestDTO loginRequest) {
        try {
            User authenticatedUser = userService.authenticateUser(
                    loginRequest.identifier(),
                    loginRequest.password()
            );
            String token = jwtSecurity.generateToken(authenticatedUser);
            return Response.ok(LoginMapper.toDTO(authenticatedUser, token)).build();
        } catch (CustomException e) {
            return Response.status(Response.Status.UNAUTHORIZED).build();
        }
    }


}

