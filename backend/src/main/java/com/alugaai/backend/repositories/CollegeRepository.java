package com.alugaai.backend.repositories;

import com.alugaai.backend.models.Building;
import com.alugaai.backend.models.College;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CollegeRepository extends JpaRepository<College, Integer> {
}
