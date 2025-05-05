package org.upLift.services;

import org.springframework.validation.annotation.Validated;
import org.upLift.model.Donation;

import java.util.List;
import java.util.Optional;

/**
 * Service interface for managing donations.
 */
@Validated
public interface DonationService {

	/**
	 * Retrieves a donation by its ID.
	 * @param id the ID of the donation to retrieve
	 * @return an {@link Optional} containing the donation if found, or empty if not found
	 */
	Optional<Donation> getDonationById(int id);

	/**
	 * Retrieves all donations made by a specific donor.
	 * @param donorId the ID of the donor
	 * @return a list of donations made by the donor
	 */
	List<Donation> getDonationsByDonorId(Integer donorId);

	/**
	 * Retrieves all donations received by a specific recipient.
	 * @param recipientId the ID of the recipient
	 * @return a list of donations received by the recipient
	 */
	List<Donation> getDonationsByRecipientId(Integer recipientId);

	/**
	 * Saves a donation to the database.
	 * @param donation the donation to save
	 * @return the saved donation
	 */
	Donation saveDonation(Donation donation);

}
