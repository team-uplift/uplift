package org.upLift.services;

import org.upLift.model.Donation;
import java.util.List;

public interface DonationService {

	Donation saveDonation(Donation donation);

	List<Donation> getAllDonations();

	List<Donation> getDonationsByDonorId(Integer donorId);

	List<Donation> getDonationsByRecipientId(Integer recipientId);

}