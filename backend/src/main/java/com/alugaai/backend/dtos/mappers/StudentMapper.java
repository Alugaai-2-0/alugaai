package com.alugaai.backend.dtos.mappers;

import com.alugaai.backend.dtos.student.StudentFeedResponseDTO;
import com.alugaai.backend.dtos.user.OwnerForPropertyResponseDTO;
import com.alugaai.backend.dtos.user.UserRegisterRequestDTO;
import com.alugaai.backend.models.Owner;
import com.alugaai.backend.models.Student;
import com.alugaai.backend.models.User;

import java.util.HashSet;

public class StudentMapper {

    public static StudentFeedResponseDTO toStudentFeedResponseDTO(Student entity) {
        return new StudentFeedResponseDTO(
                entity.getId(),
                entity.getUsername(),
                entity.getBirthDate(),
                entity.getPersonalities()
        );
    }
}