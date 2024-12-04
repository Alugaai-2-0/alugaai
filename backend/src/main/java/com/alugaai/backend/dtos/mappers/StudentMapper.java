package com.alugaai.backend.dtos.mappers;

import com.alugaai.backend.dtos.student.StudentFeedResponseDTO;
import com.alugaai.backend.models.Student;


public class StudentMapper {

    public static StudentFeedResponseDTO toStudentFeedResponseDTO(Student entity) {
        return new StudentFeedResponseDTO(
                entity.getId(),
                entity.getUsername(),
                entity.getBirthDate(),
                entity.getDescription(),
                entity.getImage() != null ? ImageMapper.toImageResponseDTO(entity.getImage()) : null,
                entity.getPrincipalCollege().getCollegeName(),
                entity.getPersonalities()
        );
    }
}