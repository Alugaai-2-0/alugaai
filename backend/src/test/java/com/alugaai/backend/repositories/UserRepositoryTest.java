package com.alugaai.backend.repositories;


import com.alugaai.backend.asbtractClasses.ClassHelper;
import com.alugaai.backend.models.Owner;
import com.alugaai.backend.models.Student;
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
public class UserRepositoryTest extends ClassHelper {

   @Autowired
   private UserRepository userRepository;

    @Test
    public void testInsertOwner() {
        User user = generateOwner("owner@gmail.com", "owner", "passwordHashSenha");
        User savedUser = userRepository.save(user);

        assertNotNull(savedUser.getId());

        Optional<User> fetchedUser = userRepository.findById(savedUser.getId());
        assertTrue(fetchedUser.isPresent());
        assertEquals("owner", fetchedUser.get().getUsername());
        assertEquals("owner@gmail.com", fetchedUser.get().getEmail());
    }

    @Test
    public void testInsertStudent() {
        User user = generateStudent("student@gmail.com", "student", "passwordHashSenha");
        User savedUser = userRepository.save(user);

        assertNotNull(savedUser.getId());

        Optional<User> fetchedUser = userRepository.findById(savedUser.getId());

        String discriminator = userRepository.findDiscriminatorByUserId(fetchedUser.get().getId());


        assertTrue(fetchedUser.isPresent());
        assertEquals("student", fetchedUser.get().getUsername());
        assertEquals("student@gmail.com", fetchedUser.get().getEmail());
        assertEquals("STUDENT", discriminator);
    }



}
