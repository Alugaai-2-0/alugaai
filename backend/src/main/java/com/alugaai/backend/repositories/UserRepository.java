package com.alugaai.backend.repositories;

import com.alugaai.backend.models.Student;
import com.alugaai.backend.models.User;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Repository
public interface UserRepository extends JpaRepository<User, Integer>, JpaSpecificationExecutor<Student> {
    Optional<User> findByUserName(@NotNull String name);
    @Query(value = "SELECT discriminator FROM users WHERE id = :userId", nativeQuery = true)
    String findDiscriminatorByUserId(@Param("userId") @NotNull Integer userId);

    boolean existsByEmail(@NotNull String email);

    Optional<User> findByEmailOrCpfOrPhoneNumber(@NotNull String email, @NotNull String cpf, @NotNull String phoneNumber);

    @Query("SELECT COUNT(s) FROM Student s")
    long countStudents();

    @Query("SELECT COUNT(o) FROM Owner o")
    long countOwners();
}
