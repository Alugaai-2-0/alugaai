package com.alugaai.backend.repositories;

import com.alugaai.backend.models.Owner;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

public interface OwnerRepository extends JpaRepository<Owner, Integer>, JpaSpecificationExecutor<Owner> {

    @Query("SELECT COUNT(o) FROM Owner o")
    long countOwners();

}
