package com.alugaai.backend.services;

import com.alugaai.backend.models.*;
import com.alugaai.backend.repositories.ImageRepository;
import com.alugaai.backend.repositories.RoleRepository;
import com.alugaai.backend.repositories.UserRepository;
import com.alugaai.backend.services.errors.CustomException;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashSet;

@Service
@AllArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final RoleRepository roleRepository;
    private final ImageRepository imageRepository;

    public User registerNewStudent(Student student) throws CustomException {
        return registerUser(student, Role.RoleName.ROLE_STUDENT);
    }


    public User registerNewOwner(Owner owner) throws CustomException {
        return registerUser(owner, Role.RoleName.ROLE_OWNER);
    }

    @Transactional
    public <T extends User> T registerUser(T user, Role.RoleName roleName) throws CustomException {
        try {
            var existUser = userRepository.findByEmailOrCpfOrPhoneNumber(
                    user.getEmail(),
                    user.getCpf(),
                    user.getPhoneNumber()
            );

            if (existUser.isPresent()) {
                throw new CustomException(
                        "This cpf, email or phone already exists",
                        HttpStatus.BAD_REQUEST.value(),
                        null
                );
            }

            user.setPasswordHash(passwordEncoder.encode(user.getPassword()));

            if (user.getRoles() == null) {
                user.setRoles(new HashSet<>());
            }

            var role = roleRepository.findByRoleName(roleName)
                    .orElseThrow(() -> new CustomException(
                            "Role not found",
                            HttpStatus.NOT_FOUND.value(),
                            null
                    ));
            user.getRoles().add(role);

            return userRepository.save(user);

        } catch (IllegalArgumentException e) {
            throw new CustomException(
                    "Invalid role: " + roleName,
                    HttpStatus.BAD_REQUEST.value(),
                    null
            );
        } catch (Exception e) {
            throw new CustomException(
                    "Error registering user: " + e.getMessage(),
                    HttpStatus.BAD_REQUEST.value(),
                    null
            );
        }
    }

    public User authenticateUser(String identifier, String password) throws CustomException {
        User user = userRepository.findByEmailOrCpfOrPhoneNumber(identifier, identifier, identifier)
                .orElseThrow(() -> new CustomException("User not " +
                "found", HttpStatus.NOT_FOUND.value(), null));

        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new CustomException("Invalid credentials", HttpStatus.UNAUTHORIZED.value(), null);
        }

        return user;
    }
}
