package org.upLift.services;

import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.upLift.model.*;
import reactor.core.publisher.Mono;

import java.math.BigDecimal;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@Service
@Transactional
public class TremendousServiceImpl implements TremendousService {

    private final WebClient webClient;

    public TremendousServiceImpl(WebClient.Builder webClientBuilder) {
        this.webClient = webClientBuilder.baseUrl(System.getenv("TREMENDOUS_URL")).build();;
    }

    @Override
    public String submitDonationOrder(User recipient, User donor, int donationAmount) {
        TremendousOrderRequest orderRequest = new TremendousOrderRequest(recipient, donationAmount);
        TremendousOrderResponse orderResponse = postTremendousTransaction(orderRequest);

        createDonationLog(recipient, donor, donationAmount);
        return null;
    }

    /***
     * PRIVATE that send the actual HTTP POST request to the tremendous service. Using reactive requests for async
     * processing potential. Keep in mind that the order being sent won't be "finalized" until the recipient accepts it
     * through email. Although we'll get a response back, this opens up async processing if needed.
     *
     * Potentially if the order operation takes too long from tremendous and we need to respond to the UI sooner, we remove the .block()
     * and return an async Mono<TremendousOrderResponse> that we validate after the fact (Similarly to how the 400 is being handled)
     * and respond to the UI earlier with some "pending" status. But let's wait for our integrations before pre-optimizing this.
     * @param orderRequest
     * @return
     */
    private TremendousOrderResponse postTremendousTransaction(TremendousOrderRequest orderRequest) {
        return webClient.post()
                .uri(System.getenv("TRE_ORDERS_PATH"))
                .bodyValue(orderRequest)
                .retrieve()
                .onStatus(status -> status.value() == 400, response ->
                        response.bodyToMono(String.class)
                                .flatMap(errorMessage -> {
                                    System.err.println("400 Error: " + errorMessage);
                                    return Mono.error(new RuntimeException("Bad request: " + errorMessage));
                                })
                )
                .bodyToMono(TremendousOrderResponse.class)
                .block(); // Blocking operation that waits for the response. NOTE: This could potentially
    }

    /**
     * PRIVATE Method that saves/logs the donation into our donations table.
     * @param recipient
     * @param donor
     * @param donationAmount
     * @return
     */
    private void createDonationLog(User recipient, User donor, int donationAmount) {
        return;
    }
}
