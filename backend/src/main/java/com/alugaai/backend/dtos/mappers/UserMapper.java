package com.alugaai.backend.dtos.mappers;

import com.alugaai.backend.dtos.image.ImageRequestDTO;
import com.alugaai.backend.dtos.user.UserRegisterRequestDTO;
import com.alugaai.backend.models.Image;
import com.alugaai.backend.models.Owner;
import com.alugaai.backend.models.Student;
import com.alugaai.backend.models.User;

public class UserMapper {

    public static UserRegisterRequestDTO toDTO(User user) {
        return new UserRegisterRequestDTO(
                user.getBirthDate(),
                user.getGender(),
                user.getUsername(),
                user.getEmail(),
                user.getPassword(),
                user.getCpf(),
                user.getPhoneNumber(),
                new ImageRequestDTO(user.getImage() != null ? user.getImage().getImageData64() : null)
        );
    }

    private static <T extends User> T mapCommonFields(UserRegisterRequestDTO dto, T user) {
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

    public static Owner toOwnerEntity(UserRegisterRequestDTO dto) {
        return mapCommonFields(dto, new Owner());
    }

    public static Student toStudentEntity(UserRegisterRequestDTO dto) {
        return mapCommonFields(dto, new Student());
    }
}