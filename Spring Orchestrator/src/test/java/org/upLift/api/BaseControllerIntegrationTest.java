package org.upLift.api;

import org.mockito.Mockito;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.Primary;
import org.springframework.test.web.servlet.ResultActions;
import org.upLift.model.TremendousOrderResponse;
import org.upLift.services.TremendousService;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

@SuppressWarnings("UnusedReturnValue")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK,
		properties = { "spring.datasource.url=jdbc:h2:mem:controller;DB_CLOSE_DELAY=-1;TIME ZONE=UTC" })
@AutoConfigureMockMvc
@Import(BaseControllerIntegrationTest.TestConfig.class)
abstract class BaseControllerIntegrationTest {

	@TestConfiguration
	static class TestConfig {

		@Bean
		@Primary
		public TremendousService tremendousService() {
			// Create a mock of the TremendousService so we're not using up our actual
			// Tremendous sandbox calls
			TremendousService mockService = Mockito.mock(TremendousService.class);
			// Add an orderId so we can check the log to make sure this Mock is used
			Mockito.doReturn(new TremendousOrderResponse("TESTING"))
				.when(mockService)
				.submitDonationOrder(Mockito.any(), Mockito.any(), Mockito.anyInt());
			return mockService;
		}

	}

	ResultActions checkRecipient1PublicData(ResultActions result, String prefix) throws Exception {
		result.andExpect(jsonPath(prefix + ".recipient").exists())
			.andExpect(jsonPath(prefix + ".recipient.id", is(1)))
			.andExpect(jsonPath(prefix + ".recipient.nickname", is("Johnny")))
			.andExpect(jsonPath(prefix + ".recipient.lastAboutMe", is("About John")))
			.andExpect(jsonPath(prefix + ".recipient.lastReasonForHelp", is("Reason 1")))
			.andExpect(jsonPath(prefix + ".recipient.imageUrl", is("http://example.com/image1.jpg")))
			.andExpect(jsonPath(prefix + ".recipient.lastDonationTimestamp", is("2023-10-23T18:10:50.987Z")))
			.andExpect(jsonPath(prefix + ".recipient.createdAt", is("2023-10-01T10:20:30.123Z")))
			.andExpect(jsonPath(prefix + ".recipient.tags", hasSize(7)))
			.andExpect(jsonPath(prefix + ".recipient.tags[*].selected",
					contains(true, true, true, true, true, true, true)))
			.andExpect(jsonPath(prefix + ".recipient.tags[0].tagName", is("childcare")))
			.andExpect(jsonPath(prefix + ".recipient.tags[1].tagName", is("clothing")))
			.andExpect(jsonPath(prefix + ".recipient.tags[2].tagName", is("food")))
			.andExpect(jsonPath(prefix + ".recipient.tags[3].tagName", is("health")))
			.andExpect(jsonPath(prefix + ".recipient.tags[4].tagName", is("housing")))
			.andExpect(jsonPath(prefix + ".recipient.tags[5].tagName", is("mental-health")))
			.andExpect(jsonPath(prefix + ".recipient.tags[6].tagName", is("utilities")));
		return result;
	}

	ResultActions checkRecipient2PublicData(ResultActions result, String prefix) throws Exception {
		// Check that recipient data is included
		result.andExpect(jsonPath(prefix + ".recipient").exists())
			.andExpect(jsonPath(prefix + ".recipient.id", is(2)))
			.andExpect(jsonPath(prefix + ".recipient.nickname", is("Janie")))
			.andExpect(jsonPath(prefix + ".recipient.lastAboutMe", is("About Jane")))
			.andExpect(jsonPath(prefix + ".recipient.lastReasonForHelp", is("Reason 2")))
			.andExpect(jsonPath(prefix + ".recipient.imageUrl", is("http://example.com/image2.jpg")))
			.andExpect(jsonPath(prefix + ".recipient.lastDonationTimestamp", is("2023-10-22T17:05:40.654Z")))
			.andExpect(jsonPath(prefix + ".recipient.createdAt", is("2023-10-05T11:25:40.456Z")))
			.andExpect(jsonPath(prefix + ".recipient.tags", hasSize(5)))
			.andExpect(jsonPath(prefix + ".recipient.tags[*].selected", contains(true, true, true, true, true)))
			.andExpect(jsonPath(prefix + ".recipient.tags[0].tagName", is("housing")))
			.andExpect(jsonPath(prefix + ".recipient.tags[1].tagName", is("job-training")))
			.andExpect(jsonPath(prefix + ".recipient.tags[2].tagName", is("legal-aid")))
			.andExpect(jsonPath(prefix + ".recipient.tags[3].tagName", is("transportation")))
			.andExpect(jsonPath(prefix + ".recipient.tags[4].tagName", is("utilities")));
		return result;
	}

	ResultActions checkRecipient5PublicData(ResultActions result, String prefix) throws Exception {
		result.andExpect(jsonPath(prefix + ".recipient").exists())
			.andExpect(jsonPath(prefix + ".recipient.id", is(5)))
			.andExpect(jsonPath(prefix + ".recipient.nickname", is("Sare")))
			.andExpect(jsonPath(prefix + ".recipient.lastAboutMe", is("About Sarah")))
			.andExpect(jsonPath(prefix + ".recipient.lastReasonForHelp", is("Reason 3")))
			.andExpect(jsonPath(prefix + ".recipient.imageUrl", is("http://example.com/image3.jpg")))
			.andExpect(jsonPath(prefix + ".recipient.lastDonationTimestamp").doesNotExist())
			.andExpect(jsonPath(prefix + ".recipient.createdAt", is("2023-10-20T14:25:30.123Z")))
			.andExpect(jsonPath(prefix + ".recipient.tags", hasSize(5)))
			.andExpect(jsonPath(prefix + ".recipient.tags[*].selected", contains(true, true, true, true, true)))
			.andExpect(jsonPath(prefix + ".recipient.tags[0].tagName", is("childcare")))
			.andExpect(jsonPath(prefix + ".recipient.tags[1].tagName", is("food-banks")))
			.andExpect(jsonPath(prefix + ".recipient.tags[2].tagName", is("housing")))
			.andExpect(jsonPath(prefix + ".recipient.tags[3].tagName", is("job-training")))
			.andExpect(jsonPath(prefix + ".recipient.tags[4].tagName", is("mental-health")));
		return result;
	}

	ResultActions checkPrivateRecipientPropertiesNotPresent(ResultActions result, String prefix) throws Exception {
		result.andExpect(jsonPath(prefix + ".recipient.user").doesNotExist())
			.andExpect(jsonPath(prefix + ".recipient.firstName").doesNotExist())
			.andExpect(jsonPath(prefix + ".recipient.lastName").doesNotExist())
			.andExpect(jsonPath(prefix + ".recipient.streetAddress1").doesNotExist())
			.andExpect(jsonPath(prefix + ".recipient.streetAddress2").doesNotExist())
			.andExpect(jsonPath(prefix + ".recipient.city").doesNotExist())
			.andExpect(jsonPath(prefix + ".recipient.state").doesNotExist())
			.andExpect(jsonPath(prefix + ".recipient.zipCode").doesNotExist())
			.andExpect(jsonPath(prefix + ".recipient.identityLastVerified").doesNotExist())
			.andExpect(jsonPath(prefix + ".recipient.incomeLastVerified").doesNotExist())
			.andExpect(jsonPath(prefix + ".recipient.formQuestions").doesNotExist());
		return result;
	}

}
