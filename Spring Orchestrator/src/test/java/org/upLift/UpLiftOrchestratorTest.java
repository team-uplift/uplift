package org.upLift;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.upLift.api.*;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.notNullValue;

/**
 * This serves as a "smoke" test for the configuration, to make sure that the system
 * starts up correctly.
 */
@SpringBootTest
class UpLiftOrchestratorTest {

	@Autowired
	private DonationsApiController donationsApiController;

	@Autowired
	private HomeController homeController;

	@Autowired
	private MessagesApiController messagesApiController;

	@Autowired
	private RecipientsApiController recipientsApiController;

	@Autowired
	private UsersApiController usersApiController;

	@Test
	void contextLoads() {
		assertThat(donationsApiController, is(notNullValue()));
		assertThat(homeController, is(notNullValue()));
		assertThat(messagesApiController, is(notNullValue()));
		assertThat(recipientsApiController, is(notNullValue()));
		assertThat(usersApiController, is(notNullValue()));
	}

}
