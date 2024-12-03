package com.alugaai.backend.services;

import com.alugaai.backend.dtos.mappers.StudentMapper;
import com.alugaai.backend.dtos.student.StudentFeedResponseDTO;
import com.alugaai.backend.models.Role;
import com.alugaai.backend.models.Student;
import com.alugaai.backend.repositories.UserRepository;
import com.alugaai.backend.services.errors.CustomException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static com.alugaai.backend.repositories.specification.StudentSpecifications.*;

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

    public List<StudentFeedResponseDTO> getAllStudents(Integer minAge, Integer maxAge, Set<String> personalities) {
        // Validação das idades
        if (minAge != null && maxAge != null && minAge > maxAge) {
            throw new CustomException(
                    "Minimum age cannot be greater than maximum age",
                    null,
                    HttpStatus.BAD_REQUEST.value()
            );
        }

        // Converter idades para datas
        LocalDateTime maxBirthDate = minAge != null
                ? LocalDateTime.now().minusYears(minAge).withHour(0).withMinute(0).withSecond(0)
                : null;

        LocalDateTime minBirthDate = maxAge != null
                ? LocalDateTime.now().minusYears(maxAge).withHour(23).withMinute(59).withSecond(59)
                : null;

        // Normalizar personalidades
        Set<String> normalizedPersonalities = null;
        if (personalities != null && !personalities.isEmpty()) {
            normalizedPersonalities = personalities.stream()
                    .filter(p -> p != null && !p.trim().isEmpty())
                    .map(p -> p.trim().toLowerCase())
                    .collect(Collectors.toSet());

            if (normalizedPersonalities.isEmpty()) {
                normalizedPersonalities = null;
            }
        }

        // Construir specification
        Specification<Student> spec = Specification.where(hasRole(Role.RoleName.ROLE_STUDENT))
                .and(betweenBirthDate(minBirthDate, maxBirthDate))
                .and(hasPersonalities(normalizedPersonalities));

        return userRepository.findAll(spec)
                .stream()
                .map(StudentMapper::toStudentFeedResponseDTO)
                .collect(Collectors.toList());
    }
}