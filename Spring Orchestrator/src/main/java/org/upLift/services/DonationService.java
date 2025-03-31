package org.upLift.services;

import org.springframework.validation.annotation.Validated;
import org.upLift.model.Donation;

import java.util.List;
import java.util.Optional;

@Validated
public interface DonationService {

	Optional<Donation> getDonationById(int id);

	List<Donation> getAllDonations();

	List<Donation> getDonationsByDonorId(Integer donorId);

	List<Donation> getDonationsByRecipientId(Integer recipientId);

	Donation saveDonation(Donation donation);

}
