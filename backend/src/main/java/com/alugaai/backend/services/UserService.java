package com.alugaai.backend.services;

import com.alugaai.backend.models.Role;
import com.alugaai.backend.models.User;
import com.alugaai.backend.repositories.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Set;

@Service
@AllArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    public User registerNewUser(User user, String role) {
        user.setPasswordHash(passwordEncoder.encode(user.getPassword()));
        user.setRoles(Set.of(new Role(role)));
        return userRepository.save(user);
    }
}

