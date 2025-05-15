package com.alugaai.backend.repositories.specification;

import com.alugaai.backend.models.Role;
import com.alugaai.backend.models.Student;
import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class StudentSpecifications {

    public static Specification<Student> hasRole(Role.RoleName roleName) {
        return (root, query, cb) -> {
            Join<Student, Role> roleJoin = root.join("roles");
            return cb.equal(roleJoin.get("roleName"), roleName);
        };
    }

    public static Specification<Student> betweenBirthDate(LocalDateTime minBirthDate, LocalDateTime maxBirthDate) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (minBirthDate != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("birthDate"), minBirthDate));
            }

            if (maxBirthDate != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("birthDate"), maxBirthDate));
            }

            return predicates.isEmpty() ? null : cb.and(predicates.toArray(new Predicate[0]));
        };
    }

    public static Specification<Student> hasPersonalities(Set<String> personalities) {
        return (root, query, cb) -> {
            if (personalities == null || personalities.isEmpty()) {
                return null;
            }

            Join<Student, String> personalitiesJoin = root.join("personalities");
            return personalitiesJoin.in(personalities);
        };
    }

    public static Specification<Student> idNotIn(Set<Integer> excludedIds) {
        return (root, query, cb) -> root.get("id").in(excludedIds).not();
    }
}
