package org.upLift.repositories;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;

/**
 * Base class used for Spring Data repository testing.
 */
@DataJpaTest
@ActiveProfiles("ci")
// Do NOT replace the DataSource with a default H2 database, instead use the one based on
// the CI config to ensure that time zone is set to UTC
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
@Import(BaseRepositoryTest.RepositoryTestConfig.class)
abstract class BaseRepositoryTest {

	@Configuration
	public static class RepositoryTestConfig {

		@Bean
		public ObjectMapper objectMapper() {
			return new ObjectMapper();
		}

	}

}
