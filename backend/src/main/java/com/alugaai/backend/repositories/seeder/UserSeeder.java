package com.alugaai.backend.repositories.seeder;

import com.alugaai.backend.models.*;
import com.alugaai.backend.repositories.BuildingRepository;
import com.alugaai.backend.repositories.ImageRepository;
import com.alugaai.backend.repositories.RoleRepository;
import com.alugaai.backend.repositories.UserRepository;
import com.alugaai.backend.repositories.seeder.base.BaseSeeder;
import com.alugaai.backend.services.errors.CustomException;
import jakarta.annotation.Nullable;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Component
@Order(2)
public class UserSeeder extends BaseSeeder {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;
    private final ImageRepository imageRepository;
    private final BuildingRepository buildingRepository;

    public UserSeeder(
            UserRepository userRepository,
            RoleRepository roleRepository,
            PasswordEncoder passwordEncoder,
            ImageRepository imageRepository,
            BuildingRepository buildingRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
        this.imageRepository = imageRepository;
        this.buildingRepository = buildingRepository;
    }

    @Override
    protected void seed() {
        createUserIfNotExists(
                "Admin User",
                "admin@alugaai.com",
                "admin123",
                "12345678901",
                "11999999999",
                LocalDateTime.of(1990, 1, 1, 0, 0),
                'M',
                Role.RoleName.ROLE_ADMIN,
                null
        );

        createUserIfNotExists(
                "Owner Example",
                "owner@alugaai.com",
                "owner123",
                "98765432101",
                "11988888888",
                LocalDateTime.of(1985, 6, 15, 0, 0),
                'F',
                Role.RoleName.ROLE_OWNER,
                null
        );

        createUserIfNotExists(
                "Student Example",
                "student@alugaai.com",
                "student123",
                "45678912301",
                "11977777777",
                LocalDateTime.of(2000, 3, 20, 0, 0),
                'M',
                Role.RoleName.ROLE_STUDENT,
                createCollege()
        );
    }

    private void createUserIfNotExists(
            String userName,
            String email,
            String password,
            String cpf,
            String phoneNumber,
            LocalDateTime birthDate,
            Character gender,
            Role.RoleName roleName,
            @Nullable Building building
    ) {
        if (!userRepository.existsByEmail(email)) {
            User user = createUserInstance(roleName);

            user.setUserName(userName);
            user.setEmail(email);
            user.setPasswordHash(passwordEncoder.encode(password));
            user.setCpf(cpf);
            user.setPhoneNumber(phoneNumber);
            user.setBirthDate(birthDate);
            user.setGender(gender);
            user.setCreatedDate(LocalDateTime.now());

            // Campos booleanos e lista vazia para idsPersonsIConnect
            user.setEmailConfirmed(true);
            user.setPhoneNumberConfirmed(true);
            user.setTwoFactorEnabled(false);
            user.setIdsPersonsIConnect(new ArrayList<>());

            Role role = roleRepository.findByRoleName(roleName)
                    .orElseThrow(() -> new CustomException(
                            "Role " + roleName + " not found",
                            HttpStatus.NOT_FOUND.value(),
                            null));

            if (user.getRoles() == null) {
                user.setRoles(new HashSet<>());
            }
            user.getRoles().add(role);

            // Create and save image
            Image image = new Image();
            image.setImageData64("base64_encoded_default_image_data");
            image.setInsertedOn(LocalDateTime.now());
            image.setUser(user);
            user.setImage(image);

            // Configuração específica para Student com College obrigatório
            if (user instanceof Student student) {
                if (!(building instanceof College)) {
                    throw new CustomException(
                            "A valid College is required for a Student",
                            HttpStatus.BAD_REQUEST.value(),
                            null);
                }
                student.setPrincipalCollege((College) building);
            }

            // Save the user (cascade will handle the image)
            userRepository.save(user);
        }
    }

    private College createCollege() {
        var college = new College();
        college.setAddress("New college");
        college.setNeighborhood("Brooklyn");
        college.setDistrict("NY");
        college.setLatitude("0");
        college.setLongitude("0");

        // Create and set image for college
        Image collegeImage = new Image();
        collegeImage.setImageData64("base64_encoded_default_image_data");
        collegeImage.setInsertedOn(LocalDateTime.now());
        college.setImages(new ArrayList<>(List.of(collegeImage)));
        collegeImage.setBuilding(college);

        return buildingRepository.save(college);
    }

    private User createUserInstance(Role.RoleName roleName) {
        return switch (roleName) {
            case ROLE_STUDENT -> new Student();
            case ROLE_OWNER -> new Owner();
            case ROLE_ADMIN -> new User();
            default -> throw new CustomException(
                    "Invalid role for user creation: " + roleName,
                    HttpStatus.BAD_REQUEST.value(),
                    null);
        };
    }
}