package org.upLift;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration class that provides a default Jackson ObjectMapper, intended for use with
 * repository layer integration tests (to enable mapping to/from the Recipient form
 * questions) and some service integration tests. Should NOT be used for any REST
 * controller tests or other more complex JSON mapping!
 */
@Configuration
public class TestObjectMapperConfig {

	@Bean
	public ObjectMapper objectMapper() {
		return new ObjectMapper();
	}

}
