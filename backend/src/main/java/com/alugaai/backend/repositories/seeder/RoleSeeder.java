package com.alugaai.backend.repositories.seeder;

import com.alugaai.backend.models.Role;
import com.alugaai.backend.repositories.RoleRepository;
import com.alugaai.backend.repositories.seeder.base.BaseSeeder;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.Arrays;

@Component
@Order(1)
public class RoleSeeder extends BaseSeeder {
    private RoleRepository roleRepository;

    public RoleSeeder(RoleRepository roleRepository) {
        this.roleRepository = roleRepository;
    }

    @Override
    protected void seed() {
        Arrays.stream(Role.RoleName.values()).forEach(roleName -> {
            if (!roleRepository.existsByRoleName(roleName)) {
                Role role = new Role();
                role.setRoleName(roleName);
                roleRepository.save(role);
            }
        });
    }
}
