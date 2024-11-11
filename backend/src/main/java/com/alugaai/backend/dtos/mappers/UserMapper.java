package com.alugaai.backend.dtos.mappers;

import com.alugaai.backend.dtos.image.ImageRequestDTO;
import com.alugaai.backend.dtos.user.UserRegisterRequestDTO;
import com.alugaai.backend.models.Owner;
import com.alugaai.backend.models.Student;
import com.alugaai.backend.models.User;
import java.util.HashSet;

public class UserMapper {

    private static <T extends User> T mapCommonFields(UserRegisterRequestDTO dto, T user) {
        user.setBirthDate(dto.birthDate());
        user.setGender(dto.gender());
        user.setUserName(dto.userName());
        user.setEmail(dto.email());
        user.setPasswordHash(dto.password());
        user.setCpf(dto.cpf());
        user.setPhoneNumber(dto.phoneNumber());

        user.setRoles(new HashSet<>());

        return user;
    }

    public static Owner toOwnerEntity(UserRegisterRequestDTO dto) {
        Owner owner = new Owner();
        return mapCommonFields(dto, owner);
    }

    public static Student toStudentEntity(UserRegisterRequestDTO dto) {
        Student student = new Student();
        return mapCommonFields(dto, student);
    }

    public static UserRegisterRequestDTO toDTO(User user) {
        return new UserRegisterRequestDTO(
                user.getBirthDate(),
                user.getGender(),
                user.getUsername(),
                user.getEmail(),
                user.getPassword(),
                user.getCpf(),
                user.getPhoneNumber()
        );
    }
}