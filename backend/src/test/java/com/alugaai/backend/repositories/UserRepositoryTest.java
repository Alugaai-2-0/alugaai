package com.alugaai.backend.repositories;


import com.alugaai.backend.models.User;
import com.sun.istack.NotNull;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@DataJpaTest
@ActiveProfiles("test")
public class UserRepositoryTest {

   private UserRepository userRepository;

   @Autowired
    public UserRepositoryTest(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Test
    public void testInsertUser() {
        User user = generateUser("joao@gmail.com", "joao", "passwordHashSenha");
        User savedUser = userRepository.save(user);

        assertNotNull(savedUser.getId());

        Optional<User> fetchedUser = userRepository.findById(savedUser.getId());
        assertTrue(fetchedUser.isPresent());
        assertEquals("joao", fetchedUser.get().getUsername());
        assertEquals("joao@gmail.com", fetchedUser.get().getEmail());
    }

    public User generateUser(@NotNull String email, @NotNull String userName, @NotNull String passwordHash) {
       return new User(
                LocalDateTime.now(),
                LocalDateTime.now(),
                'M',
                userName,
                email,
               passwordHash
        );
    }
}
