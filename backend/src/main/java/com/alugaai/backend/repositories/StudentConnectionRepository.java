package com.alugaai.backend.repositories;

import com.alugaai.backend.models.ConnectionStatus;
import com.alugaai.backend.models.Student;
import com.alugaai.backend.models.StudentConnection;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;


@Repository
public interface StudentConnectionRepository extends JpaRepository<StudentConnection, Integer> {

    Optional<StudentConnection> findByRequesterIdAndAddresseeId(Integer requesterId, Integer addresseeId);

    List<StudentConnection> findByAddresseeId(Integer addresseeId);

    List<StudentConnection> findByRequesterId(Integer requesterId);

    List<StudentConnection> findByAddresseeIdAndStatus(Integer addresseeId, ConnectionStatus status);

    List<StudentConnection> findByRequesterIdAndStatus(Integer requesterId, ConnectionStatus status);

}
