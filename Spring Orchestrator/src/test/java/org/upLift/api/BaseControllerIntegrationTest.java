package org.upLift.api;

import org.mockito.Mockito;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.Primary;
import org.upLift.model.TremendousOrderResponse;
import org.upLift.services.TremendousService;

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

}
