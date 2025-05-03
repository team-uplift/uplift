
package org.upLift.api;

import org.mockito.Mockito;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.Primary;
import org.springframework.test.web.servlet.ResultActions;
import org.upLift.model.TremendousOrderResponse;
import org.upLift.services.BedrockService;
import org.upLift.services.TextractService;
import org.upLift.services.TremendousService;

import java.time.LocalDate;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.util.Arrays;
import java.util.HashMap;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

@SuppressWarnings("UnusedReturnValue")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@AutoConfigureMockMvc
@Import(BaseControllerIntegrationTest.TestConfig.class)
abstract class BaseControllerIntegrationTest {

	private static final Logger LOG = LoggerFactory.getLogger(BaseControllerIntegrationTest.class);

	@TestConfiguration
	static class TestConfig {

		// Create mocks of services that directly use AWS services or the Tremendous API
		// to avoid incurring charges or burning through our sandbox

		@Bean
		@Primary
		public TremendousService tremendousService() {
			// Create a mock of the TremendousService so we're not using up our actual
			// Tremendous sandbox calls
			TremendousService mockService = Mockito.mock(TremendousService.class);
			// Add an orderId so we can check the log to make sure this Mock is used
			Mockito.when(mockService.submitDonationOrder(Mockito.any(), Mockito.any(), Mockito.anyInt()))
				.thenReturn(new TremendousOrderResponse("TESTING"));
			return mockService;
		}

		@Bean
		@Primary
		public BedrockService bedrockService() {
			// Create a mock of the BedrockService so we're not trying to hit the AWS
			// Bedrock service with every test run
			// Also, this way we can control exactly what tags/weights are returned for
			// repeatable testing
			BedrockService mockService = Mockito.mock(BedrockService.class);

			var recipientTagMap = new HashMap<String, Double>();
			recipientTagMap.put("clothing", 0.85);
			recipientTagMap.put("food", 0.47);
			recipientTagMap.put("legal-aid", 0.73);
			recipientTagMap.put("transportation", 0.88);
			// Return new tag that's not already part of the test data
			recipientTagMap.put("wheelchair access", 0.93);
			Mockito.when(mockService.getTagsFromPrompt(Mockito.anyString())).thenAnswer(i -> {
				LOG.info("Invoking mock getTagsFromPrompt");
				return recipientTagMap;
			});

			Mockito.when(mockService.matchTagsFromPrompt(Mockito.anyString())).thenAnswer(i -> {
				LOG.info("Invoking mock matchTagsFromPrompt");
				// Recipient 1 selected both "childcare" and "health
				// Recipient 2 matched "education" and "health", but didn't select either
				// -
				// expired income verification
				// Recipient 5 selected "childcare", also matched "health" but not
				// selected
				// Recipient 6 selected "health" - no income verification
				// Recipient 7 doesn't match any of the tags
				return Arrays.asList("childcare", "education", "health");
			});

			return mockService;
		}

		@Bean
		@Primary
		public TextractService textractService() {
			// Create a mock of the TextractService so we're not trying to hit the AWS
			// Textract service with every test run
			TextractService mockService = Mockito.mock(TextractService.class);
			// Mock service to return true for odd ids and false for even ids
			Mockito.when(mockService.validateRecipientIncome(Mockito.any(), Mockito.any(Integer.class)))
				.thenAnswer(invocation -> {
					LOG.info("Invoking mock validateRecipientIncome method");
					int id = (int) invocation.getArguments()[1];
					return id % 2 == 1;
				});
			return mockService;
		}

	}

	/**
	 * Returns "today" in the UTC timezone, can be used to check date portion of "created
	 * at" timestamps.
	 * @return "today" in the UTC timezone
	 */
	LocalDate getTodayUtc() {
		return ZonedDateTime.now(ZoneOffset.UTC).toLocalDate();
	}

	ResultActions checkDonor1PublicData(ResultActions result, String prefix) throws Exception {
		result.andExpect(jsonPath(prefix).exists())
			.andExpect(jsonPath(prefix + ".id", is(3)))
			.andExpect(jsonPath(prefix + ".nickname", is("KindDonor1")))
			.andExpect(jsonPath(prefix + ".createdAt", is("2023-10-10T12:30:50.789Z")));
		return result;
	}

	ResultActions checkRecipient1PublicData(ResultActions result, String prefix) throws Exception {
		result.andExpect(jsonPath(prefix).exists())
			.andExpect(jsonPath(prefix + ".id", is(1)))
			.andExpect(jsonPath(prefix + ".nickname", is("Johnny")))
			.andExpect(jsonPath(prefix + ".lastAboutMe", is("About John")))
			.andExpect(jsonPath(prefix + ".lastReasonForHelp", is("Reason 1")))
			.andExpect(jsonPath(prefix + ".imageUrl", is("http://example.com/image1.jpg")))
			.andExpect(jsonPath(prefix + ".lastDonationTimestamp", is("2023-10-23T18:10:50.987Z")))
			.andExpect(jsonPath(prefix + ".createdAt", is("2023-10-01T10:20:30.123Z")))
			.andExpect(jsonPath(prefix + ".tags", hasSize(7)))
			.andExpect(jsonPath(prefix + ".tags[*].selected", contains(true, true, true, true, true, true, true)))
			.andExpect(jsonPath(prefix + ".tags[0].tagName", is("childcare")))
			.andExpect(jsonPath(prefix + ".tags[1].tagName", is("clothing")))
			.andExpect(jsonPath(prefix + ".tags[2].tagName", is("food")))
			.andExpect(jsonPath(prefix + ".tags[3].tagName", is("health")))
			.andExpect(jsonPath(prefix + ".tags[4].tagName", is("housing")))
			.andExpect(jsonPath(prefix + ".tags[5].tagName", is("mental-health")))
			.andExpect(jsonPath(prefix + ".tags[6].tagName", is("utilities")));
		return result;
	}

	ResultActions checkRecipient2PublicData(ResultActions result, String prefix) throws Exception {
		// Check that recipient data is included
		result.andExpect(jsonPath(prefix).exists())
			.andExpect(jsonPath(prefix + ".id", is(2)))
			.andExpect(jsonPath(prefix + ".nickname", is("Janie")))
			.andExpect(jsonPath(prefix + ".lastAboutMe", is("About Jane")))
			.andExpect(jsonPath(prefix + ".lastReasonForHelp", is("Reason 2")))
			.andExpect(jsonPath(prefix + ".imageUrl", is("http://example.com/image2.jpg")))
			.andExpect(jsonPath(prefix + ".lastDonationTimestamp", is("2023-10-22T17:05:40.654Z")))
			.andExpect(jsonPath(prefix + ".createdAt", is("2023-10-05T11:25:40.456Z")))
			.andExpect(jsonPath(prefix + ".tags", hasSize(5)))
			.andExpect(jsonPath(prefix + ".tags[*].selected", contains(true, true, true, true, true)))
			.andExpect(jsonPath(prefix + ".tags[0].tagName", is("housing")))
			.andExpect(jsonPath(prefix + ".tags[1].tagName", is("job-training")))
			.andExpect(jsonPath(prefix + ".tags[2].tagName", is("legal-aid")))
			.andExpect(jsonPath(prefix + ".tags[3].tagName", is("transportation")))
			.andExpect(jsonPath(prefix + ".tags[4].tagName", is("utilities")));
		return result;
	}

	ResultActions checkRecipient5PublicData(ResultActions result, String prefix) throws Exception {
		result.andExpect(jsonPath(prefix).exists())
			.andExpect(jsonPath(prefix + ".id", is(5)))
			.andExpect(jsonPath(prefix + ".nickname", is("Sare")))
			.andExpect(jsonPath(prefix + ".lastAboutMe", is("About Sarah")))
			.andExpect(jsonPath(prefix + ".lastReasonForHelp", is("Reason 3")))
			.andExpect(jsonPath(prefix + ".imageUrl", is("http://example.com/image3.jpg")))
			.andExpect(jsonPath(prefix + ".lastDonationTimestamp").doesNotExist())
			.andExpect(jsonPath(prefix + ".createdAt", is("2023-10-20T14:25:30.123Z")))
			.andExpect(jsonPath(prefix + ".tags", hasSize(5)))
			.andExpect(jsonPath(prefix + ".tags[*].selected", contains(true, true, true, true, true)))
			.andExpect(jsonPath(prefix + ".tags[0].tagName", is("childcare")))
			.andExpect(jsonPath(prefix + ".tags[1].tagName", is("food-banks")))
			.andExpect(jsonPath(prefix + ".tags[2].tagName", is("housing")))
			.andExpect(jsonPath(prefix + ".tags[3].tagName", is("job-training")))
			.andExpect(jsonPath(prefix + ".tags[4].tagName", is("mental-health")));
		return result;
	}

	ResultActions checkPrivateRecipientPropertiesNotPresent(ResultActions result, String prefix) throws Exception {
		result.andExpect(jsonPath(prefix + ".user").doesNotExist())
			.andExpect(jsonPath(prefix + ".firstName").doesNotExist())
			.andExpect(jsonPath(prefix + ".lastName").doesNotExist())
			.andExpect(jsonPath(prefix + ".streetAddress1").doesNotExist())
			.andExpect(jsonPath(prefix + ".streetAddress2").doesNotExist())
			.andExpect(jsonPath(prefix + ".city").doesNotExist())
			.andExpect(jsonPath(prefix + ".state").doesNotExist())
			.andExpect(jsonPath(prefix + ".zipCode").doesNotExist())
			.andExpect(jsonPath(prefix + ".identityLastVerified").doesNotExist())
			.andExpect(jsonPath(prefix + ".incomeLastVerified").doesNotExist())
			.andExpect(jsonPath(prefix + ".formQuestions").doesNotExist());
		return result;
	}

}
