package com.alugaai.backend.repositories;

import com.alugaai.backend.models.Building;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BuildingRepository extends JpaRepository<Building, Integer> {
}
