package com.alugaai.backend.services;

import com.alugaai.backend.models.Role;
import com.alugaai.backend.models.User;
import com.alugaai.backend.repositories.RoleRepository;
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
    private final RoleRepository roleRepository;

    public User registerNewUser(User incomingUser, String incomingRole) throws Exception {
        try {
            incomingUser.setPasswordHash(passwordEncoder.encode(incomingUser.getPassword()));
            var discriminator = incomingRole.split("_");
            Role.RoleName roleNameEnum = Role.RoleName.valueOf(incomingRole);
            var role = roleRepository.findByRoleName(roleNameEnum);
            incomingUser.getRoles().add(role.get());
            return userRepository.save(incomingUser);
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }
}

