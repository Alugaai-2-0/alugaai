package com.alugaai.backend.repositories;

import com.alugaai.backend.models.Property;
import com.alugaai.backend.models.Student;
import com.alugaai.backend.models.User;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PropertyRepository extends JpaRepository<Property, Integer>, JpaSpecificationExecutor<Property> {

    @Query("SELECT COUNT(p) FROM Property p")
    public long countProperties();

    @Query("SELECT COUNT(p.price) FROM Property p")
    public double countMonthlyRentalProperties();

}
