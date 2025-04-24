package org.upLift.repositories;

import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;
import org.upLift.TestObjectMapperConfig;

/**
 * Base class used for Spring Data repository testing.
 */
// Use a slightly different JDBC URL with a different database to avoid conflict with
// other @DataJpaTest slices
@DataJpaTest(properties = "spring.datasource.url=jdbc:h2:mem:repo_tests;DB_CLOSE_DELAY=-1;TIME ZONE=UTC")
@ActiveProfiles("ci")
// Do NOT replace the DataSource with a default H2 database, instead use the one based on
// the CI config to ensure that time zone is set to UTC
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
@Import(TestObjectMapperConfig.class)
abstract class BaseRepositoryTest {

}
