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
        // Create the three colleges
        College uniso = createCollege(
                "Rodovia Raposo Tavares, KM 92.5",
                "S/N",
                "Jardim Iguatemi",
                "Sorocaba",
                "-23.4799",
                "-47.4293",
                "UNISO - Universidade de Sorocaba"
        );

        College unip = createCollege(
                "Avenida Independência",
                "210",
                "Éden",
                "Sorocaba",
                "-23.4989",
                "-47.4387",
                "UNIP - Universidade Paulista"
        );

        College facens = createCollege(
                "Rodovia Senador José Ermírio de Moraes",
                "1425",
                "Jardim Constantino Matucci",
                "Sorocaba",
                "-23.4706",
                "-47.4291",
                "FACENS - Faculdade de Engenharia de Sorocaba"
        );

        // Admin user
        createUserIfNotExists(
                "Admin User",
                "admin@alugaai.com",
                "admin123",
                "12345678901",
                "11999999999",
                LocalDateTime.of(1990, 1, 1, 0, 0),
                'M',
                Role.RoleName.ROLE_ADMIN,
                null,
                null
        );

        // Create owners and their properties
        // Owner 1 - Próximo à UNISO
        Owner owner1 = (Owner) createUserIfNotExists(
                "Roberto Silva",
                "robertosilva@gmail.com",
                "owner123",
                "98765432101",
                "15998888888",
                LocalDateTime.of(1975, 6, 15, 0, 0),
                'M',
                Role.RoleName.ROLE_OWNER,
                null,
                null
        );

        createProperty(
                owner1,
                "Rua José Antonio Fernandes",
                "123",
                "Jardim Iguatemi",
                "Sorocaba",
                "-23.4805",
                "-47.4280"
        );

        createProperty(
                owner1,
                "Rua Aparecida",
                "456",
                "Jardim Iguatemi",
                "Sorocaba",
                "-23.4810",
                "-47.4285"
        );

        // Owner 2 - Próximo à UNIP
        Owner owner2 = (Owner) createUserIfNotExists(
                "Maria Conceição",
                "mariaconceicao@gmail.com",
                "owner123",
                "45678912301",
                "15997777777",
                LocalDateTime.of(1980, 3, 20, 0, 0),
                'F',
                Role.RoleName.ROLE_OWNER,
                null,
                null
        );

        createProperty(
                owner2,
                "Avenida Independência",
                "789",
                "Éden",
                "Sorocaba",
                "-23.4995",
                "-47.4390"
        );

        // Owner 3 - Próximo à FACENS
        Owner owner3 = (Owner) createUserIfNotExists(
                "José Santos",
                "josesantos@gmail.com",
                "owner123",
                "78912345601",
                "15996666666",
                LocalDateTime.of(1968, 12, 10, 0, 0),
                'M',
                Role.RoleName.ROLE_OWNER,
                null,
                null
        );

        createProperty(
                owner3,
                "Rua Constantino Matucci",
                "321",
                "Jardim Constantino Matucci",
                "Sorocaba",
                "-23.4710",
                "-47.4295"
        );

        createProperty(
                owner3,
                "Rua dos Estudantes",
                "100",
                "Jardim Constantino Matucci",
                "Sorocaba",
                "-23.4715",
                "-47.4298"
        );

        // UNISO Students
        Set<String> joaoPersonalities = new HashSet<>(List.of(
                "gosta de academia",
                "pratica futebol",
                "organizado",
                "estuda à noite",
                "gosta de música",
                "fã de rock",
                "não fuma"
        ));

        Set<String> mariaPersonalities = new HashSet<>(List.of(
                "vegetariana",
                "pratica yoga",
                "gosta de ler",
                "estudiosa",
                "toca violão",
                "prefere ambiente calmo",
                "não bebe"
        ));

        createUserIfNotExists(
                "João Antonio",
                "joaoantonio@gmail.com",
                "student123",
                "998999999",
                "11977777776",
                LocalDateTime.of(1999, 3, 21, 0, 0),
                'M',
                Role.RoleName.ROLE_STUDENT,
                uniso,
                joaoPersonalities
        );

        createUserIfNotExists(
                "Maria Freita",
                "mariafreita@gmail.com",
                "student123",
                "998999998",
                "11977777676",
                LocalDateTime.of(1996, 3, 21, 0, 0),
                'F',
                Role.RoleName.ROLE_STUDENT,
                uniso,
                mariaPersonalities
        );

        // UNIP Students
        Set<String> florentinaPersonalities = new HashSet<>(List.of(
                "ama cozinhar",
                "gosta de plantas",
                "organizada",
                "gosta de séries",
                "prefere estudar em casa",
                "toca piano",
                "vegana"
        ));

        Set<String> gustavoPersonalities = new HashSet<>(List.of(
                "gamer",
                "programador",
                "noturno",
                "toca guitarra",
                "gosta de animes",
                "pratica e-sports",
                "fã de tecnologia"
        ));

        createUserIfNotExists(
                "Florentina Souza",
                "florentinasouza@gmail.com",
                "student123",
                "998999918",
                "11977477676",
                LocalDateTime.of(1992, 3, 21, 0, 0),
                'F',
                Role.RoleName.ROLE_STUDENT,
                unip,
                florentinaPersonalities
        );

        createUserIfNotExists(
                "Gustavo Ribeiro",
                "gustavoribeiro@gmail.com",
                "student123",
                "978999918",
                "11973477676",
                LocalDateTime.of(2003, 3, 21, 0, 0),
                'M',
                Role.RoleName.ROLE_STUDENT,
                unip,
                gustavoPersonalities
        );

        // FACENS Students
        Set<String> carlosPersonalities = new HashSet<>(List.of(
                "atleta",
                "madrugador",
                "gosta de esportes",
                "pratica natação",
                "organizado",
                "fã de podcasts",
                "gosta de documentários"
        ));

        Set<String> humbertoPersonalities = new HashSet<>(List.of(
                "músico",
                "artista",
                "criativo",
                "gosta de fotografia",
                "fã de jazz",
                "pratica meditação",
                "vegetariano"
        ));

        Set<String> anaPersonalities = new HashSet<>(List.of(
                "dançarina",
                "gosta de viajar",
                "extrovertida",
                "pratica volleyball",
                "ama pets",
                "gosta de cozinhar",
                "fã de música pop"
        ));

        createUserIfNotExists(
                "Carlos Vieira",
                "carlosvieira@gmail.com",
                "student123",
                "978999915",
                "11972477676",
                LocalDateTime.of(2002, 3, 21, 0, 0),
                'M',
                Role.RoleName.ROLE_STUDENT,
                facens,
                carlosPersonalities
        );

        createUserIfNotExists(
                "Humberto Oliveira",
                "humbertooliveira@gmail.com",
                "student123",
                "978999925",
                "11972277676",
                LocalDateTime.of(1988, 3, 21, 0, 0),
                'M',
                Role.RoleName.ROLE_STUDENT,
                facens,
                humbertoPersonalities
        );

        createUserIfNotExists(
                "Ana Ramalho",
                "anaramalho@gmail.com",
                "student123",
                "978999923",
                "11971277676",
                LocalDateTime.of(2000, 3, 21, 0, 0),
                'F',
                Role.RoleName.ROLE_STUDENT,
                facens,
                anaPersonalities
        );
    }

    private void createProperty(
            Owner owner,
            String address,
            String homeNumber,
            String neighborhood,
            String district,
            String latitude,
            String longitude
    ) {
        Property property = new Property();
        property.setAddress(address);
        property.setHomeNumber(homeNumber);
        property.setNeighborhood(neighborhood);
        property.setDistrict(district);
        property.setLatitude(latitude);
        property.setLongitude(longitude);
        property.setOwner(owner);

        buildingRepository.save(property);
    }

    private College createCollege(
            String address,
            String homeNumber,
            String neighborhood,
            String district,
            String latitude,
            String longitude,
            String collegeName
    ) {
        var college = new College();
        college.setAddress(address);
        college.setHomeNumber(homeNumber);
        college.setNeighborhood(neighborhood);
        college.setDistrict(district);
        college.setLatitude(latitude);
        college.setLongitude(longitude);
        college.setCollegeName(collegeName);

        return buildingRepository.save(college);
    }

    private User createUserIfNotExists(
            String userName,
            String email,
            String password,
            String cpf,
            String phoneNumber,
            LocalDateTime birthDate,
            Character gender,
            Role.RoleName roleName,
            @Nullable Building building,
            @Nullable Set<String> personalities
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

            user.setEmailConfirmed(true);
            user.setPhoneNumberConfirmed(true);
            user.setTwoFactorEnabled(false);

            Role role = roleRepository.findByRoleName(roleName)
                    .orElseThrow(() -> new CustomException(
                            "Role " + roleName + " not found",
                            HttpStatus.NOT_FOUND.value(),
                            null));

            if (user.getRoles() == null) {
                user.setRoles(new HashSet<>());
            }
            user.getRoles().add(role);

            if (user instanceof Student student) {
                if (!(building instanceof College)) {
                    throw new CustomException(
                            "A valid College is required for a Student",
                            HttpStatus.BAD_REQUEST.value(),
                            null);
                }
                student.setPrincipalCollege((College) building);
                student.getPersonalities().addAll(personalities);
            }

            return userRepository.save(user);
        }
        return null;
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