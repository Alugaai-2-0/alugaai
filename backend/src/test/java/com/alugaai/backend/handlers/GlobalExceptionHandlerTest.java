package com.alugaai.backend.handlers;

import com.alugaai.backend.asbtractClasses.ClassHelper;
import com.alugaai.backend.services.UserService;
import com.alugaai.backend.services.errors.CustomException;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

@SpringBootTest
@ActiveProfiles("test")
public class GlobalExceptionHandlerTest extends ClassHelper {

    @Autowired
    private UserService userService;

    @Test
    public void testNotFoundException() {

        CustomException exception = assertThrows(CustomException.class, () -> {
            userService.registerNewUser(generateStudent("student@gmail.com", "student", "passwordHashSenha"),
                    "testRole");
        });

        assertEquals("Invalid role: testRole", exception.getMessage());
        assertEquals(400, exception.getStatusCode());

    }

}
