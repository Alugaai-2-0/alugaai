package com.alugaai.backend.repositories;

import com.alugaai.backend.models.Image;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ImageRepository extends JpaRepository<Image, Integer> {
}
