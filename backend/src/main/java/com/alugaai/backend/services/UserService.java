package com.alugaai.backend.services;

import com.alugaai.backend.models.Role;
import com.alugaai.backend.models.User;
import com.alugaai.backend.repositories.RoleRepository;
import com.alugaai.backend.repositories.UserRepository;
import com.alugaai.backend.services.errors.CustomException;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final RoleRepository roleRepository;

    public User registerNewUser(User incomingUser, String incomingRole) throws CustomException {
        try {
            incomingUser.setPasswordHash(passwordEncoder.encode(incomingUser.getPassword()));
            Role.RoleName roleNameEnum = Role.RoleName.valueOf(incomingRole);
            var role = roleRepository.findByRoleName(roleNameEnum)
                    .orElseThrow(() -> new CustomException("Role not found", HttpStatus.NOT_FOUND.value(), null));
            incomingUser.getRoles().add(role);
            return userRepository.save(incomingUser);
        } catch (IllegalArgumentException e) {
            throw new CustomException("Invalid role: " + incomingRole, HttpStatus.BAD_REQUEST.value(), null);

        } catch (CustomException e) {
            throw e;

        } catch (Exception e) {
            throw new CustomException("Error registering user: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR.value(), null);
        }
    }

}

