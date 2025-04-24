package org.upLift;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.upLift.api.DonationsApiController;
import org.upLift.api.MessagesApiController;
import org.upLift.api.RecipientsApiController;
import org.upLift.api.UsersApiController;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.notNullValue;

@SpringBootTest
class UpLiftOrchestratorTest {

	@Autowired
	private DonationsApiController donationsApiController;

	@Autowired
	private MessagesApiController messagesApiController;

	@Autowired
	private RecipientsApiController recipientsApiController;

	@Autowired
	private UsersApiController usersApiController;

	@Test
	void contextLoads() {
		assertThat(donationsApiController, is(notNullValue()));
		assertThat(messagesApiController, is(notNullValue()));
		assertThat(recipientsApiController, is(notNullValue()));
		assertThat(usersApiController, is(notNullValue()));
	}

}
