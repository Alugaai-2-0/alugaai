package com.alugaai.backend.asbtractClasses;

import com.alugaai.backend.models.Owner;
import com.alugaai.backend.models.Student;
import com.alugaai.backend.models.User;
import com.sun.istack.NotNull;

import java.time.LocalDateTime;

public abstract class ClassHelper {

    public User generateOwner(@NotNull String email, @NotNull String userName, @NotNull String passwordHash) {
        return new Owner(
                LocalDateTime.now(),
                LocalDateTime.now(),
                'M',
                userName,
                email,
                passwordHash
        );
    }

    public User generateStudent(@NotNull String email, @NotNull String userName, @NotNull String passwordHash) {
        return new Student(
                LocalDateTime.now(),
                LocalDateTime.now(),
                'M',
                userName,
                email,
                passwordHash
        );
    }

}
