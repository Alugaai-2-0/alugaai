package com.alugaai.backend.services;

import com.alugaai.backend.models.Student;
import com.alugaai.backend.repositories.UserRepository;
import com.alugaai.backend.services.errors.CustomException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Set;

@Service
@RequiredArgsConstructor
public class StudentService {

    private final UserRepository userRepository;

    @Transactional
    public void addPersonalities(Set<String> personalities, Integer id) {
        if (personalities == null || personalities.isEmpty()) {
            throw new CustomException(
                    "Personalities set cannot be null or empty",
                    null,
                    HttpStatus.BAD_REQUEST.value()
            );
        }

        var user = userRepository.findById(id)
                .orElseThrow(() -> new CustomException("User not found with id: " + id,
                        null, HttpStatus.BAD_REQUEST.value()));

        if (!(user instanceof Student)) {
            throw new CustomException(
                    "User is not a Student",
                    null,
                    HttpStatus.BAD_REQUEST.value()
            );
        }

        Student student = (Student) user;

        if (!student.getRoles().contains("ROLE_STUDENT")) {
            throw new CustomException(
                    "User does not have student role",
                    null,
                    HttpStatus.BAD_REQUEST.value()
            );
        }

        // Remove extra spaces and convert to lower case to default
        Set<String> normalizedPersonalities = personalities.stream()
                .map(p -> p.trim().toLowerCase())
                .collect(java.util.stream.Collectors.toSet());

        Set<String> existingPersonalities = student.getPersonalities();

        boolean hasOverlap = normalizedPersonalities.stream()
                .anyMatch(existingPersonalities::contains);

        if (hasOverlap) {
            throw new CustomException(
                    "Some personalities already exist for this student",
                    null,
                    HttpStatus.BAD_REQUEST.value()
            );
        }

        existingPersonalities.addAll(normalizedPersonalities);
        userRepository.save(student);
    }
}