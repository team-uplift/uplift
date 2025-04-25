package org.upLift.api;

import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.upLift.exceptions.BadRequestException;
import org.upLift.exceptions.EntityNotFoundException;
import org.upLift.model.Donation;
import org.upLift.model.Recipient;
import org.upLift.model.TremendousOrderResponse;
import org.upLift.services.DonationService;
import org.upLift.services.RecipientService;
import org.upLift.services.TremendousService;
import org.upLift.services.UserService;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen",
		date = "2025-03-16T14:18:35.909799305Z[GMT]")
@RestController
public class DonationsApiController implements DonationsApi {

	private static final Logger LOG = LoggerFactory.getLogger(DonationsApiController.class);

	private final TremendousService tremendousService;

	private final UserService userService;

	private final DonationService donationService;

	private final RecipientService recipientService;

	@Autowired
	public DonationsApiController(TremendousService tremendousService, UserService userService,
			DonationService donationService, RecipientService recipientService) {
		this.tremendousService = tremendousService;
		this.userService = userService;
		this.donationService = donationService;
		this.recipientService = recipientService;
	}

	@Override
	public Donation donationsIdGetForDonor(String userType, Integer id) {
		LOG.info("Getting donation {} for donor user", id);
		return getDonationById(userType, id);
	}

	@Override
	public Donation donationsIdGetForRecipient(String userType, Integer id) {
		LOG.info("Getting donation {} for recipient user with userType {}", id, userType);
		return getDonationById(userType, id);
	}

	Donation getDonationById(String userType, Integer id) {
		Optional<Donation> donation;
		if (userType == null || userType.equalsIgnoreCase("recipient")) {
			donation = donationService.getDonationWithDonorById(id);
		}
		else if (userType.equalsIgnoreCase("donor")) {
			donation = donationService.getDonationWithRecipientById(id);
		}
		else {
			throw new BadRequestException("Incorrect userType query parameter provided: " + userType);
		}
		if (donation.isPresent()) {
			return donation.get();
		}
		else {
			throw new EntityNotFoundException(id, "Donation", "Donation not found");
		}
	}

	// Marked as public recipient so that donor doesn't get access to full recipient info
	@Override
	public List<Donation> donationsGetByDonor(@PathVariable("donorId") Integer id) {
		if (userService.donorExists(id)) {
			return donationService.getDonationsByDonorId(id);
		}
		else {
			throw new EntityNotFoundException(id, "Donor", "Donor not found");
		}
	}

	// Marked as public donor so that recipient doesn't get access to full donor info
	@Override
	public List<Donation> donationsGetByRecipient(@PathVariable("recipientId") Integer id) {
		if (userService.recipientExists(id)) {
			return donationService.getDonationsByRecipientId(id);
		}
		else {
			throw new EntityNotFoundException(id, "Recipient", "Recipient not found");
		}
	}

	// Marked as public recipient so that donor doesn't get access to full recipient info
	@Override
	public ResponseEntity<Donation> donationsPost(@Valid @RequestBody Donation body) {
		LOG.info("Donation from donor {} to recipient {}", body.getDonorId(), body.getRecipientId());
		LOG.debug("Donation body: {}", body);
		try {
			var donor = userService.getUserById(body.getDonorId());
			var recipient = userService.getUserById(body.getRecipientId());
			if (donor.isPresent() && donor.get().isDonor() && recipient.isPresent() && recipient.get().isRecipient()) {

				TremendousOrderResponse response = tremendousService.submitDonationOrder(recipient.get(), donor.get(),
						body.getAmount());
				LOG.debug("Donation order response: {}", response);
				LOG.debug("Donation order: {}", response.getOrder() != null ? response.getOrder().getId() : "NO ORDER");

				Donation newDonation = donationService.saveDonation(body);
				LOG.info("Donation submitted successfully");

				// Save last donation timestamp on recipient
				Recipient recipientObject = recipientService.getRecipientById(body.getRecipientId());
				recipientObject.setLastDonationTimestamp(Instant.now());
				recipientService.saveRecipient(recipientObject);
				newDonation.setRecipient(recipientObject);

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

}
