package com.alugaai.backend.repositories;

import com.alugaai.backend.models.User;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    Optional<User> findByUserName(@NotNull String name);
    @Query(value = "SELECT discriminator FROM users WHERE id = :userId", nativeQuery = true)
String findDiscriminatorByUserId(@Param("userId") @NotNull Integer userId);

    boolean existsByEmail(@NotNull String email);

    Optional<User> findByEmailOrCpf(@NotNull String email, @NotNull String cpf);
}
