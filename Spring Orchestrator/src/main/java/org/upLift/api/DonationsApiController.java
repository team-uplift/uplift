package org.upLift.api;

import com.fasterxml.jackson.annotation.JsonView;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.media.Schema;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;
import org.upLift.model.Donation;
import org.upLift.model.UpliftJsonViews;
import org.upLift.services.DonationService;
import org.upLift.services.UserService;

import jakarta.validation.Valid;
import jakarta.servlet.http.HttpServletRequest;
import org.upLift.model.TremendousOrderResponse;
import org.upLift.model.User;
import org.upLift.services.DonationService;
import org.upLift.services.TremendousService;
import org.upLift.services.UserService;

import java.io.IOException;
import java.util.List;

@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen",
		date = "2025-03-16T14:18:35.909799305Z[GMT]")
@RestController
public class DonationsApiController implements DonationsApi {

	private static final Logger log = LoggerFactory.getLogger(DonationsApiController.class);

	private final ObjectMapper objectMapper;

	private final HttpServletRequest request;

	private final TremendousService tremendousService;

	private final UserService userService;

	private final DonationService donationService;

	@Autowired
	public DonationsApiController(ObjectMapper objectMapper, HttpServletRequest request,
			TremendousService tremendousService, UserService userService, DonationService donationService) {
		this.objectMapper = objectMapper;
		this.request = request;
		this.tremendousService = tremendousService;
		this.userService = userService;
		this.donationService = donationService;
	}

	@Override
	public ResponseEntity<Donation> donationsIdGet(@PathVariable("id") Integer id) {
		var donation = donationService.getDonationById(id);
		if (donation.isPresent()) {
			return new ResponseEntity<>(donation.get(), HttpStatus.OK);
		}
		else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	@Override
	@JsonView(UpliftJsonViews.FullRecipient.class)
	public ResponseEntity<List<Donation>> donationsGetByDonor(@PathVariable("donorId") Integer id) {
		if (userService.donorExists(id)) {
			var donations = donationService.getDonationsByDonorId(id);
			return new ResponseEntity<>(donations, HttpStatus.OK);
		}
		else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	@Override
	@JsonView(UpliftJsonViews.FullDonor.class)
	public ResponseEntity<List<Donation>> donationsGetByRecipient(@PathVariable("recipientId") Integer id) {
		if (userService.recipientExists(id)) {
			var donations = donationService.getDonationsByRecipientId(id);
			return new ResponseEntity<>(donations, HttpStatus.OK);
		}
		else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	@Override
	public ResponseEntity<Donation> donationsPost(
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			@Parameter(in = ParameterIn.DEFAULT, description = "", required = true,
					schema = @Schema()) @Valid @RequestBody Donation body) {
		String accept = request.getHeader("Accept");
		if (accept != null) {
			try {
				User recipient;
				User donor;

				if (userService.getUserById(body.getRecipientId()).isPresent()
						&& userService.getUserById(body.getDonorId()).isPresent()) {
					recipient = userService.getUserById(body.getRecipientId()).get();
					donor = userService.getUserById(body.getDonorId()).get();

					TremendousOrderResponse response = tremendousService.submitDonationOrder(recipient, donor,
							body.getAmount());

					Donation donation = new Donation();
					donation.setRecipientId(recipient.getId());
					donation.setDonorId(donor.getId());
					donation.setAmount(body.getAmount());
					donation.setRecipient(recipient.getRecipientData());
					donation.setDonor(donor.getDonorData());

					Donation newDonation = donationService.saveDonation(donation);

					return new ResponseEntity<>(newDonation, HttpStatus.CREATED);
				}
				else {
					log.error("Couldn't find recipient or donor. Check Ids.");
					return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
				}

			}
			catch (RuntimeException e) {
				log.error("Couldn't serialize response for content type application/json", e);
				return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		log.error("Couldn't accept request check headers");
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}

}
