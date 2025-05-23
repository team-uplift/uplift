/**
 * The TremendousServiceImpl orchestrates the creation and submission of donation orders to the external Tremendous API
 * using Spring’s reactive WebClient. When submitDonationOrder is invoked with a recipient, donor, and donation amount,
 * it builds a TremendousOrderRequest and forwards it to the private postTremendousTransaction method. There, it issues
 * an HTTP POST—injecting the Tremendous base URL and API key from environment variables—serializes the request as JSON,
 * and retrieves the response reactively. It registers error handlers for HTTP 400 and 422 statuses that log the error
 * body and rethrow a RuntimeException with a “Bad request” message. Finally, it converts the successful response into
 * a TremendousOrderResponse and blocks until the remote call completes, returning that response to the caller.
 */
package org.upLift.services;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.upLift.model.TremendousOrderRequest;
import org.upLift.model.TremendousOrderResponse;
import org.upLift.model.User;
import reactor.core.publisher.Mono;

@Service
public class TremendousServiceImpl implements TremendousService {

	private static final Logger log = LoggerFactory.getLogger(TremendousServiceImpl.class);

	private final WebClient webClient;

	public TremendousServiceImpl(WebClient.Builder webClientBuilder) {
		this.webClient = webClientBuilder.baseUrl(System.getenv("TREMENDOUS_URL") + System.getenv("TRE_ORDERS_PATH"))
			.build();
	}

	@Override
	public TremendousOrderResponse submitDonationOrder(User recipient, User donor, int donationAmount) {
		TremendousOrderRequest orderRequest = new TremendousOrderRequest(recipient, donationAmount);
		return postTremendousTransaction(orderRequest);
	}

	/***
	 * PRIVATE that send the actual HTTP POST request to the tremendous service. Using
	 * reactive requests for async processing potential. Keep in mind that the order being
	 * sent won't be "finalized" until the recipient accepts it through email. Although
	 * we'll get a response back, this opens up async processing if needed.
	 *
	 * Potentially if the order operation takes too long from tremendous and we need to
	 * respond to the UI sooner, we remove the .block() and return an async
	 * Mono<TremendousOrderResponse> that we validate after the fact (Similarly to how the
	 * 400 is being handled) and respond to the UI earlier with some "pending" status. But
	 * let's wait for our integrations before pre-optimizing this.
	 * @param orderRequest
	 * @return
	 */
	private TremendousOrderResponse postTremendousTransaction(TremendousOrderRequest orderRequest) {
		return webClient.post()
			// .uri(System.getenv("TREMENDOUS_URL") + System.getenv("TRE_ORDERS_PATH"))
			.header("Authorization", "Bearer " + System.getenv("TREMENDOUS_API_KEY"))
			.header("Content-Type", "application/json")
			.bodyValue(orderRequest)
			.retrieve()
			.onStatus(status -> status.value() == 400,
					response -> response.bodyToMono(String.class).flatMap(errorMessage -> {
						log.error("400 Error: {}", errorMessage);
						return Mono.error(new RuntimeException("Bad request: " + errorMessage));
					}))
			.onStatus(status -> status.value() == 422,
					response -> response.bodyToMono(String.class).flatMap(errorMessage -> {
						log.error("422 Error: {}", errorMessage);
						return Mono.error(new RuntimeException("Bad request: " + errorMessage));
					}))
			.bodyToMono(TremendousOrderResponse.class)
			.block(); // Blocking operation that waits for the response. NOTE: This could
						// potentially
	}

}
