package com.alugaai.backend.controllers;

import com.alugaai.backend.models.User;
import com.alugaai.backend.services.UserService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/auth")
@AllArgsConstructor
public class AuthController {

    private UserService userService;

    @PostMapping("/register")
    public ResponseEntity<String> registerUser() {
        userService.registerNewUser(new User(LocalDateTime.now(), LocalDateTime.now(), 'M', "joao", "joao@gmail.com",
         "senhafoda"), "ROLE_ADMIN");
        return ResponseEntity.ok("User registered successfully!");
    }
}

