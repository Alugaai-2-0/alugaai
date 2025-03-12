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
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(value = "/auth", consumes = "application/json", produces = "application/json")
@AllArgsConstructor
public class AuthResource {

    private final UserService userService;
    private final SecurityService jwtSecurity;

    // we need to pass the role to PathVariable equals ROLE_STUDENT | ROLE_OWNER
    @PostMapping("/register/{role}")
    public ResponseEntity<?> registerUser(
            @PathVariable("role") String role,
            @RequestBody UserRegisterRequestDTO dto) {
        try {
            User savedUser;
            if (role.equals(Role.RoleName.ROLE_OWNER.toString())) {
                Owner owner = UserMapper.toOwnerEntity(dto);
                savedUser = userService.registerNewOwner(owner);
            } else if (role.equals(Role.RoleName.ROLE_STUDENT.toString())) {
                Student student = UserMapper.toStudentEntity(dto);
                savedUser = userService.registerNewStudent(student);
            } else {
                return ResponseEntity.badRequest()
                        .body("Invalid role: " + role);
            }
            return ResponseEntity.ok(UserMapper.toDTO(savedUser));
        } catch (CustomException e) {
            return ResponseEntity.status(e.getStatusCode())
                    .body(e.getMessage());
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequestDTO loginRequest) {
        try {
            User authenticatedUser = userService.authenticateUser(
                    loginRequest.identifier(),
                    loginRequest.password()
            );
            String token = jwtSecurity.generateToken(authenticatedUser);
            return ResponseEntity.ok(LoginMapper.toDTO(authenticatedUser, token));
        } catch (CustomException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
    }
}