package org.upLift;

import com.fasterxml.jackson.databind.Module;
import org.openapitools.jackson.nullable.JsonNullableModule;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.ExitCodeGenerator;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = { "org.upLift", "org.upLift.api", "org.upLift.configuration", "org.upLift.services" })
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

	// Don't need this, Spring/Jackson have standard support for JDK 8 Date/Time types
	// and it messes up the automated Jackson config
	// @foramtter:off
	// @Configuration
	// static class CustomDateConfig extends WebMvcConfigurationSupport {
	//
	// @Override
	// public void addFormatters(FormatterRegistry registry) {
	// registry.addConverter(new LocalDateConverter("yyyy-MM-dd"));
	// registry.addConverter(new LocalDateTimeConverter("yyyy-MM-dd'T'HH:mm:ss.SSS"));
	// }
	//
	// }
	// @formatter:on

	class ExitException extends RuntimeException implements ExitCodeGenerator {

		private static final long serialVersionUID = 1L;

		@Override
		public int getExitCode() {
			return 10;
		}

	}

}
