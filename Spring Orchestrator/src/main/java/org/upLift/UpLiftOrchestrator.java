package org.upLift;

import org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport;
import org.upLift.configuration.LocalDateConverter;
import org.upLift.configuration.LocalDateTimeConverter;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.ExitCodeGenerator;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.openapitools.jackson.nullable.JsonNullableModule;
import org.springframework.context.annotation.Bean;
import com.fasterxml.jackson.databind.Module;


import org.springframework.context.annotation.Configuration;
import org.springframework.format.FormatterRegistry;
@SpringBootApplication
@ComponentScan(basePackages = { "org.upLift", "org.upLift.api" , "org.upLift.configuration"})
public class UpLiftOrchestrator implements CommandLineRunner {

    @Override
    public void run(String... arg0) throws Exception {
        if (arg0.length > 0 && arg0[0].equals("exitcode")) {
            throw new ExitException();
        }
    }

    public static void main(String[] args) throws Exception {
        new SpringApplication(UpLiftOrchestrator.class).run(args);
    }
    @Bean
    public Module jsonNullableModule() {
        return new JsonNullableModule();
    }

    @Configuration
    static class CustomDateConfig extends WebMvcConfigurationSupport {
        @Override
        public void addFormatters(FormatterRegistry registry) {
            registry.addConverter(new LocalDateConverter("yyyy-MM-dd"));
            registry.addConverter(new LocalDateTimeConverter("yyyy-MM-dd'T'HH:mm:ss.SSS"));
        }
    }

    class ExitException extends RuntimeException implements ExitCodeGenerator {
        private static final long serialVersionUID = 1L;

        @Override
        public int getExitCode() {
            return 10;
        }

    }
}
