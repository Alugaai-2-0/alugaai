package com.alugaai.backend.configuration;

import jakarta.ws.rs.ApplicationPath;
import org.glassfish.jersey.server.ResourceConfig;
import org.springframework.context.annotation.Configuration;

import static org.springframework.core.annotation.AnnotationFilter.packages;

@Configuration
@ApplicationPath("/")
public class JerseyConfig extends ResourceConfig {

    public JerseyConfig() {
        packages("com.spring.events.resource");
    }
}