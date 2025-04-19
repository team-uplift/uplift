package org.upLift;

import com.fasterxml.jackson.databind.Module;
import org.openapitools.jackson.nullable.JsonNullableModule;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.ExitCodeGenerator;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

// Don't specify @ComponentScan here - Spring will scan everything in the same package as
// this class anyway, and it interferes with test configuration because it prevents Spring
// Boot from selectively loading only subsets of the components for different types of test
// configuration.
@SpringBootApplication
@EnableJpaAuditing
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

	class ExitException extends RuntimeException implements ExitCodeGenerator {

		private static final long serialVersionUID = 1L;

		@Override
		public int getExitCode() {
			return 10;
		}

	}

}
