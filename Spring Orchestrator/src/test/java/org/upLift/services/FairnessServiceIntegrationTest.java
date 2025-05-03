package org.upLift.services;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.FilterType;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.TestPropertySource;
import org.upLift.TestObjectMapperConfig;

import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.is;

// Since these tests don't check any date/time values, and the different @DataJpaTest configuration means
// it restarts the H2 database, just replace the database used
@DataJpaTest(includeFilters = @ComponentScan.Filter(classes = FairnessService.class, type = FilterType.ASSIGNABLE_TYPE))
@Import(TestObjectMapperConfig.class)
// @formatter:off
@TestPropertySource(properties = """
		uplift.number_of_matches = 3
		uplift.exclude_unverified_income = true
		""")
// @formatter:on
class FairnessServiceIntegrationTest {

	// No need to do integration test of the calculateOverallRecipientWeight() method,
	// it doesn't use any other resources and will be called by the
	// getRecipientsFromTags() method anyway

	@Autowired
	private FairnessService fairnessService;

	@Test
	void getRecipientsFromTags() {
		// Recipient 1 selected both "childcare" and "health
		// Recipient 2 matched "education" and "health", but didn't select either -
		// expired income verification
		// Recipient 5 selected "childcare", also matched "health" but not selected
		// Recipient 6 selected "health" - no income verification
		// Recipient 7 doesn't match any of the tags
		// Recipient 9 selected "health" but is deleted
		var tags = List.of("childcare", "education", "health");

		var result = fairnessService.getRecipientsFromTags(tags);
		assertThat(result, hasSize(3));
		// Although 4 recipients matched the tags, one has an expired income verification
		// and one has no verified income, so recipient 7 is added to fill in
		assertThat(result.getFirst().getId(), is(1));
		assertThat(result.get(1).getId(), is(5));
		assertThat(result.get(2).getId(), is(7));
	}

}
