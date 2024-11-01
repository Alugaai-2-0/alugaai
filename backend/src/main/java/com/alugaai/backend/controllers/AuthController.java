package com.alugaai.backend.controllers;

import com.alugaai.backend.dtos.UserRegisterDTO;
import com.alugaai.backend.dtos.mappers.UserMapper;
import com.alugaai.backend.models.Owner;
import com.alugaai.backend.models.Role;
import com.alugaai.backend.models.Student;
import com.alugaai.backend.models.User;
import com.alugaai.backend.services.UserService;
import com.alugaai.backend.services.errors.CustomException;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/auth")
@AllArgsConstructor
public class AuthController {

    private UserService userService;

    // we need to pass the role to PathVariable equals ROLE_STUDENT | ROLE_OWNER
    @PostMapping("/register/{role}")
    public ResponseEntity<UserRegisterDTO> registerUser(@PathVariable String role, @RequestBody UserRegisterDTO dto) throws CustomException {

        User savedUser;

        if (role.equals(Role.RoleName.ROLE_OWNER.toString())) {
            Owner owner = UserMapper.toOwnerEntity(dto);
            savedUser = userService.registerNewOwner(owner);
        } else if (role.equals(Role.RoleName.ROLE_STUDENT.toString())) {
            Student student = UserMapper.toStudentEntity(dto);
            savedUser = userService.registerNewStudent(student);
        } else {
            throw new CustomException("Invalid role: " + role, HttpStatus.BAD_REQUEST.value(), null);
        }

        return ResponseEntity.ok(UserMapper.toDTO(savedUser));
    }
}

