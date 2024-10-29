package com.alugaai.backend.repositories.seeder.base;

import org.springframework.boot.CommandLineRunner;

public abstract class BaseSeeder implements CommandLineRunner {

    protected abstract void seed();

    @Override
    public void run(String... args) {
        seed();
    }

}
