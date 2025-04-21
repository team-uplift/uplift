package org.upLift.api;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.upLift.model.Donation;
import org.upLift.model.Recipient;
import org.upLift.model.TremendousOrderResponse;
import org.upLift.model.UpliftJsonViews;
import org.upLift.services.DonationService;
import org.upLift.services.RecipientService;
import org.upLift.services.TremendousService;
import org.upLift.services.UserService;

import java.time.Instant;
import java.util.List;

@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen",
		date = "2025-03-16T14:18:35.909799305Z[GMT]")
@RestController
public class DonationsApiController implements DonationsApi {

	private static final Logger LOG = LoggerFactory.getLogger(DonationsApiController.class);

	private final HttpServletRequest request;

	private final TremendousService tremendousService;

	private final UserService userService;

	private final DonationService donationService;

	private final RecipientService recipientService;

	@Autowired
	public DonationsApiController(HttpServletRequest request, TremendousService tremendousService,
			UserService userService, DonationService donationService, RecipientService recipientService) {
		this.request = request;
		this.tremendousService = tremendousService;
		this.userService = userService;
		this.donationService = donationService;
		this.recipientService = recipientService;
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
	public ResponseEntity<Donation> donationsPost(@Valid @RequestBody Donation body) {
		LOG.info("Donation from donor {} to recipient {}", body.getDonorId(), body.getRecipientId());
		LOG.debug("Donation body: {}", body);
		String accept = request.getHeader("Accept");
		if (accept != null) {
			try {
				var donor = userService.getUserById(body.getDonorId());
				var recipient = userService.getUserById(body.getRecipientId());
				if (donor.isPresent() && donor.get().isDonor() && recipient.isPresent()
						&& recipient.get().isRecipient()) {

					TremendousOrderResponse response = tremendousService.submitDonationOrder(recipient.get(),
							donor.get(), body.getAmount());
					LOG.debug("Donation order response: {}", response);

					Donation newDonation = donationService.saveDonation(body);
					LOG.info("Donation submitted successfully");

					// Save last donation timestamp on recipient
					Recipient recipientObject = recipientService.getRecipientById(body.getRecipientId());
					recipientObject.setLastDonationTimestamp(Instant.now());
					recipientService.saveRecipient(recipientObject);

					return new ResponseEntity<>(newDonation, HttpStatus.CREATED);
				}
				else {
					LOG.error("Couldn't find recipient or donor. Check Ids.");
					return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
				}

			}
			catch (RuntimeException e) {
				LOG.error("Couldn't serialize response for content type application/json", e);
				return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		LOG.error("Couldn't accept request check headers");
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}

}
