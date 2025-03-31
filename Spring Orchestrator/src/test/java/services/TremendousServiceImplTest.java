package services;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClient.RequestBodyUriSpec;
import org.springframework.web.reactive.function.client.WebClient.RequestHeadersSpec;
import org.springframework.web.reactive.function.client.WebClient.RequestHeadersUriSpec;
import org.springframework.web.reactive.function.client.WebClient.ResponseSpec;
import org.springframework.web.reactive.function.client.WebClient.Builder;
import org.springframework.http.HttpStatus;
import org.springframework.web.reactive.function.client.ExchangeFilterFunction;
import org.upLift.model.*;
import org.upLift.services.DonationService;
import org.upLift.services.TremendousServiceImpl;
import reactor.core.publisher.Mono;
import uk.org.webcompere.systemstubs.environment.EnvironmentVariables;
import uk.org.webcompere.systemstubs.jupiter.SystemStub;
import uk.org.webcompere.systemstubs.jupiter.SystemStubsExtension;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(SystemStubsExtension.class)
class TremendousServiceImplTest {

	@SystemStub
	private EnvironmentVariables environmentVariables;

	private WebClient webClient;

	private TremendousServiceImpl tremendousService;

	private WebClient.RequestBodyUriSpec requestBodyUriSpec;

	private WebClient.RequestHeadersSpec requestHeadersSpec;

	private WebClient.ResponseSpec responseSpec;

	@BeforeEach
	void setUp() {
		environmentVariables.set("TREMENDOUS_URL", "example.com");
		environmentVariables.set("TRE_ORDERS_PATH", "/orders/test");
		environmentVariables.set("TREMENDOUS_API_KEY", "test123");

		Builder webClientBuilder = mock(WebClient.Builder.class);
		webClient = mock(WebClient.class);
		requestBodyUriSpec = mock(WebClient.RequestBodyUriSpec.class);
		requestHeadersSpec = mock(WebClient.RequestHeadersSpec.class);
		responseSpec = mock(WebClient.ResponseSpec.class);

		when(webClientBuilder.baseUrl(anyString())).thenReturn(webClientBuilder);
		when(webClientBuilder.build()).thenReturn(webClient);

		tremendousService = new TremendousServiceImpl(webClientBuilder);
	}

	@Test
	void testSubmitDonationOrder_Success() {
		User recipient = new User();
		recipient.setEmail("jane@test.com");

		Recipient recipientData = new Recipient();
		recipientData.setFirstName("Jane");
		recipientData.setLastName("Doe");

		recipient.setRecipientData(recipientData);
		User donor = new User();
		donor.setEmail("john@test.com");

		Donor donorData = new Donor();
		donorData.setId(111);
		donor.setDonorData(donorData);

		int donationAmount = 5;
		TremendousOrderRequest request = new TremendousOrderRequest(recipient, donationAmount);
		TremendousOrderResponse expectedResponse = new TremendousOrderResponse();

		when(webClient.post()).thenReturn(requestBodyUriSpec);
		when(requestBodyUriSpec.uri(anyString())).thenReturn(requestBodyUriSpec);
		when(requestBodyUriSpec.header(anyString(), anyString())).thenReturn(requestBodyUriSpec);
		when(requestBodyUriSpec.bodyValue(any())).thenReturn(requestHeadersSpec);
		when(requestHeadersSpec.retrieve()).thenReturn(responseSpec);
		when(responseSpec.onStatus(any(), any())).thenReturn(responseSpec);
		when(responseSpec.bodyToMono(TremendousOrderResponse.class)).thenReturn(Mono.just(expectedResponse));

		TremendousOrderResponse result = tremendousService.submitDonationOrder(recipient, donor, donationAmount);

		assertEquals(expectedResponse, result); // Method returns null, ensuring no
												// exceptions were thrown
	}

	@Test
	void testSubmitDonationOrder_BadRequest() {
		User recipient = new User();
		recipient.setEmail("jane@test.com");

		Recipient recipientData = new Recipient();
		recipientData.setFirstName("Jane");
		recipientData.setLastName("Doe");

		recipient.setRecipientData(recipientData);
		User donor = new User();
		donor.setEmail("john@test.com");

		Donor donorData = new Donor();
		donorData.setId(111);
		donor.setDonorData(donorData);
		int donationAmount = 5;

		when(webClient.post()).thenReturn(requestBodyUriSpec);
		when(requestBodyUriSpec.uri(anyString())).thenReturn(requestBodyUriSpec);
		when(requestBodyUriSpec.header(anyString(), anyString())).thenReturn(requestBodyUriSpec);
		when(requestBodyUriSpec.bodyValue(any())).thenReturn(requestHeadersSpec);
		when(requestHeadersSpec.retrieve()).thenReturn(responseSpec);
		when(responseSpec.onStatus(any(), any())).thenReturn(responseSpec);
		when(responseSpec.bodyToMono(TremendousOrderResponse.class))
			.thenReturn(Mono.error(new RuntimeException("Bad request")));

		Exception exception = assertThrows(RuntimeException.class,
				() -> tremendousService.submitDonationOrder(recipient, donor, donationAmount));

		assertTrue(exception.getMessage().contains("Bad request"));
	}

}
