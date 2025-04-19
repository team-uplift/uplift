package org.upLift.repositories;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 * Base class used for Spring Data repository testing.
 */
@DataJpaTest
@Import(BaseRepositoryTest.RepositoryTestConfig.class)
public abstract class BaseRepositoryTest {

	@Configuration
	public static class RepositoryTestConfig {

		@Bean
		public ObjectMapper objectMapper() {
			return new ObjectMapper();
		}

	}

}
