package com.alugaai.backend.dtos.mappers;

import com.alugaai.backend.dtos.ImageDTO;
import com.alugaai.backend.dtos.UserRegisterDTO;
import com.alugaai.backend.models.Image;
import com.alugaai.backend.models.Owner;
import com.alugaai.backend.models.Student;
import com.alugaai.backend.models.User;

public class UserMapper {

    public static UserRegisterDTO toDTO(User user) {
        return new UserRegisterDTO(
                user.getBirthDate(),
                user.getGender(),
                user.getUsername(),
                user.getEmail(),
                user.getPassword(),
                user.getCpf(),
                user.getPhoneNumber(),
                new ImageDTO(user.getImage() != null ? user.getImage().getImageData64() : null)
        );
    }

    private static <T extends User> T mapCommonFields(UserRegisterDTO dto, T user) {
        user.setBirthDate(dto.birthDate());
        user.setGender(dto.gender());
        user.setUserName(dto.userName());
        user.setEmail(dto.email());
        user.setPasswordHash(dto.password());
        user.setCpf(dto.cpf());
        user.setPhoneNumber(dto.phoneNumber());
        if (dto.imageDTO() != null) {
            user.setImage(new Image(dto.imageDTO().imageData64()));
        }
        return user;
    }

    public static Owner toOwnerEntity(UserRegisterDTO dto) {
        return mapCommonFields(dto, new Owner());
    }

    public static Student toStudentEntity(UserRegisterDTO dto) {
        return mapCommonFields(dto, new Student());
    }
}