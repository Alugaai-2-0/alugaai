package com.alugaai.backend.services;

import com.alugaai.backend.models.Owner;
import com.alugaai.backend.models.Role;
import com.alugaai.backend.models.Student;
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

    public User registerNewStudent(Student student) throws CustomException {
        return registerUser(student, Role.RoleName.ROLE_STUDENT);
    }

    public User registerNewOwner(Owner owner) throws CustomException {
        return registerUser(owner, Role.RoleName.ROLE_OWNER);
    }

    private <T extends User> T registerUser(T user, Role.RoleName roleName) throws CustomException {
        try {
            user.setPasswordHash(passwordEncoder.encode(user.getPassword()));

            var role = roleRepository.findByRoleName(roleName)
                    .orElseThrow(() -> new CustomException("Role not found", HttpStatus.NOT_FOUND.value(), null));
            user.getRoles().add(role);

            return userRepository.save(user);
        } catch (IllegalArgumentException e) {
            throw new CustomException("Invalid role: " + roleName, HttpStatus.BAD_REQUEST.value(), null);
        } catch (Exception e) {
            throw new CustomException("Error registering user: " + e.getMessage(), HttpStatus.BAD_REQUEST.value(), null);
        }
    }

    public User authenticateUser(String identifier, String password) throws CustomException {
        User user = userRepository.findByEmailOrCpf(identifier, identifier)
                .orElseThrow(() -> new CustomException("User not " +
                "found", HttpStatus.NOT_FOUND.value(), null));

        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new CustomException("Invalid credentials", HttpStatus.UNAUTHORIZED.value(), null);
        }

        return user;
    }
}
