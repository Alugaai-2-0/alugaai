package com.alugaai.backend.dtos.mappers;

import com.alugaai.backend.dtos.LoginResponseDTO;
import com.alugaai.backend.models.User;
import java.util.stream.Collectors;

public class LoginMapper {

    public static LoginResponseDTO toDTO(User user, String token) {
        return new LoginResponseDTO(
                token,
                user.getRoles().stream().map(role -> role.getRoleName().toString()).collect(Collectors.toList()),
                user.getEmail(),
                user.getUsername(),
                user.getPhoneNumber(),
                user.getBirthDate(),
                user.getGender(),
                user.getCpf(),
                user.getPhoneNumberConfirmed(),
                user.getTwoFactorEnabled(),
                user.getCreatedDate()
        );
    }
}
